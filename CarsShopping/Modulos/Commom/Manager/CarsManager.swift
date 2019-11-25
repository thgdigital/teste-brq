//
//  CarsManager.swift
//  CarsShopping
//
//  Created by Thiago Vaz on 21/11/19.
//  Copyright © 2019 Thiago Vaz. All rights reserved.
//

import Foundation
import Alamofire
import CoreData


class CarsManager: NSObject {
    
    func fetchCars(with completion: @escaping ((_ list: ListCarsModel?, _ error: Error?) -> Void)) {
        
        Alamofire.request(Router.getCars).validate().responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                guard let data = response.data, let listModel: ListCarsModel  = self.decodeParse(jsonData: data) else {
                    completion(nil, nil)
                    return
                }
                
                completion(listModel, nil)
                
            case .failure(let error):
                completion(nil, error)
                
            }
        }
    }
    
    func fetchCar(idCar:Int, completion: @escaping ((_ list: CarModel?, _ error: Error?) -> Void)) {
           
           Alamofire.request(Router.readCar(idCar: idCar)).validate().responseJSON { response in
               
               switch response.result {
                   
               case .success:
                   
                guard let data = response.data, let carModel: CarModel = self.decodeParse(jsonData: data) else {
                       completion(nil, nil)
                       return
                   }
                   
                   completion(carModel, nil)
                   
               case .failure(let error):
                   completion(nil, error)
                   
               }
           }
    }
    
    func decodeParse<T: Codable>(jsonData: Data) -> T? {
         do {
             let decoder = JSONDecoder()
             let items = try decoder.decode(T.self, from: jsonData)
             return items
         } catch {
             return nil
         }
     }
}

enum ErrorType: Error {
    case serve(message: String)
    case empty(message: String)
    case network(message: String)
    case compraLimite(message: String)
}
