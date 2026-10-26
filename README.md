# Explore Bangladesh

Nature-inspired Flutter travel discovery app with persistent local preferences.

## Features
- Animated Bangladesh flag splash screen
- Nature Light and Dark themes
- Search and category filtering for destinations
- Destination detail pages and OpenStreetMap links
- Favorites and saved destinations persisted locally
- Local expense tracker with delete and clear actions
- Responsive destination grid and reusable place cards

## Requirements
- Flutter SDK (Dart 3.4+)
- Android Studio or VS Code with Flutter extension

## Run
```bash
flutter pub get
flutter analyze
flutter run
```

## Project structure
```text
lib/
  main.dart
  app.dart
  models/travel_place.dart
  services/local_store.dart
  theme/app_theme.dart
  widgets/place_card.dart
  screens/
    splash_screen.dart
    main_shell.dart
    home_screen.dart
    saved_screen.dart
    place_details_screen.dart
    budget_screen.dart
    settings_screen.dart
```

## Notes
- Place photos are loaded from Unsplash URLs, so images need internet access.
- Map opens OpenStreetMap in the external browser; this starter does not bundle offline maps.
- Budgets are illustrative estimates and must be checked before travel.
- Local preferences use SharedPreferences. For sensitive or complex structured data, use a database such as SQLite/Drift instead.
- Before publishing, test on target Android/iOS devices, add app icons and platform permissions as needed, review all destination data, and configure release signing.
