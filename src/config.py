"""PATH CONFIG"""

from pathlib import Path

# Locate root path
ROOT = Path(__file__).parent.parent

# SET PATHS
PATH_API_KEYS = ROOT / "api_keys"
PATH_HF_CACHE = ROOT / "cache"
PATH_OFFLOAD = ROOT / "offload"

PATH_RESULTS = ROOT / "data/responses2"
PATH_QUESTION_TEMPLATES = ROOT / "data/question_templates"
PATH_RESPONSE_TEMPLATES = ROOT / "data/response_templates"
PATH_RULES = ROOT / "data/rules"
