# Postpartum depression screening
## Member 1 · Predictive machine learning

This project runs the six-notebook workflow in the revised brief using the supplied `PPD_dataset.csv`. It compares five classifiers and exports a calibrated model that predicts the dataset's Low, Medium or High EPDS screening class. This is an academic prototype for research demonstration. Clinical validity and performance in a Sri Lankan population have not been established.

## Run the notebooks

1. Extract the ZIP and open a terminal in `PPD_ML_Prediction`.
2. Install Python 3.12, then create a virtual environment.

   ```bash
   python -m venv .venv
   ```

3. Activate it. On Windows PowerShell, use `.\.venv\Scripts\Activate.ps1`. On macOS or Linux, use `source .venv/bin/activate`.
4. Install the dependencies and start JupyterLab.

   ```bash
   python -m pip install -r requirements.txt
   python -m jupyterlab
   ```

5. Open `notebooks/` and run notebooks 01 through 06 in order. Use **Kernel → Restart Kernel and Run All Cells** for each notebook. Select the Python kernel from the virtual environment. If your editor offers multiple Python interpreters, select `.venv`.

The notebooks include their executed outputs for reference. Rerunning them regenerates the processed data, model files, and outputs. Start with 01 before training, run 04 before 05, and run 05 before trying a new prediction in 06. LightGBM may require an OpenMP runtime on macOS (`brew install libomp` if its import reports a missing `libomp` library).

## What each notebook does

| Notebook | Your individual task | What to show |
| --- | --- | --- |
| 01 · Dataset exploration | Check 800 rows, 51 columns, missing data, inconsistent answers, and both questionnaire score distributions. | EPDS label counts and score ranges, plus the distribution plot. |
| 02 · Preprocessing | Select 21 predictors. Normalize categories, preserve literal `None` answers, handle missing values, encode, scale, and group identical predictor profiles in the 80/20 split. | The predictor list, exclusion list, and 640/160 split. |
| 03 · Model training | Train Logistic Regression, Random Forest, SVM, XGBoost, and LightGBM as weighted pipelines. | The five-model baseline cross-validation table. |
| 04 · Tuning | Search eight parameter settings per algorithm using five stratified group folds. | Best settings and the ranking by validation macro F1. |
| 05 · Evaluation | Calibrate on the training split. Compare all five models on the held-out rows. Rank predictive features for the selected model. | Held-out metrics, per-class results, confusion matrices, calibration plots, and permutation importance. |
| 06 · Prediction | Load the saved model and predict from a fictional questionnaire. | Three probabilities, the predicted class, and the JSON input/output contract. |

## Explain your methodology

1. **Define the outcome.** Use the supplied `EPDS Result` after trimming and standardizing case. The normalized counts are 259 Low, 190 Medium and 351 High. The supplied score ranges overlap at class boundaries, so the code keeps the recorded class.
2. **Justify your predictors.** The named list in `src/preprocessing.py` covers maternal and household characteristics, pregnancy history and experiences, and delivery mode. It omits the serial number, both EPDS fields, both PHQ-9 fields, and measures of concurrent postpartum mood or functioning. This is a retrospective classification of a recorded screening outcome. The dataset does not establish a prospective prediction time or an early-postpartum evaluation window.
3. **Explain how you avoided leakage.** Keep one stratified test set with a fixed seed. Three pairs share identical cleaned predictor profiles. Group those profiles across both the holdout split and cross-validation so each pair stays together. Fit preprocessing and class weights within each training fold. Select the winner on training cross-validation macro F1, then evaluate it once on the test split. Sigmoid calibration uses training folds only. It can adjust which class has the highest probability, so its held-out scores can differ from the pre-calibration tuning scores.
4. **Report the errors as well as the scores.** Report macro precision, recall and F1 alongside the High class recall and precision. Read confusion matrices with actual classes as rows and predicted classes as columns. Log loss and Brier score assess probability error. In the calibration plots, the diagonal is the reference for agreement between predicted probability and observed frequency.
5. **Discuss predictive factors.** Use the mean decrease in held-out macro F1 when each input is shuffled. Compare that decrease with the variation across shuffles. Correlated predictors can share importance, and the ranking measures the model's behavior on this dataset. Member 2 can use the saved pipeline and schema for the separate explainability work.
6. **Describe risk stratification accurately.** The class is the largest of the three predicted probabilities. A probability of 0.60 for High estimates the recorded High screening label under this model. These are model outputs for a research dataset and carry no diagnostic or treatment thresholds. Dataset provenance, population representativeness, and external validity require separate verification.

## Results from the included run

SVM led training cross-validation with macro F1 of 0.492. On the 160 held-out records, the calibrated SVM reached 44.4% accuracy, 0.320 macro F1, and 0.607 macro ROC-AUC. Predicting the training-set majority class for every record would have reached 43.8% accuracy. The SVM identified 51 of 70 High records and zero of 38 Medium records. Its calibration and discrimination are limited on this split.

The strongest positive permutation result was for depression before pregnancy, with a mean macro-F1 drop of about 0.002 and a standard deviation of about 0.005. The small effect and variability limit what this run can establish about individual factors. Use the full tables in `outputs/` when discussing results.

## Folder guide

| Folder | Contents |
| --- | --- |
| `dataset/raw/` | Supplied CSV. |
| `dataset/processed/` | Aligned cleaned and encoded train/test predictors and target files. |
| `notebooks/` | The six notebooks in run order. |
| `models/` | Selected calibrated model and reference preprocessor. |
| `outputs/graphs/` | Score distributions, confusion matrices, calibration curves, and feature importance. |
| `outputs/metrics/` | Evaluation and tuning tables, feature importance, and train/test predictions. |
| `outputs/reports/` | Member 2 handoff, feature names, class mapping, input schema, and example API JSON. |
| `src/` | Shared preprocessing, model definitions, handoff export, and prediction code. |

## Integration handoff

Start with [Member 2 handoff](outputs/reports/member_2_handoff.md). It explains which files to use for the exact calibrated model and which to use for a surrogate.

For API integration, load `models/best_model.joblib` once with `src.predict.load_model()` and pass the artifact and questionnaire dictionary to `src.predict.predict_risk(questionnaire, artifact)`. See `outputs/reports/input_schema.json` for field names, allowed categories and numeric ranges. Send `null` for unanswered fields. The literal string `"None"` represents a survey option where listed. The example request and response in the same folder use a fictional questionnaire.

## Method references

- [Randomized search](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.RandomizedSearchCV.html)
- [Probability calibration](https://scikit-learn.org/stable/modules/generated/sklearn.calibration.CalibratedClassifierCV.html)
- [Permutation feature importance](https://scikit-learn.org/stable/modules/permutation_importance.html)
