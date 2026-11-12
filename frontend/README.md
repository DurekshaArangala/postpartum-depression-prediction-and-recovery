# Liyaa — Flutter frontend MVP

A frontend-only interactive prototype for the Liyaa postpartum wellbeing research project.

## Run
1. Install Flutter and Android Studio (or VS Code + Flutter extension).
2. Open a terminal inside this folder.
3. Run `flutter create . --platforms android,ios,web` to generate platform folders (does not replace the existing `lib/` files).
4. Run `flutter pub get`.
5. Start an Android emulator or connect an Android phone with USB debugging enabled.
6. Run `flutter run` (or `flutter run -d chrome` for a web preview).

## What works
- Welcome, demo registration/login, initial 10-item questionnaire, score screen, home dashboard, daily check-in, history, support, demo chat and profile.
- Each screen has its own file in `lib/screens/`.
- Images are in `assets/images/` and are referenced by Flutter asset paths.
- All state is in memory; restarting the app clears it. There is **no authentication, persistence, AI, database, or API connection**.

## Important clinical limitations
- Questionnaire is an **English EPDS-style demonstration**, not a verified Sinhala version of the uploaded Sri Lankan form. The original uploaded form must be checked against an authorized validated instrument and approved translations before clinical deployment.
- The result shows a raw demonstration score out of 30. No clinical risk categories, probability, diagnosis, or validated thresholds are implemented.
- Item 10 triggers a safety message whenever it is nonzero; this is a UI safeguard, not a complete safety protocol.
- The chatbot is scripted and not suitable for crisis response.
- Obtain ethics approval, appropriate consent, and clinical review before testing with real mothers or collecting health data.

## Suggested next step
Connect Supabase Auth and database after the screens and navigation are approved; then implement clinician-reviewed screening rules and secure risk handling.
