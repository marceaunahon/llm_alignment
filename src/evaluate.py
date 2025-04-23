import os
import pickle
import json
import argparse
import pandas as pd
from tqdm import tqdm
import torch

from src.models import (
    CohereModel,
    OpenAIModel,
    AnthropicModel,
    FlanT5Model,
    OptImlModel,
    PalmModel,
    create_model,
)
from src.question_form_generator import get_question_form
from src.semantic_matching import token_to_action_matching

from src.config import PATH_RESULTS, PATH_RESPONSE_TEMPLATES, PATH_RULES

torch.cuda.empty_cache()


################################################################################################
# ARGUMENT PARSER
################################################################################################
parser = argparse.ArgumentParser(description="LLM Evaluation on MoralChoice")
parser.add_argument(
    "--experiment-name",
    default="test",
    type=str,
    help="Name of Experiment - used for logging",
)
parser.add_argument(
    "--dataset", default="high", type=str, help="Dataset to evaluate (low or high)"
)
parser.add_argument(
    "--model-name",
    default="openai/text-babbage-001",
    type=str,
    help="Model to evalute --- see models.py for an overview of supported models",
)
parser.add_argument(
    "--question-types",
    default=["ab"],
    type=str,
    help="Question Templates to evaluate",
    nargs="+",
)
parser.add_argument(
    "--eval-technique",
    default="top_p_sampling",
    type=str,
    help="Evaluation Technique (top_p_sampling is only supported technique right now)",
)
parser.add_argument(
    "--eval-top-p", default=1.0, type=float, help="Top-P parameter for top-p sampling"
)
parser.add_argument(
    "--eval-temp", default=1.0, type=float, help="Temperature for sampling"
)
parser.add_argument(
    "--eval-max-tokens",
    default=200,
    type=int,
    help="Max. number of tokens per completion",
)
parser.add_argument(
    "--eval-nb-samples", default=1, type=int, help="Nb. of samples per question form"
)
parser.add_argument(
    "--dataset-folder", default="isir", type=str, help="Folder to load dataset from"
)

parser.add_argument(
    "--sep", default=",", type=str, help="Separator for CSV files"
) 

parser.add_argument(
    "--rule", default=False, type=bool, help="Whether to specify a  rule in the prompt"
)

parser.add_argument(
    "--answer-types",
    default=None,
    type=str,
    help="Question Templates to evaluate",
    nargs="+",
)

parser.add_argument(
    "--specify-rule", default=False, type=bool, help="Whether to specify a  rule in the prompt")

parser.add_argument(
    "--personality", default="AI", type=str, help="Personality of the LLM"
)
args = parser.parse_args()

################################################################################################
# SETUP
################################################################################################

# Load scenarios
init_scenarios = pd.read_csv(f"data/{args.dataset_folder}_scenarios/moralchoice_{args.dataset}_ambiguity.csv", sep=args.sep) 
#keep only the first 10 scenarios for testing
# init_scenarios = init_scenarios.head(30)
nb_scenarios = len(init_scenarios)

done_ids = []
path_model = f"{PATH_RESULTS}/{args.experiment_name}/{args.dataset}_raw/{args.model_name.split('/')[-1]}"
last_question_type = args.question_types[-1]
path_model_questiontype = path_model + f"/{last_question_type}"
for scenario_id in init_scenarios["scenario_id"]:
    if os.path.exists(f"{path_model_questiontype}/scenario_{scenario_id}.pickle"):
        done_ids.append(scenario_id)
    else :
        break
scenarios = init_scenarios[~init_scenarios["scenario_id"].isin(done_ids)]

if len(done_ids) == 0:
    print("Starting evaluation from scratch")
elif len(done_ids) >= nb_scenarios:
    print("All scenarios have been evaluated. Try again with a different model, question type or experiment name.")
    # choice = input("Erase ? (yes/no) : ")
    # while choice not in ["yes", "no"]:
    #     print("Please enter yes or no")
    # if choice == "no" :
    #     exit()
    # if choice == "yes" :
    #     scenarios = init_scenarios
    exit()

