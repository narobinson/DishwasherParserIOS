//
//  CoreDataService.swift
//  TheDishwasher
//
//  Created by Admin on 7/29/18.
//  Copyright © 2018 narobinson. All rights reserved.
//

import UIKit
import CoreData

class CoreDataService: DishwasherService {
    
    var persistentContainer: NSPersistentContainer {
        return CoreDataStack.shared.persistentContainer
    }
    
    func getDishwashers(completion: @escaping Handler) {
        DispatchQueue.global(qos: .userInitiated).async {
            let context = self.persistentContainer.newBackgroundContext()

            let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Washer")
            
            do {
                let results = try context.fetch(request)
                print("Retrieved something from Core Data")
                
                guard let objects = results as? [NSManagedObject] else {
                    completion([])
                    return
                }
                
                let diswashers = objects.compactMap{ Dishwasher(from: $0) }
                completion(diswashers)
            }catch {
                print("Could NOT retrieve from Core Data: ")
                print(error.localizedDescription)
            }
        }
    }
    
    func save(diswashers: [Dishwasher]){
        
        DispatchQueue.global(qos: .utility).async {
        
            let context = self.persistentContainer.newBackgroundContext()
            
            //self.deleteDishwashers(using: context)
            
            
            let dishwasherNames = self.getArrayNames(entity: "Washer")
            
            
            for object in diswashers {
                
                if !dishwasherNames.contains(object.title){
                
                let entity = NSEntityDescription.entity(forEntityName: "Washer", in: context)
                let washer = NSManagedObject(entity: entity!, insertInto: context)
                
                let entity2 = NSEntityDescription.entity(forEntityName: "WasherBrand", in: context)
                let brand = NSManagedObject(entity: entity2!, insertInto: context)
                
                washer.setValue(object.title, forKey: "name")
                washer.setValue(object.currentPrice!, forKey: "price")
                washer.setValue(object.image, forKey: "image")
                //washer.setValue(object.favorite, forKey: "favorite")
                
                // - make relationship
                washer.setValue(brand, forKey: "washerBrand")
                
                brand.setValue(object.brand, forKey: "name")
                }
            }
            
            do {
                try context.save()
                print("Successfully saved to Core Data")
            }catch{
                print("Could not save to Core Data: ")
                print(error.localizedDescription)
            }
        }
    }
    
    private func deleteDishwashers(using context: NSManagedObjectContext){
        
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Washer")
        
        do {
            let results = try context.fetch(request)
            print("Retrieved Core Data objects for deletion")
            
            guard let objects = results as? [NSManagedObject] else { return }
            
            // - delete every existing Dishwasher
            objects.forEach(){
                context.delete($0)
            }
            
        }catch {
            print("Could NOT retrieve for deletion: ")
            print(error.localizedDescription)
        }
    }
    
    func toggleFavorite(dishwasherName: String, completion: @escaping ()->Void){
        
        let favoritesArray = getArrayNames(entity: "Favorites")
        
        if favoritesArray.contains(dishwasherName){
            removeFavorite(name: dishwasherName, completion: completion)
        }
        else{
            addFavorite(name: dishwasherName, completion: completion)
        }
        
    }
    
    func addFavorite(name: String, completion: @escaping ()->Void){
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            defer { completion() }
            
            let context = CoreDataStack.shared.persistentContainer.newBackgroundContext()
            
            let entity = NSEntityDescription.entity(forEntityName: "Favorites", in: context)
            
            let favoriteDishwasher = NSManagedObject(entity: entity!, insertInto: context)
            
            favoriteDishwasher.setValue( name, forKey: "name")
            
            do{
                try context.save()
                print("Favorite Saved")
            }catch{
                print(error.localizedDescription)
            }
        }
        
    }
    
    func removeFavorite(name:String, completion: @escaping ()->Void){
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            defer { completion() }
        
            let context = self.persistentContainer.newBackgroundContext()
            
            let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Favorites")
            
            guard let results = (try? context.fetch(request)) as? [NSManagedObject] else {
                return
            }
            for object in results {
                if object.value(forKey: "name") as! String == name{
                    context.delete(object)
                    do{
                        try context.save()
                        print("Favorite Deleted")
                        return
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func getFavorites()->[String]{
        return getArrayNames(entity: "Favorites")
    }
    
    
    private func getArrayNames(entity:String)->[String]{
        
        let context = self.persistentContainer.newBackgroundContext()
        
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        
        guard let mutableFetchResults = try? context.fetch(request) as? [NSManagedObject] else {
            return []
        }
        
        if let mutableFetchResults = mutableFetchResults {
            let stringArray = mutableFetchResults.compactMap {$0.value(forKey: "name") as? String}
                return stringArray
        }
        return []
    }
}
