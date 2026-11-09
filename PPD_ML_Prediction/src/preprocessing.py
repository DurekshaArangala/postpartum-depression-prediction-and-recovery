"""Data cleaning, dataset splits, and preprocessing."""

import json
from pathlib import Path

import numpy as np
import pandas as pd
from sklearn.compose import ColumnTransformer
from sklearn.impute import SimpleImputer
from sklearn.model_selection import StratifiedGroupKFold
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder, StandardScaler

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "dataset" / "raw" / "PPD_dataset.csv"
PROCESSED = ROOT / "dataset" / "processed"
MODELS = ROOT / "models"
GRAPHS = ROOT / "outputs" / "graphs"
METRICS = ROOT / "outputs" / "metrics"
REPORTS = ROOT / "outputs" / "reports"
SEED = 42
TARGET = "EPDS Result"
LABELS = ["Low", "Medium", "High"]
CLASS_IDS = [0, 1, 2]
NUMERIC = ["Age", "Number of the latest pregnancy"]
CATEGORICAL = [
    "Residence",
    "Education Level",
    "Marital status",
    "Occupation before latest pregnancy",
    "Monthly income before latest pregnancy",
    "Husband's education level",
    "Disease before pregnancy",
    "History of pregnancy loss",
    "Family type",
    "Number of household members",
    "Major changes or losses during pregnancy",
    "Pregnancy length",
    "Pregnancy plan",
    "Regular checkups",
    "Fear of pregnancy",
    "Diseases during pregnancy",
    "Mode of delivery",
    "Depression before pregnancy",
    "Depression during pregnancy",
]
FEATURES = NUMERIC + CATEGORICAL


def read_data():
    """Keep 'None' as a real survey response and only treat blanks as missing."""
    data = pd.read_csv(DATA, keep_default_na=False, na_values=[""])
    data.columns = data.columns.str.strip()
    return data


def clean_features(data):
    """Use the same cleaning rules for training and new questionnaires."""
    clean = data[FEATURES].copy()
    for name in NUMERIC:
        clean[name] = pd.to_numeric(clean[name], errors="coerce").astype(float)
    for name in CATEGORICAL:
        values = clean[name].astype("string").str.strip().str.lower()
        values = values.replace({"": pd.NA, "house wife": "housewife"})
        if name == "Disease before pregnancy":
            values = values.replace({"1.2": pd.NA})
        clean[name] = values.astype(object).where(values.notna(), np.nan)
    return clean


def make_split():
    data = read_data()
    labels = data[TARGET].astype("string").str.strip().str.lower()
    y = labels.map({label.lower(): i for i, label in enumerate(LABELS)})
    if y.isna().any():
        raise ValueError("The data contains a missing or unexpected EPDS Result.")
    X = clean_features(data)
    y = y.astype(int)
    train, test = five_folds(X, y)[0]
    return X.iloc[train], X.iloc[test], y.iloc[train], y.iloc[test]


def profile_groups(X):
    return pd.util.hash_pandas_object(X, index=False)


def five_folds(X, y):
    """Keep identical predictor profiles together and preserve class balance."""
    cv = StratifiedGroupKFold(n_splits=5, shuffle=True, random_state=SEED)
    return list(cv.split(X, y, groups=profile_groups(X)))


def make_preprocessor():
    numbers = Pipeline([
        ("impute", SimpleImputer(strategy="median")),
        ("scale", StandardScaler()),
    ])
    categories = Pipeline([
        ("impute", SimpleImputer(strategy="most_frequent")),
        ("encode", OneHotEncoder(handle_unknown="ignore", sparse_output=False)),
    ])
    preprocess = ColumnTransformer([
        ("numbers", numbers, NUMERIC),
        ("categories", categories, CATEGORICAL),
    ], verbose_feature_names_out=False)
    preprocess.set_output(transform="pandas")
    return preprocess


def make_pipeline(model):
    return Pipeline([("preprocess", make_preprocessor()), ("model", model)])


def write_json(path, data):
    path.write_text(json.dumps(data, indent=2, allow_nan=False) + "\n", encoding="utf-8")


def export_processed_data(X_train, X_test, y_train, y_test):
    """Export clean model inputs and a common encoded table for surrogate work."""
    import joblib

    PROCESSED.mkdir(parents=True, exist_ok=True)
    MODELS.mkdir(parents=True, exist_ok=True)
    REPORTS.mkdir(parents=True, exist_ok=True)

    preprocessor = make_preprocessor()
    encoded_train = preprocessor.fit_transform(X_train)
    encoded_test = preprocessor.transform(X_test)
    for split, clean, encoded, target in (
        ("train", X_train, encoded_train, y_train),
        ("test", X_test, encoded_test, y_test),
    ):
        clean.to_csv(PROCESSED / f"X_{split}_clean.csv", index_label="row_id")
        encoded.to_csv(PROCESSED / f"X_{split}.csv", index_label="row_id")
        target.rename("class_id").to_csv(PROCESSED / f"y_{split}.csv", index_label="row_id")

    joblib.dump(preprocessor, MODELS / "reference_preprocessor.joblib", compress=3)
    write_json(REPORTS / "feature_names.json", {
        "model_input_features": FEATURES,
        "encoded_reference_features": encoded_train.columns.tolist(),
        "numeric_features": NUMERIC,
        "categorical_features": CATEGORICAL,
    })
    return encoded_train
