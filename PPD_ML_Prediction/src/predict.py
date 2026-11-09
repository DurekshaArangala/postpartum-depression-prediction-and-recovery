"""Predict screening classes and expose the exact model for SHAP."""

import joblib
import numpy as np
import pandas as pd

from src.preprocessing import CATEGORICAL, FEATURES, LABELS, MODELS, NUMERIC, clean_features


def load_model():
    return joblib.load(MODELS / "best_model.joblib")


def predict_risk(questionnaire, artifact=None):
    """Return a JSON-compatible prediction for one questionnaire."""
    if not isinstance(questionnaire, dict):
        raise ValueError("Send one questionnaire as a dictionary.")
    missing = sorted(set(FEATURES) - questionnaire.keys())
    extra = sorted(questionnaire.keys() - set(FEATURES))
    if missing or extra:
        raise ValueError(f"Missing fields: {missing}. Unknown fields: {extra}.")
    if artifact is None:
        artifact = load_model()

    normalized = {}
    for name in NUMERIC:
        value = questionnaire[name]
        if value is None:
            normalized[name] = None
            continue
        if isinstance(value, bool):
            raise ValueError(f"{name} must be a whole number or null.")
        try:
            value = float(value)
        except (TypeError, ValueError):
            raise ValueError(f"{name} must be a whole number or null.") from None
        low, high = artifact["numeric_ranges"][name]
        if not value.is_integer() or not low <= value <= high:
            raise ValueError(f"{name} must be a whole number from {low} to {high}.")
        normalized[name] = value
    for name in CATEGORICAL:
        value = questionnaire[name]
        if value is not None and not isinstance(value, str):
            raise ValueError(f"{name} must be text or null.")
        normalized[name] = value

    row = clean_features(pd.DataFrame([normalized]))
    if row.isna().all(axis=None):
        raise ValueError("Provide at least one valid questionnaire response.")
    for name in CATEGORICAL:
        value = row.at[0, name]
        if pd.notna(value) and value not in artifact["categories"][name]:
            raise ValueError(f"Unknown response for {name}. See input_schema.json.")

    model = artifact["model"]
    probabilities = model.predict_proba(row)[0]
    by_label = {
        LABELS[int(i)]: float(p) for i, p in zip(model.classes_, probabilities)
    }
    predicted = max(by_label, key=by_label.get)
    return {
        "model": artifact["model_name"],
        "predicted_screening_class": predicted,
        "probability_high": by_label["High"],
        "class_probabilities": by_label,
    }


def to_shap_inputs(cleaned, artifact):
    """Encode original fields reversibly for a numeric SHAP masker."""
    encoded = cleaned[FEATURES].copy()
    encoded[NUMERIC] = encoded[NUMERIC].fillna(-1)
    for name in CATEGORICAL:
        codes = pd.Categorical(cleaned[name], categories=artifact["categories"][name]).codes
        if ((codes == -1) & cleaned[name].notna()).any():
            raise ValueError(f"Unknown category in {name}. Use the exported cleaned split.")
        encoded[name] = codes
    return encoded


def make_shap_predictor(artifact, label="High"):
    """Return the selected ensemble's probability function for one class."""
    model = artifact["model"]
    class_index = model.classes_.tolist().index(LABELS.index(label))
    categories = {
        name: dict(enumerate(artifact["categories"][name])) for name in CATEGORICAL
    }

    def predict(values):
        decoded = pd.DataFrame(np.asarray(values), columns=FEATURES)
        decoded[NUMERIC] = decoded[NUMERIC].replace(-1, np.nan)
        for name in CATEGORICAL:
            decoded[name] = decoded[name].map(categories[name])
        return model.predict_proba(decoded)[:, class_index]

    return predict
