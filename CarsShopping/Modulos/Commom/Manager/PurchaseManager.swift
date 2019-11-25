//
//  PurchaseManager.swift
//  CarsShopping
//
//  Created by Thiago Vaz on 25/11/19.
//  Copyright © 2019 Thiago Vaz. All rights reserved.
//

import Foundation
import CoreData

class PurchaseManager: CoredataManager {
    
    static func save(item: CarsItem) -> Bool {
        CarData.create(item: item)
        return saveContext()
    }
    
    static func getList() -> [CarData] {
        let managedContext = persistentContainer.viewContext
        let request = NSFetchRequest<CarData>(entityName:"CarData")
        do {
            let result = try managedContext.fetch(request)
            return result
        }catch {
            return []
        }
    }
}
