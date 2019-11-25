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
    func retry()
    func didSelected(with item: CarsItem)
    func sendCompra(with item: CarsItem)
    
}

protocol HomeListOutput: class {
    func fetched(cars: [CarsItem])
    func fetched(paginate cars: [CarsItem])
    func error(type: ErrorType)
    func startLoading()
    func stopLoading()
}
