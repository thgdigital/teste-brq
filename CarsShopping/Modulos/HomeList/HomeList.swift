//
//  HomeList.swift
//  CarsShopping
//
//  Created by Thiago Vaz on 21/11/19.
//  Copyright © 2019 Thiago Vaz. All rights reserved.
//

import Foundation

class HomeList: HomeListInput {
    var manager: CarsManager
    
    weak var view: HomeListOutput?
    
    var lists: [CarsItem] = [CarsItem]()
    
    var isPaginate = true
    
    var route: HomeListRoute
    
    var limitCompra: Int = 100000
    
    
    init(manager: CarsManager, route: HomeListRoute) {
        self.manager = manager
        self.route = route
    }
    
    func fetchCars() {
        view?.startLoading()
        manager.fetchCars { (lists, error) in
            self.view?.stopLoading()
            guard error == nil else {
                self.castError(error: error)
                return
            }
            
            guard let lists = lists, !lists.isEmpty else {
                self.view?.error(type: .empty(message: "Dados Vazios"))
                return
            }
            
            self.lists = lists.map({ CarsItemMapper.make(model: $0) })
            self.lists.append(CarsItemLoading())
            self.view?.fetched(cars: self.lists)
        }
    }
    
    func retry() {
        fetchCars()
    }
    
    func paginate() {
        if isPaginate {
            isPaginate = false
            var newsLists = self.filterLoading()
            newsLists.append(CarsItemLoading())
            self.lists.append(contentsOf: newsLists)
            self.view?.fetched(paginate: self.lists)
            isPaginate = true
        }
        
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
    
    func filterLoading() -> [CarsItem] {
        lists = lists.filter({ !($0 is CarsItemLoading) })
        return lists
    }
    
    func didSelected(with item: CarsItem) {
        route.showDetail(idCars: item.id)
    }
    
    func sendCompra(with item: CarsItem) {
        let dataDados = PurchaseManager.getList()
        
        if dataDados.isEmpty {
            item.quantidade = 1
            _ = PurchaseManager.save(item: item)
        } else {
            var total: Int = 0
            for dados in dataDados {
                print(dados.quantidade)
                total = Int(dados.valor * Float(dados.quantidade))
            }
            
            if total < limitCompra, (total + item.preco) <= limitCompra {
                if let dados = dataDados.first(where: { $0.id == item.id }) {
                    dados.quantidade += 1
                   _ = PurchaseManager.saveContext()
                } else {
                      item.quantidade = 1
                    _ = PurchaseManager.save(item: item)
                }
                
            } else {
                view?.error(type: .compraLimite(message: "Você passou limite de compra"))
            }
            
        }
    }
}
