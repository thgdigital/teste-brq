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
    var carItem: CarsItem = CarsItem()
    var limitCompra: Int = 100000
    
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
            self.carItem = CarsItemMapper.make(model: carModel)
            self.view?.fetched(item: self.carItem)
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
    
    func compra(with qtd: Int) {
        let dataDados = PurchaseManager.getList()
        
        if dataDados.isEmpty {
            carItem.quantidade = qtd
            _ = PurchaseManager.save(item: carItem)
            self.view?.showSuccess(message: "Sua compra foi realizado com sucesso")
        } else {
            var total: Int = 0
            for dados in dataDados {
              
                total += Int(dados.valor * Float(dados.quantidade))
            }
            
            if total < limitCompra, (total + carItem.preco * qtd) <= limitCompra {
                if let dados = dataDados.first(where: { $0.id == carItem.id }) {
                    dados.quantidade = Int64(qtd)
                   _ = PurchaseManager.saveContext()
                    self.view?.showSuccess(message: "Sua compra foi realizado com sucesso")
                } else {
                      carItem.quantidade = qtd
                    _ = PurchaseManager.save(item: carItem)
                    self.view?.showSuccess(message: "Sua compra foi realizado com sucesso")
                }
                
            } else {
                view?.error(type: .compraLimite(message: "Você passou limite de compra"))
            }
            
        }
    }
    
}
