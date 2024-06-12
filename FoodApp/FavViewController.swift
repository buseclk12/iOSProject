//
//  FavViewController.swift
//  FoodApp
//
//  Created by buse çelik on 19.05.2024.
//
import UIKit
import CoreData
import SDWebImage

class FavViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var favoriteRecipes: [Recipe] = []

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchFavoriteRecipes()

        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoriteChanged), name: NSNotification.Name("RecipeFavoriteChanged"), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("RecipeFavoriteChanged"), object: nil)
    }

    @objc func handleFavoriteChanged() {
        fetchFavoriteRecipes()
        collectionView.reloadData()
    }

    func fetchFavoriteRecipes() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "favorite == true")

        do {
            favoriteRecipes = try context.fetch(fetchRequest)
            collectionView.reloadData()
        } catch {
            print("Failed to fetch favorite recipes: \(error)")
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteRecipes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCellCol", for: indexPath)
        
        if let imageView = cell.viewWithTag(1) as? UIImageView {
            let titleLabel = cell.viewWithTag(2) as? UILabel

            let recipe = favoriteRecipes[indexPath.row]
            titleLabel?.text = recipe.title

            if let imageURL = recipe.imageURL, let url = URL(string: imageURL) {
                imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder.png"))
            } else {
                imageView.image = UIImage(named: "placeholder.png")
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 30) / 2
        return CGSize(width: width, height: width + 40)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = favoriteRecipes[indexPath.row]
        let detailVC = RecipeDetailViewController()
        detailVC.recipe = recipe
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
