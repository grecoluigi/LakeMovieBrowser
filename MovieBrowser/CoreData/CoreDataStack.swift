//
//  CoreDataStack.swift
//  MovieBrowser
//
//  Created by Luigi on 20/11/2022.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack(modelName: Helper.coreDataModelName)
    
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    private lazy var storeContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("Error loading CoreData persistent store: \(error), \(error.userInfo)")
            }
        }
        return container
        }()
    
    func saveContext() {
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error saving CoreData context: \(error), \(error.userInfo)")
        }
    }
}
