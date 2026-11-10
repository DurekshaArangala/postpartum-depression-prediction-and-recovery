# Member 2 handoff
## Explain the final calibrated PPD screening model

All paths below are relative to the project root.

| Requested item | File |
| --- | --- |
| Selected trained model | `models/best_model.joblib` |
| Preprocessed training predictors | `dataset/processed/X_train.csv` |
| Preprocessed test predictors | `dataset/processed/X_test.csv` |
| Target vectors | `dataset/processed/y_train.csv` and `dataset/processed/y_test.csv` |
| Feature names and preprocessing | `outputs/reports/feature_names.json`, `models/reference_preprocessor.joblib`, and the details below |
| Model predictions and class labels | `outputs/metrics/selected_model_train_predictions.csv`, `outputs/metrics/selected_model_test_predictions.csv`, and `outputs/reports/class_labels.json` |
| Inputs for the exact calibrated model | `dataset/processed/X_train_clean.csv` and `dataset/processed/X_test_clean.csv` |

## Row alignment and labels

The training split has 640 records and the held-out test split has 160. Every split file uses `row_id` as its first column. It is the zero-based record index in the supplied CSV, excluding the header. Use it to join files and remove it from features. The target files contain `class_id`. The recorded EPDS classes are ordered **0 Low, 1 Medium, 2 High**. The prediction files include actual and predicted classes plus the model's probabilities in that order.

The training prediction file contains fitted-model outputs on training records and can supply teacher targets for a surrogate. Use the held-out prediction file to evaluate surrogate fidelity. Use `y_test.csv` to evaluate performance against the recorded EPDS labels. Keep these two evaluations separate.

## Preprocessing details

The 21 original predictors exclude the serial number, EPDS and PHQ-9 scores and results, and measures of current postpartum mood or functioning. The shared cleaner trims and lowercases categories, combines the spelling variants of housewife, and treats the invalid disease value `1.2` as missing. A literal `none` is a valid category where present. Blank cells in the cleaned CSVs represent missing data.

The shared reference encoder fits once on `X_train_clean.csv`. It median-imputes and standardizes the two numeric fields, then mode-imputes and one-hot encodes the categorical fields. Unseen categories are ignored. It applies the same feature order and fitted statistics to both splits. The reference encoder and its exported numeric tables are suitable for training a surrogate.

The final calibrated SVM contains five pipelines with their own fold-fitted preprocessing and sigmoid calibrators. Pass the **21 cleaned original fields** to the saved model. The shared one-hot tables are for surrogate work because each ensemble member has its own fitted transformation.

## Start SHAP on the actual final model

From the project root, install the base requirements and optionally install SHAP with `python -m pip install shap==0.51.0`. This example explains one held-out record's **High** class probability using a small training background. For a global summary, explain a held-out sample and keep the training background and explained class consistent. Permutation SHAP estimates contributions to the selected output. [SHAP PermutationExplainer documentation](https://shap.readthedocs.io/en/latest/generated/shap.PermutationExplainer.html)

```python
import numpy as np
import pandas as pd
import shap

from src.predict import load_model, make_shap_predictor, to_shap_inputs
from src.preprocessing import PROCESSED

csv_options = {"index_col": "row_id", "keep_default_na": False, "na_values": [""]}
train = pd.read_csv(PROCESSED / "X_train_clean.csv", **csv_options)
test = pd.read_csv(PROCESSED / "X_test_clean.csv", **csv_options)

artifact = load_model()
background = to_shap_inputs(train.sample(20, random_state=42), artifact)
example = to_shap_inputs(test.iloc[:1], artifact)
predict_high = make_shap_predictor(artifact, label="High")

masker = shap.maskers.Independent(background)
explainer = shap.PermutationExplainer(predict_high, masker, seed=42)
explanation = explainer(example, max_evals=5 * (2 * example.shape[1] + 1))
np.testing.assert_allclose(
    explanation.base_values + explanation.values.sum(axis=1),
    predict_high(example),
)
explanation.display_data = test.iloc[:1].to_numpy()
shap.plots.waterfall(explanation[0])
```

The adapter temporarily assigns integer codes to categories for masking and reverses them before calling the model. Codes have no ordinal meaning. The returned SHAP values refer to original questionnaire fields and the chosen class probability. The model missed all 38 Medium cases in the held-out evaluation. Present these explanations as model behavior in a research prototype.
