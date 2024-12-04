
# Food Recipe App

A Flutter application that displays a list of food recipes fetched from an API (or uses mock data if the API is unavailable). Users can view recipes and add them to their favorites.

## Project Structure

The project is structured as follows:

```
food_recipe/
├── lib/
│   ├── main.dart                      // Entry point of the application
│   ├── models/                       // Data models (e.g., FoodItem)
│   │   └── food_item.dart
│   ├── providers/                    // State management using Provider
│   │   └── favorites_provider.dart 
│   ├── screens/                      // UI screens (e.g., SplashScreen) 
│   │   └── splashScreen.dart 
│   └── services/                      // API and data services
│       └── food_api_service.dart
├── pubspec.yaml                     // Project dependencies and metadata
└── README.md                         // This file
```

## Features

* **Displays a list of food recipes:** Fetches recipes from a JSON API or uses mock data if the API fails.
* **Recipe details:** Shows the food name, image, and detailed recipe instructions.
* **Favorites:** Allows users to add recipes to their favorites list.
* **State management:** Uses Provider for managing the favorites state.
* **Splash screen:** Shows a splash screen while the app initializes.

## Dependencies

The project uses the following key dependencies:

* **flutter:** The core Flutter framework.
* **provider:** For state management.
* **http:** For making HTTP requests to the API.
* **shared_preferences:** For storing user preferences (e.g., favorites).

##Snapshots

## Snapshots

<img src="https://github.com/user-attachments/assets/1e3f1838-5efc-42a1-8c29-0c8182c3272b" width="200" height="400"> <img src="https://github.com/user-attachments/assets/ffcff00a-b264-4ea7-b6ae-99c9d063f719" width="200" height="400">
<img src="https://github.com/user-attachments/assets/223103f2-0257-4e36-9775-5fd1cd061fbe" width="200" height="400"> <img src="https://github.com/user-attachments/assets/3818bf70-9389-4bdf-8204-b12d25cc392b" width="200" height="400">



https://github.com/user-attachments/assets/d43a3a41-b962-4b10-aab3-2d032bb81c18


 
## Data Source

The app fetches food recipe data from the following API:

```
https://raw.githubusercontent.com/Piyu-Pika/Recipes/refs/heads/main/sample.json
```

If the API is unavailable, the app falls back to using mock data defined in `food_api_service.dart`.

## Getting Started

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Piyu-Pika/food_recipe.git 
   ```
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Run the app:**
   ```bash
   flutter run
   ```

## Future Enhancements

* **Improved error handling:** Handle network errors more gracefully and provide better user feedback.
* **User authentication:** Allow users to create accounts and save their favorites across devices.
* **Search functionality:** Enable users to search for specific recipes.
* **UI improvements:** Enhance the user interface with better design and animations