else:
    print(f"{len(done_ids)} scenarios have already been evaluated.")    
    print(f"Resuming evaluation from scenario {scenarios['scenario_id'].iloc[0]}")

# Load rules 
with open(f"{PATH_RULES}/rules.json", encoding="utf-8") as f:
    rules = json.load(f)
with open(f"{PATH_RULES}/refined_rules.json", encoding="utf-8") as f:
    rules_refined = json.load(f)

# Load personnalities
#with open("data\personalities.json", encoding="utf-8") as f:
#    personnalities = json.load(f)

#print(personnalities[args.personality])
personnalities = {"AI" : "an AI assistant that responds to every question in a particular format"}

# Load refusals and common answer patterns
with open(f"{PATH_RESPONSE_TEMPLATES}/refusals.txt", encoding="utf-8") as f:
    refusals = f.read().splitlines()

if args.answer_types is None : 
    response_patterns = {}
    for question_type in args.question_types:
        with open(f"{PATH_RESPONSE_TEMPLATES}/{question_type}.json", encoding="utf-8") as f:
            response_patterns[question_type] = json.load(f)
else :
    response_patterns = {}
    for answer_type in args.answer_types:
        with open(f"{PATH_RESPONSE_TEMPLATES}/{answer_type}.json", encoding="utf-8") as f:
            response_patterns[answer_type] = json.load(f)

# Create result folders
path_model = f"{PATH_RESULTS}/{args.experiment_name}/{args.dataset}_raw/{args.model_name.split('/')[-1]}"
for question_type in args.question_types:
    path_model_questiontype = path_model + f"/{question_type}"
    if not os.path.exists(path_model_questiontype):
        os.makedirs(path_model_questiontype)


################################################################################################
# RUN EVALUATION
################################################################################################
trust_remote_code = True
model = create_model(args.model_name)
for k, (identifier, scenario) in tqdm(
    enumerate(scenarios.iterrows()),
    total=len(scenarios),
    position=0,
    ncols=100,
    leave=True,
    desc=f"MoralChoice Eval: {model.get_model_id()}",
):
    for question_type in args.question_types:
        results = []

        for question_ordering in [0, 1]:
            # Get question form
            question_form, action_mapping = get_question_form(
                scenario=scenario,
                rules=rules,
                personality=personnalities[args.personality],
                question_type=question_type,
                question_ordering=question_ordering,
                system_instruction=True,
                rule=args.dataset,
                specified_rule = args.specify_rule,
            )
            
            # Set result base dict
            result_base = {
                "scenario_id": scenario["scenario_id"],
                "model_id": model.get_model_id(),
                "question_type": question_type,
                "question_ordering": question_ordering,
                "question_header": question_form["question_header"],
                "question_text": question_form["question"],
                "eval_technique": args.eval_technique,
                "eval_top_p": args.eval_top_p,
                "eval_temperature": args.eval_temp,
            }

            for nb_query in range(args.eval_nb_samples):
                result_base["eval_sample_nb"] = nb_query

                # Query model
                if args.eval_technique == "top_p_sampling":
                    response = model.get_top_p_answer(
                        prompt_base=question_form["question"],
                        prompt_system=question_form["question_header"],
                        max_tokens=args.eval_max_tokens,
                        temperature=args.eval_temp,
                        top_p=args.eval_top_p,
                    )
                elif args.eval_technique == "greedy":
                    response = model.get_greedy_answer(
                        prompt_base=question_form["question"],
                        prompt_system=question_form["question_header"],
                        max_tokens=args.eval_max_tokens,
                    )
                # Match response (token sequence) to actions
                response["decision"] = token_to_action_matching(
                    response["answer"],
                    scenario,
                    response_patterns,
                    question_type,
                    action_mapping,
                    refusals,
                )

                # Log Results
                result = {**result_base, **response}
                results.append(result)

        with open(
            f'{path_model}/{question_type}/scenario_{scenario["scenario_id"]}.pickle',
            "wb",
        ) as f:
            pickle.dump(pd.DataFrame(results), f, protocol=0)
