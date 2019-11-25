//
//  NSPersistentStoreCoordinator.swift
//  CarsShopping
//
//  Created by Thiago Vaz on 25/11/19.
//  Copyright © 2019 Thiago Vaz. All rights reserved.
//

import UIKit
import CoreData

/// NSPersistentStoreCoordinator extension
extension NSPersistentStoreCoordinator {
    
  /// NSPersistentStoreCoordinator error types
  public enum CoordinatorError: Error {
    /// .momd file not found
    case modelFileNotFound
    /// NSManagedObjectModel creation fail
    case modelCreationError
    /// Gettings document directory fail
    case storePathNotFound
  }
    
  /// Return NSPersistentStoreCoordinator object
  static func coordinator(name: String) throws -> NSPersistentStoreCoordinator? {
    
    guard let modelURL = Bundle.main.url(forResource: name, withExtension: "momd") else {
      throw CoordinatorError.modelFileNotFound
    }
    
    guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
      throw CoordinatorError.modelCreationError
    }
    
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
    
    guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
      throw CoordinatorError.storePathNotFound
    }
    
    do {
      let url = documents.appendingPathComponent("\(name).sqlite")
      let options = [ NSMigratePersistentStoresAutomaticallyOption : true,
                      NSInferMappingModelAutomaticallyOption : true ]
      try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
    } catch {
      throw error
    }
    
    return coordinator
  }
}
