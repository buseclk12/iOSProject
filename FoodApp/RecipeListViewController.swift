//
//  RecipeListViewController.swift
//  FoodApp
//
//  Created by buse çelik on 19.05.2024.
//
import UIKit
import CoreData
import SDWebImage

class RecipeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!

    var recipes: [Recipe] = []
    var filteredRecipes: [Recipe] = []
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchController()
        reloadJSONData()
        fetchRecipes()
        tableView.reloadData()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRecipe))
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewRecipeAdded), name: NSNotification.Name("NewRecipeAdded"), object: nil)

        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        tableView.addGestureRecognizer(longPressRecognizer)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("NewRecipeAdded"), object: nil)
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecipeCell")
    }

    @objc func handleNewRecipeAdded() {
        fetchRecipes()
        tableView.reloadData()
    }

    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Recipes"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    @objc func addRecipe() {
        performSegue(withIdentifier: "addRecipeSegue", sender: self)
    }

    func reloadJSONData() {
        deleteAllRecipes()
        loadJSONData()
    }

    func deleteAllRecipes() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Recipe.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Failed to delete recipes: \(error)")
        }
    }

    func loadJSONData() {
        guard let url = Bundle.main.url(forResource: "recipes", withExtension: "json") else {
            print("Failed to find recipes.json")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [[String: Any]]
            print("JSON Array: \(jsonArray)")

            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

            for jsonDict in jsonArray {
                let recipe = Recipe(context: context)
                recipe.title = jsonDict["title"] as? String
                recipe.imageURL = jsonDict["image"] as? String
                recipe.ingredients = jsonDict["ingredients"] as? [String] as NSArray?
                recipe.steps = jsonDict["steps"] as? [String] as NSArray?
                recipe.favorite = jsonDict["favorite"] as? Bool ?? false
            }

            try context.save()
            print("Data saved to Core Data")
        } catch {
            print("Failed to load or save JSON data: \(error)")
        }
    }

    func fetchRecipes() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        do {
            recipes = try context.fetch(fetchRequest)
            filteredRecipes = recipes
            print("Fetched Recipes: \(recipes)")
        } catch {
            print("Failed to fetch recipes: \(error)")
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        if searchText.isEmpty {
            filteredRecipes = recipes
        } else {
            filteredRecipes = recipes.filter { $0.title?.contains(searchText) ?? false }
        }
        tableView.reloadData()
    }

    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let recipe = filteredRecipes[indexPath.row]
                recipe.favorite = !recipe.favorite

                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                do {
                    try context.save()
                    NotificationCenter.default.post(name: NSNotification.Name("RecipeFavoriteChanged"), object: nil)
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                    let message = recipe.favorite ? "Added to favorites" : "Removed from favorites"
                    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    self.present(alert, animated: true) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            alert.dismiss(animated: true, completion: nil)
                        }
                    }
                } catch {
                    print("Failed to save favorite status: \(error)")
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRecipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
        let recipe = filteredRecipes[indexPath.row]
        cell.textLabel?.text = recipe.favorite ? "\(recipe.title ?? "") (Favorite)" : recipe.title

        if let imageURL = recipe.imageURL, let url = URL(string: imageURL) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, error == nil {
                    DispatchQueue.main.async {
                        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                        imageView.image = UIImage(data: data)
                        cell.imageView?.image = imageView.image
                        cell.setNeedsLayout()
                    }
                }
            }.resume()
        } else {
            cell.imageView?.image = UIImage(named: "placeholder.png")
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showRecipeDetail", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecipeDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as! RecipeDetailViewController
                destinationVC.recipe = filteredRecipes[indexPath.row]
            }
        } else if segue.identifier == "addRecipeSegue" {
        }
    }
}
