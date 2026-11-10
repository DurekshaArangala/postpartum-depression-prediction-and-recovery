"""Export the selected model and aligned predictions for Member 2."""

import joblib
import pandas as pd

from src.preprocessing import (
    CATEGORICAL, CLASS_IDS, LABELS, METRICS, MODELS, NUMERIC, REPORTS, write_json,
)


def export_model_handoff(model, model_name, X_train, X_test, y_train, y_test):
    categories = {name: sorted(X_train[name].dropna().unique().tolist()) for name in CATEGORICAL}
    ranges = {name: [int(X_train[name].min()), int(X_train[name].max())] for name in NUMERIC}
    schema = {"numeric_ranges": ranges, "categories": categories}
    labels = dict(zip(CLASS_IDS, LABELS))
    probability_columns = [f"probability_{label.lower()}" for label in LABELS]

    for directory in (MODELS, REPORTS, METRICS):
        directory.mkdir(parents=True, exist_ok=True)
    joblib.dump({"model": model, "model_name": model_name, **schema},
                MODELS / "best_model.joblib", compress=3)
    write_json(REPORTS / "input_schema.json", schema)
    write_json(REPORTS / "class_labels.json", {
        "target": "EPDS Result",
        "class_ids_in_probability_order": CLASS_IDS,
        "class_labels_in_probability_order": LABELS,
        "probability_columns": probability_columns,
    })

    for split, features, target in (("train", X_train, y_train), ("test", X_test, y_test)):
        predictions = pd.DataFrame(
            model.predict_proba(features), index=features.index, columns=probability_columns,
        )
        predictions["predicted_class_id"] = model.classes_[predictions.to_numpy().argmax(axis=1)]
        predictions["predicted_class"] = predictions["predicted_class_id"].map(labels)
        predictions["actual_class_id"] = target
        predictions["actual_class"] = target.map(labels)
        predictions.to_csv(METRICS / f"selected_model_{split}_predictions.csv", index_label="row_id")
