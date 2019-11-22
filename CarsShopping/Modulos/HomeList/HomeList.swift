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
    
    
    init(manager: CarsManager) {
        self.manager = manager
    }
    
    func fetchCars() {
       manager.fetchCars { (lists, error) in
            guard let lists = lists, !lists.isEmpty, error == nil else {
                return
            }
          
            self.lists = lists.map({ CarsItemMapper.make(model: $0) })
            self.lists.append(CarsItemLoading())
            self.view?.fetched(cars: self.lists)
        }
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
    
    func filterLoading() -> [CarsItem] {
       lists = lists.filter({ !($0 is CarsItemLoading) })
       return lists
    }
}
