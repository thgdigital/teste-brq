//
//  CarsManager.swift
//  CarsShopping
//
//  Created by Thiago Vaz on 21/11/19.
//  Copyright © 2019 Thiago Vaz. All rights reserved.
//

import Foundation
import Alamofire


class CarsManager: NSObject {
    
    func fetchCars() {
        Alamofire.request(Router.getCars).validate().responseJSON { response in
            debugPrint(response)
        }
    }
}

