//
//  DetailProtocol.swift
//  CarsShopping
//
//  Created by Thiago Vaz on 25/11/19.
//  Copyright © 2019 Thiago Vaz. All rights reserved.
//

import Foundation

protocol DetailPresenterInput {
    func find()
    func retry()
    var countItem: Int { get set}
    func compra(with qtd: Int)
}

protocol DetailPresenterOutput: class {
    func error(type: ErrorType)
    func startLoading()
    func stopLoading()
    func fetched(item: CarsItem)
    func showSuccess(message: String)
}
