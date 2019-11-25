//
//  DetailPresenter.swift
//  CarsShopping
//
//  Created by Thiago Vaz on 25/11/19.
//  Copyright © 2019 Thiago Vaz. All rights reserved.
//

import Foundation

class DetailPresenter: DetailPresenterInput {
    
    var countItem: Int = 0
    
    var manger: CarsManager
    var idCars: Int
    var view: DetailPresenterOutput?
    
    init(idCars: Int, manger: CarsManager) {
        self.manger = manger
        self.idCars = idCars
    }
    
    func find() {
        view?.startLoading()
        manger.fetchCar(idCar: idCars) { (carModel, error) in
            self.view?.stopLoading()
            guard error == nil else {
                self.castError(error: error)
                return
            }
            guard let carModel = carModel else {
                self.view?.error(type: .empty(message: "Dados Vazios"))
                return
            }
            self.countItem = 3
            self.view?.fetched(item: CarsItemMapper.make(model: carModel))
        }
    }
    
    func retry() {
        find()
    }
    
    func castError(error: Error?) {
        guard let error = error else {
            return
        }
        
        switch error._code {
        case 500:
            view?.error(type: .serve(message: "Error no servidor tente mais tarde"))
        case -1009:
            view?.error(type: .network(message: "Você esta sem conexão"))
            
        default: break
            
        }
    }
    
}
