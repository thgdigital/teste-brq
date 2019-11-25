//
//  DetailRouter.swift
//  CarsShopping
//
//  Created by Thiago Vaz on 25/11/19.
//  Copyright © 2019 Thiago Vaz. All rights reserved.
//

import UIKit


class DetailRouter {
    
    func makeScreen(idCar: Int) -> DetailView {
        let layout = UICollectionViewFlowLayout()
        let detailController = DetailView(collectionViewLayout: layout)
        let presenter = DetailPresenter(idCars: idCar, manger: CarsManager())
        detailController.presenter = presenter
        presenter.view = detailController
        return detailController
    }
}
