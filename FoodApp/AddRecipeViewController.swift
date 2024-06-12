//
//  AddRecipeViewController.swift
//  FoodApp
//
//  Created by buse çelik on 19.05.2024.
//
import UIKit
import CoreData
import AVFoundation

class AddRecipeViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageURLTextField: UITextField!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var stepsTextView: UITextView!
    
    var audioPlayer: AVAudioPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func saveRecipe(_ sender: UIBarButtonItem) {
        if titleTextField.text?.isEmpty == true,
           imageURLTextField.text?.isEmpty == true,
           ingredientsTextView.text.isEmpty,
           stepsTextView.text.isEmpty {
            showAlert(message: "All fields are missing. Please fill in all fields.")
            return
        } else {
            if titleTextField.text?.isEmpty == true {
                showAlert(message: "Please enter a title for the recipe.")
                return
            }
            if imageURLTextField.text?.isEmpty == true {
                showAlert(message: "Please enter an image URL for the recipe.")
                return
            }
            if ingredientsTextView.text.isEmpty {
                showAlert(message: "Please enter the ingredients for the recipe.")
                return
            }
            if stepsTextView.text.isEmpty {
                showAlert(message: "Please enter the steps for the recipe.")
                return
            }
        }
        
        guard let title = titleTextField.text, !title.isEmpty else { return }
        guard let imageURL = imageURLTextField.text, !imageURL.isEmpty else { return }
        guard let ingredients = ingredientsTextView.text, !ingredients.isEmpty else { return }
        guard let steps = stepsTextView.text, !steps.isEmpty else { return }
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newRecipe = Recipe(context: context)
        newRecipe.title = title
        newRecipe.imageURL = imageURL
        newRecipe.ingredients = ingredients.components(separatedBy: "\n") as NSArray
        newRecipe.steps = steps.components(separatedBy: "\n") as NSArray
        
        do {
            try context.save()
            playSound()
            NotificationCenter.default.post(name: NSNotification.Name("NewRecipeAdded"), object: nil)
            navigationController?.popViewController(animated: true)
        } catch {
            print("Failed to save recipe: \(error)")
        }
    }

    func showAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Missing Information", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func playSound() {
            guard let url = Bundle.main.url(forResource: "success", withExtension: "mp3") else { return }
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Failed to play sound: \(error)")
            }
        }
}
