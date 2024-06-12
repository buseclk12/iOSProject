//
//  Recipe+CoreDataProperties.swift
//  FoodApp
//
//  Created by buse çelik on 19.05.2024.
//
//
import Foundation
import CoreData

extension Recipe {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var title: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var ingredients: NSObject?
    @NSManaged public var steps: NSObject?
    @NSManaged public var favorite: Bool
}

extension Recipe : Identifiable {

}
