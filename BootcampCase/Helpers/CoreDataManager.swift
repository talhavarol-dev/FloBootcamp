//
//  CoreDataManager.swift
//  BootcampCase
//
//  Created by Muhammet  on 22.07.2023.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoriModel") // Model dosyanızın adı
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Core Data store failed. Error: \(error)")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    func fetchFavoriteTracks() -> [FavoriModel] {
        let request: NSFetchRequest<FavoriModel> = FavoriModel.fetchRequest()

        do {
            let tracks = try context.fetch(request)
            return tracks
        } catch {
            print("Fetching favorited tracks failed: \(error.localizedDescription)")
            return []
        }
    }

}
