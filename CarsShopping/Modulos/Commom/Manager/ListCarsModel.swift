//
//  ListCarsModel.swift
//  CarsShopping
//
//  Created by Thiago Vaz on 21/11/19.
//  Copyright © 2019 Thiago Vaz. All rights reserved.
//

import Foundation

struct CarModel: Codable {
    let id: Int
    let nome, descricao, marca: String
    let quantidade, preco: Int
    let imagem: String
}

typealias ListCarsModel = [CarModel]
