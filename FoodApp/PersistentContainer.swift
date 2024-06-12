//
//  PersistentContainer.swift
//  FoodApp
//
//  Created by buse çelik on 20.05.2024.
//

import CoreData

class PersistentContainer: NSPersistentContainer {
    override class func defaultDirectoryURL() -> URL {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "com.buseCelik.FoodApp")!
    }
     class func loadPersistentStores(completionHandler block: @escaping (NSPersistentStoreDescription, Error?) -> Void) {
        let container = NSPersistentContainer(name: "FoodApp")

        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                // Typical reasons for an error here include:
                // * The parent directory does not exist, cannot be created, or disallows writing.
                // * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                // * The device is out of space.
                // * The store could not be migrated to the current model version.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            block(storeDescription, error)
        }
    }
}
