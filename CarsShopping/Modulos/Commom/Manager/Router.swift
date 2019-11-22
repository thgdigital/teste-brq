//
//  Router.swift
//  CarsShopping
//
//  Created by Thiago Vaz on 21/11/19.
//  Copyright © 2019 Thiago Vaz. All rights reserved.
//

import Alamofire

enum Router: URLRequestConvertible {
    case getCars
    case readCar(idCar: String)
    
    static let baseURLString = "http://desafiobrq.herokuapp.com/v1/"

    var method: HTTPMethod {
        switch self {
        case .getCars:
            return .get
        case .readCar:
            return .get
        }
    }

    var path: String {
        switch self {
        case .getCars:
            return "/carro/"
        case .readCar(let idCar):
            return "/carro/\(idCar)"
        }
    }

    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}
