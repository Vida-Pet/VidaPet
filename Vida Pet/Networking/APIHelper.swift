//
//  APIHelper.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 17/01/21.
//  Copyright © 2021 João Pedro Giarrante. All rights reserved.
//

import Foundation
import Alamofire

enum UrlType: String {
    case pet = "/pet"
    case user = "/user"
    case none = ""
}


class APIHelper {
    
    static private let defaultFullUrl = "https://api-vida-pet.herokuapp.com"
    
    static func request(
        url folder: UrlType = .none,
        aditionalUrl: String = "",
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil) -> DataRequest {
        
        return AF.request("\(defaultFullUrl+folder.rawValue+aditionalUrl)", method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
    }
    
}
