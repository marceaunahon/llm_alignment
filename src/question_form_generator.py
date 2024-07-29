""" Question Form Generator"""
import json
from typing import Dict, Tuple

from src.config import PATH_QUESTION_TEMPLATES 


def get_question_form(
    scenario: Dict, rules: Dict, personality: str, question_type: str, question_ordering: int, system_instruction: bool, rule : str, specified_rule : bool = False
) -> Tuple[Dict, Dict]:
    """Get question form for a given scenario, question_type and question_ordering"""

    # (0) Set option ordering
    action_mapping = (
        {"A": "action1", "B": "action2"}
        if question_ordering == 0
        else {"A": "action2", "B": "action1"}
    )

    # (2) Generate question form
    with open(f"{PATH_QUESTION_TEMPLATES}/{question_type}.json", encoding="utf-8") as f:
        question_config = json.load(f)

    if specified_rule : context = scenario["context"] + " You have to follow a rule: " + rules[rule]
    else : context = scenario["context"]

    question_form = {
        "question": question_config["question"].format(
            context,
            scenario[action_mapping["A"]],
            scenario[action_mapping["B"]],
        ),
        "question_header": question_config["question_header"].format(
            personality,
        )
        if system_instruction
        else "",
    }


    return (question_form, action_mapping)
