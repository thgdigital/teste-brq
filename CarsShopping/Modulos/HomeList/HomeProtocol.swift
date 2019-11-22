//
//  HomeProtocol.swift
//  CarsShopping
//
//  Created by Thiago Vaz on 21/11/19.
//  Copyright © 2019 Thiago Vaz. All rights reserved.
//

import Foundation

protocol HomeListInput {
    func fetchCars()
    func paginate()
}

protocol HomeListOutput: class {
    func fetched(cars: [CarsItem])
    func fetched(paginate cars: [CarsItem])
}
