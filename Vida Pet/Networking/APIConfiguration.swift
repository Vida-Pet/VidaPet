//
//  APIConfiguration.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 12/01/21.
//  Copyright © 2021 João Pedro Giarrante. All rights reserved.
//

import Foundation
import Alamofire

protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: RequestParams { get }
}
