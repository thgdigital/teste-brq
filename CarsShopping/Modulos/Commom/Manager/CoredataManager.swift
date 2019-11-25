//
//  CoredataManager.swift
//  CarsShopping
//
//  Created by Thiago Vaz on 25/11/19.
//  Copyright © 2019 Thiago Vaz. All rights reserved.
//

import Foundation
import CoreData

class CoredataManager: NSObject {
    
    static var persistentContainer: NSPersistentContainer = {
          let container = NSPersistentContainer(name: "CarDataModel")
          container.loadPersistentStores(completionHandler: { (storeDescription, error) in
              if let error = error as NSError? {}
          })
          container.viewContext.automaticallyMergesChangesFromParent = true
          return container
      }()
    
    
     static func saveContext() -> Bool {
         if persistentContainer.viewContext.hasChanges {
             do {
                 try persistentContainer.viewContext.save()
                 return true
             } catch {
                 print("An error occurred while saving: \(error)")
                 return false
             }
         }
         return false
     }
}
