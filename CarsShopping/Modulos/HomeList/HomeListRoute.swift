//
//  HomeListRoute.swift
//  CarsShopping
//
//  Created by Thiago Vaz on 21/11/19.
//  Copyright © 2019 Thiago Vaz. All rights reserved.
//

import UIKit

class HomeListRoute: NSObject {
    
    var window: UIWindow?
    var navigation: UINavigationController?
    
    func makeScreen(window: UIWindow?) -> UINavigationController? {
        let presenter = HomeList(manager: CarsManager(), route: self)
        let layout = UICollectionViewFlowLayout()
        let homeController = HomeListView(collectionViewLayout: layout)
        presenter.view = homeController
        homeController.presenter = presenter
        navigation = UINavigationController(rootViewController: homeController)
        self.window = window
        return navigation
    }
    
    func showDetail(idCars: Int) {
        self.navigation?.pushViewController(DetailRouter().makeScreen(idCar: idCars), animated: true)
    }
    func showmylist(){
       self.navigation?.pushViewController(MylistRoute().makeScreen(), animated: true)
    }
}
