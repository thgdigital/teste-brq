//
//  MylistRoute.swift
//  CarsShopping
//
//  Created by Thiago Vaz on 25/11/19.
//  Copyright © 2019 Thiago Vaz. All rights reserved.
//

import UIKit

class MylistRoute {

    func makeScreen() -> MylistView {
        let layout = UICollectionViewFlowLayout()
        let mylistView = MylistView(collectionViewLayout: layout)
        let presenter = Mylist()
        presenter.view = mylistView
        mylistView.presenter = presenter

        return mylistView
    }
}
