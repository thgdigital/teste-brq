//
//  MylistProtocol.swift
//  CarsShopping
//
//  Created by Thiago Vaz on 25/11/19.
//  Copyright © 2019 Thiago Vaz. All rights reserved.
//

import Foundation
protocol MylistInput {
    func fetch()
    func remove(with item: CarsItem)
}

protocol MylistOuput: class {
    func fetched(cars: [CarsItem])
}
