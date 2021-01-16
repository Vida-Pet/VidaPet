//
//  Constants.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 12/01/21.
//  Copyright © 2021 João Pedro Giarrante. All rights reserved.
//

import Foundation
import Alamofire

struct Constants {
    struct ProductionServer {
        static let baseURL = "https://api-vida-pet.herokuapp.com"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case string = "String"
    
}

enum ContentType: String {
    case json = "Application/json"
    case formEncode = "application/x-www-form-urlencoded"
}

enum RequestParams {
    case body(_:Parameters)
    case url(_:Parameters)
    case header(_:[String:String])
}
//https://api-vida-pet.herokuapp.com/swagger-ui.html#/Usuario/salvarUsuarioUsingPOST
