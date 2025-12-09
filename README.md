# Healthy Weight Loss & Nutrition Tracking App (Flutter)

This project is a Flutter (Dart) mobile application that helps users manage healthy weight loss and track their daily nutrition.

## Main Features

- **User profile**: On first launch, the user fills in current weight, target weight, age, height, and gender. The profile is stored locally for personalized analysis.
- **Meal logging**:
  - Take a photo or pick one from the gallery for each meal;
  - Enter meal description, meal type (breakfast / lunch / dinner / snack), and timestamp;
  - Input calories, carbohydrates, protein, and fat for that meal;
  - All meal records are stored locally using `shared_preferences`.
- **Nutrition stats & trends**:
  - Daily total calories and C/P/F macronutrient summary;
  - Simple 7-day calorie trend visualization (per-day progress bars).
- **Learning module**:
  - Shows a list of curated educational videos about nutrition and weight loss;
  - Tapping an item opens a detail page, and the video link can be opened in the system browser.

## Technical Details

- Uses `shared_preferences` for local persistence, serializing/deserializing the user profile and meal records.
- Uses `image_picker` to take photos or select images from the gallery and keeps the local path for display.
- Uses `url_launcher` to open educational video links from the learning module.

## How to Run

1. Install the Flutter SDK and make sure the `flutter` command is available.
2. Open a terminal in the project root directory:

   ```bash
   cd e:/comp554_final_project
   ```

3. (If you started from an empty folder) run once to generate platform folders:

   ```bash
   flutter create .
   ```

   Keep the `lib/` directory and `pubspec.yaml` from this project.

4. Fetch dependencies:

   ```bash
   flutter pub get
   ```

5. Run the app:

   ```bash
   flutter run
   ```

## Possible Extensions

- Integrate an image recognition + nutrition database API to auto-estimate nutrition from photos.
- Add body weight logging and charts to track long-term progress.
- Support cloud sync (e.g., Firebase or a custom backend).
