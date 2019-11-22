//
//  CarsItemMapper.swift
//  CarsShopping
//
//  Created by Thiago Vaz on 21/11/19.
//  Copyright © 2019 Thiago Vaz. All rights reserved.
//

import Foundation

class CarsItemMapper {
    static func make(model: CarModel) -> CarsItem {
        let car =  CarsItem()
        car.descricao = model.descricao
        car.id = model.id
        car.imagem = model.imagem
        car.marca = model.marca
        car.nome = model.nome
        car.preco = model.preco
        return car
    }
    
    static func make(item: CarsItem) -> CarDisplay {
        
        let display = CarDisplay()
        display.nome = item.nome
        display.descricao = item.descricao
        display.id = item.id
        display.marca = item.marca
        display.imagem = item.imagem
        let currencyFormatter = NumberFormatter()
           currencyFormatter.usesGroupingSeparator = true
           currencyFormatter.numberStyle = .currency
           currencyFormatter.locale = Locale(identifier: "pt_BR")
            let currency = Float(item.preco)
           if let priceString = currencyFormatter.string(from: NSNumber(value: currency) ) {
               display.preco = priceString
        }
        
        if item.quantidade != 0 {
            display.isQtd = false
            display.quantidade = "Quantidade: \(item.quantidade)"
        }
        
        return display
    }
}
