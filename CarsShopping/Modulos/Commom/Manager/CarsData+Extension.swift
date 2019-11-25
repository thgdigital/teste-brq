//
//  CarsData+Extension.swift
//  CarsShopping
//
//  Created by Thiago Vaz on 25/11/19.
//  Copyright © 2019 Thiago Vaz. All rights reserved.
//

import CoreData

extension CarData {
    
     @discardableResult
    static func create(item: CarsItem) -> NSManagedObject {
        let managedContext = CoredataManager.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CarData", in: managedContext)!
        let cardata = NSManagedObject(entity: entity, insertInto: managedContext)
        cardata.setValue(item.descricao, forKey: "descricao")
        cardata.setValue(item.id, forKey: "id")
        cardata.setValue(item.imagem, forKey: "imagem")
        cardata.setValue(item.marca, forKey: "marca")
        cardata.setValue(item.nome, forKey: "name")
        cardata.setValue(item.preco, forKey: "valor")
        cardata.setValue(item.quantidade, forKey: "quantidade")
    
        return cardata
    }
    static func create(model: CarData) -> CarsItem {
        let item = CarsItem()
        item.descricao = model.descricao ?? ""
        item.id = Int(Int64(model.id))
        item.imagem = model.imagem ?? ""
        item.marca = model.marca ?? ""
        item.nome = model.name ?? ""
        item.preco = Int(model.valor)
        item.quantidade = Int(model.quantidade)
        
        return item
    }



}
