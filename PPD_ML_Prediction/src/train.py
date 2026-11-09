"""Five model candidates with small, readable tuning spaces."""

from lightgbm import LGBMClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.svm import SVC
from sklearn.utils.class_weight import compute_sample_weight
from xgboost import XGBClassifier

from src.preprocessing import SEED


class BalancedXGBClassifier(XGBClassifier):
    """Compute row weights using only the labels passed to each fit."""

    def fit(self, X, y, **kwargs):
        weights = compute_sample_weight(class_weight="balanced", y=y)
        return super().fit(X, y, sample_weight=weights, **kwargs)


def model_candidates():
    return {
        "Logistic Regression": LogisticRegression(
            class_weight="balanced", max_iter=2000, random_state=SEED
        ),
        "Random Forest": RandomForestClassifier(
            n_estimators=150, class_weight="balanced", random_state=SEED, n_jobs=1
        ),
        "SVM": SVC(class_weight="balanced", random_state=SEED),
        "XGBoost": BalancedXGBClassifier(
            objective="multi:softprob", eval_metric="mlogloss",
            n_estimators=100, random_state=SEED, n_jobs=1,
        ),
        "LightGBM": LGBMClassifier(
            objective="multiclass", class_weight="balanced", n_estimators=100,
            random_state=SEED, n_jobs=1, verbosity=-1,
        ),
    }


SEARCH_SPACE = {
    "Logistic Regression": {"C": [0.01, 0.03, 0.1, 0.3, 1, 3, 10, 30]},
    "Random Forest": {
        "n_estimators": [100, 200], "max_depth": [4, 8, None],
        "min_samples_leaf": [1, 3, 6], "max_features": ["sqrt", 0.5],
    },
    "SVM": {"C": [0.1, 0.3, 1, 3, 10], "gamma": ["scale", 0.01, 0.1]},
    "XGBoost": {
        "n_estimators": [60, 100, 150], "max_depth": [2, 3, 4],
        "learning_rate": [0.03, 0.1], "subsample": [0.8, 1.0],
    },
    "LightGBM": {
        "n_estimators": [60, 100, 150], "num_leaves": [7, 15, 31],
        "learning_rate": [0.03, 0.1], "min_child_samples": [15, 25],
    },
}
