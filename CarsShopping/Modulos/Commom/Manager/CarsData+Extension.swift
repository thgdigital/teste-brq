//
//  CarsData+Extension.swift
//  CarsShopping
//
//  Created by Thiago Vaz on 25/11/19.
//  Copyright © 2019 Thiago Vaz. All rights reserved.
//

import CoreData

extension CarData {
    static func create(item: CarsItem) -> CarData {
        let cardata = CarData()
        cardata.descricao = item.descricao
        cardata.id = Int64(item.id)
        cardata.imagem = item.imagem
        cardata.marca = item.marca
        cardata.name = item.nome
        cardata.valor = Float(item.preco)
        
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
        
        return item
    }



}
