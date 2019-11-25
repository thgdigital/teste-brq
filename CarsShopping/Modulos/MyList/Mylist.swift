//
//  Mylist.swift
//  CarsShopping
//
//  Created by Thiago Vaz on 25/11/19.
//  Copyright © 2019 Thiago Vaz. All rights reserved.
//

import Foundation

class Mylist: MylistInput {
    weak var view: MylistOuput?
    var  datas: [CarData] = [CarData]()
    var items: [CarsItem] = [CarsItem]()
    func fetch() {
        datas = PurchaseManager.getList()
        items = datas.map({ CarData.create(model: $0)})
        self.view?.fetched(cars: items)
    }
    
    func remove(with item: CarsItem){
        guard let dados = datas.first(where: { $0.id == item.id }) else { return  }
        PurchaseManager.persistentContainer.viewContext.delete(dados)
        PurchaseManager.saveContext()
        datas = PurchaseManager.getList()
        self.view?.fetched(cars: items.filter({$0.id != item.id  }))
    }
}
