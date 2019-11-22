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
    
    init(manager: CarsManager) {
        self.manager = manager
    }
    
    func fetchCars() {
        manager.fetchCars()
    }
    
}
