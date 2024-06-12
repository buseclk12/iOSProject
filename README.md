# FoodApp

FoodApp is an iOS application that allows users to view, add, and manage recipes. Users can search for recipes, add new recipes, mark recipes as favorites, and view details of each recipe. The app uses Core Data for data persistence and includes features such as search functionality, gesture handling, and sound effects.

## Features

- View a list of recipes with images and titles
- Search for recipes by title
- Add new recipes with a title, image URL, ingredients, and steps
- Mark recipes as favorites with a long press gesture
- View detailed information about each recipe, including ingredients and steps
- Pinch to zoom on recipe images in the detail view
- Sound effect when adding a new recipe
- Data persistence using Core Data
- Custom collection view for displaying favorite recipes

## Screenshots

Include screenshots of your app here.

## Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/FoodApp.git
    ```
2. Open the project in Xcode:
    ```bash
    cd FoodApp
    open FoodApp.xcodeproj
    ```
3. Install dependencies:
    ```bash
    pod install
    ```
4. Build and run the project on your iOS device or simulator.

## Usage

1. Launch the app on your iOS device or simulator.
2. View the list of recipes on the main screen.
3. Use the search bar to find recipes by title.
4. Tap the "+" button to add a new recipe. Fill in the title, image URL, ingredients, and steps, then save the recipe.
5. Long press on a recipe to mark it as a favorite.
6. Tap on a recipe to view its details. Pinch to zoom on the recipe image.
7. Switch to the "Favorites" tab to view your favorite recipes.

## Dependencies

- [SDWebImage](https://github.com/SDWebImage/SDWebImage) - Used for loading and caching images
- Core Data - Used for data persistence

## Project Structure

- `AppDelegate.swift` - Application lifecycle management
- `SceneDelegate.swift` - Scene lifecycle management
- `RecipeListViewController.swift` - Main view controller for displaying and managing recipes
- `RecipeDetailViewController.swift` - View controller for displaying recipe details
- `AddRecipeViewController.swift` - View controller for adding new recipes
- `FavViewController.swift` - View controller for displaying favorite recipes
- `Recipe+CoreDataClass.swift` - Core Data model class for Recipe
- `Recipe+CoreDataProperties.swift` - Core Data properties extension for Recipe

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

- Thanks to [SDWebImage](https://github.com/SDWebImage/SDWebImage) for image loading and caching functionality.

## Contact

If you have any questions or feedback, please contact me at celikb292@icloud.com

