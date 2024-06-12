//
//  RecipeDetailViewController.swift
//  FoodApp
//
//  Created by buse çelik on 19.05.2024.
//
import UIKit
import SDWebImage

class RecipeDetailViewController: UIViewController {
    var recipe: Recipe?

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var stepsTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        displayRecipeDetails()
        addPinchGesture()
    }

    func displayRecipeDetails() {
        guard let recipe = recipe else { return }
        recipeTitleLabel.text = recipe.title

        if let imageURL = recipe.imageURL, let url = URL(string: imageURL) {
            recipeImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder.png"))
        } else {
            recipeImageView.image = UIImage(named: "placeholder.png")
        }

        if let ingredients = recipe.ingredients as? [String] {
            ingredientsTextView.text = ingredients.joined(separator: "\n")
        }

        if let steps = recipe.steps as? [String] {
            stepsTextView.text = steps.joined(separator: "\n")
        }
    }

    func addPinchGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        recipeImageView.isUserInteractionEnabled = true
        recipeImageView.addGestureRecognizer(pinchGesture)
    }

    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let view = gesture.view else { return }
        view.transform = view.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1
    }
}
