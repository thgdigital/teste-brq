//
//  CarsManager.swift
//  CarsShopping
//
//  Created by Thiago Vaz on 21/11/19.
//  Copyright © 2019 Thiago Vaz. All rights reserved.
//

import Foundation
import Alamofire
import CoreData


class CarsManager: NSObject {
    
    func fetchCars(with completion: @escaping ((_ list: ListCarsModel?, _ error: Error?) -> Void)) {
        
        Alamofire.request(Router.getCars).validate().responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                guard let data = response.data, let listModel: ListCarsModel  = self.decodeParse(jsonData: data) else {
                    completion(nil, nil)
                    return
                }
                
                completion(listModel, nil)
                
            case .failure(let error):
                completion(nil, error)
                
            }
        }
    }
    
    func fetchCar(idCar:Int, completion: @escaping ((_ list: CarModel?, _ error: Error?) -> Void)) {
           
           Alamofire.request(Router.readCar(idCar: idCar)).validate().responseJSON { response in
               
               switch response.result {
                   
               case .success:
                   
                guard let data = response.data, let carModel: CarModel = self.decodeParse(jsonData: data) else {
                       completion(nil, nil)
                       return
                   }
                   
                   completion(carModel, nil)
                   
               case .failure(let error):
                   completion(nil, error)
                   
               }
           }
       }
    func decodeParse<T: Codable>(jsonData: Data) -> T? {
         do {
             let decoder = JSONDecoder()
             let items = try decoder.decode(T.self, from: jsonData)
             return items
         } catch {
             return nil
         }
     }
    static var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CarDataModel")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
            
                debugPrint("Fatal Error: Shared_File_CoreData_Error - Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    static var viewContext: NSManagedObjectContext {
       return persistentContainer.viewContext
    }
    
}
extension NSManagedObjectContext {

  func fetchFirst<T: NSManagedObject>(_ entity: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> T? {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.entityName)
    fetchRequest.fetchLimit = 1
    fetchRequest.predicate = predicate
    fetchRequest.sortDescriptors = sortDescriptors
    fetchRequest.returnsObjectsAsFaults = false

    do {
      let matches = try fetch(fetchRequest)
      return matches.first as? T
    }
    catch {
      return nil
    }
  }

  func fetchAll<T: NSManagedObject>(_ entity: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [T] {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.entityName)
    fetchRequest.predicate = predicate
    fetchRequest.sortDescriptors = sortDescriptors

    do {
      let matches = try fetch(fetchRequest)
      return (matches as? [T]) ?? []
    }
    catch {
      return []
    }
  }

  func count<T: NSManagedObject>(_ entity: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> Int {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.entityName)
    fetchRequest.predicate = predicate
    fetchRequest.sortDescriptors = sortDescriptors

    do {
      return try count(for: fetchRequest)
    }
    catch {
      return 0
    }
  }

  func fetch<T: NSManagedObject>(_ entity: T.Type, serverId: Int64) -> T? {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.entityName)
    fetchRequest.predicate = NSPredicate(format: "serverId = %@", NSNumber(value: serverId))

    do {
      let matches = try fetch(fetchRequest)

      return matches.first as? T
    }
    catch {
      return nil
    }
  }
    
//    MARK: - Delete Batch
    func deleteBatch<T: NSManagedObject>(_ entity: T.Type, predicate: NSPredicate) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.entityName)
//        fetchRequest.predicate = predicate
        let deleteBatch = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try persistentStoreCoordinator?.execute(deleteBatch, with: CarsManager.viewContext)
        } catch (let error) {
            debugPrint(error)
        }
    }

// MARK: - Save
    
    func commit() {
//        DispatchQueue.main.async {
            guard self.hasChanges, UIApplication.shared.isProtectedDataAvailable else {
                return
            }
            self.performAndWait { [weak self] in
                do {
                    try self?.save()
                    if let parent = self?.parent {
                        parent.perform { [weak self] in
                            do {
                                try self?.parent?.save()
                            }
                            catch {
                                fatalError("Could not save privateManagedObjectContext: \(error).")
                            }
                        }
                    }
                }
                catch {
                    fatalError("Could not save managedObjectContext: \(error).")
                }
            }
//        }
    }
}
extension NSManagedObject {

  class var entityName: String {
    let fullClassName = NSStringFromClass(object_getClass(self)!)
    let classNameComponents = fullClassName.components(separatedBy: ".")
    return classNameComponents.last!
  }

  class func insertNew(in context: NSManagedObjectContext) -> Self {
    let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context)!
    return self.init(entity: entityDescription, insertInto: context)
  }

  class func deleteAll(in context: NSManagedObjectContext) {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

    do {
      let matches = try context.fetch(fetchRequest)

      for match in matches where match is NSManagedObject {
        context.delete(match as! NSManagedObject)
      }
    }
    catch {}
  }
    
    static var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        do {
            return try NSPersistentStoreCoordinator.coordinator(name: "CarDataModel")
        } catch {
           return nil
        }
    }()

}

enum ErrorType: Error {
    case serve(message: String)
    case empty(message: String)
    case network(message: String)
}
