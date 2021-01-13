//
//  APIRouter.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 12/01/21.
//  Copyright © 2021 João Pedro Giarrante. All rights reserved.
//


import Foundation
import Alamofire

enum APIRouter: APIConfiguration {
    
    // MARK: Pet
    case getPets(type: InformationType)
    case getPet(userId: Int, type: InformationType)
    case patchPet(petId: Int, pet: Pet)
    case postPet(userId: Int, pet: Pet)
    
    // MARK: Surgerys
    case getSurgerys(petId: Int)
    case postSurgery(petId: Int, surgery: Int)
    case deleteSurgery(petId: Int, surgeryId: Int)
    
    // MARK: Vacines
    case getVaccines(petId: Int)
    case postVaccine(petId: Int, vaccine: Int)
    case deleteVaccine(petId: Int, vaccineId: Int)
    
    // MARK: User
    case getUsers
    case getUser(token: String)
    case patchUser(userId: Int, user: User)
    case postUser(user: User)
    
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
            
        // MARK: Pet
        case .getPets(_): return .get
        case .getPet(_, _): return .get
        case .patchPet(_, _): return .patch
        case .postPet(_, _): return .post
            
        // MARK: Surgerys
        case .getSurgerys(_): return .get
        case .postSurgery(_, _): return .post
        case .deleteSurgery(_, _): return .delete
            
        // MARK: Vacines
        case .getVaccines(_): return .get
        case .postVaccine(_, _): return .post
        case .deleteVaccine(_, _): return .delete
            
        // MARK: User
        case .getUsers: return .get
        case .getUser(_): return .get
        case .patchUser(_, _): return .patch
        case .postUser(_): return .post
            
        }
    }
    
    
    // MARK: - Parameters
    var parameters: RequestParams {
        switch self {
        
        // MARK: Pet
        case .getPets(let type):
            return .header(["informationType":type.rawValue])
        case .getPet(let userId, let type):
            return .header(["informationType":type.rawValue, "userId":"\(userId)"])
        case .patchPet(let petId, let pet):
            return .body(["petResource":pet.asJSON(), "id":petId])
        case .postPet(let userId, let pet):
            return .body(["pet":pet.asJSON(), "userId":userId])
            
        // MARK: Surgerys
        case .getSurgerys(let petId):
            return .header(["petId":"\(petId)"])
        case .postSurgery(let petId, let surgery):
            return .body(["surgeryResource": surgery, "petId":petId])
        case .deleteSurgery(let petId, let surgeryId):
            return .body(["petId": petId, "id":surgeryId])
            
        // MARK: Vacines
        case .getVaccines(let petId):
            return .header(["petId":"\(petId)"])
        case .postVaccine(let petId, let vaccine):
            return .body(["vaccineResource": vaccine, "petId":petId])
        case .deleteVaccine(let petId, let vaccineId):
            return .body(["petId": petId, "id":vaccineId])
            
        // MARK: User
        case .getUsers:
            return .header([:])
        case .getUser(let token):
            return .header(["token":token])
        case .patchUser(let userId, let user):
            return .body(["userId": userId, "user":user.asJSON()])
        case .postUser(let user):
            return .body(["user":user.asJSON()])
            
        }
    }
    
    
    // MARK: - Path
    var path: String {
        switch self {
            
        // MARK: Pet
        case .getPets(_), .getPet(_, _), .patchPet(_, _), .postPet(_, _):
            return "/pet"
            
        // MARK: Surgerys
        case .getSurgerys(_), .postSurgery(_, _), .deleteSurgery(_, _):
            return "/surgery"
            
        // MARK: Vacines
        case .getVaccines(_), .postVaccine(_, _), .deleteVaccine(_, _):
            return "/vaccine"
            
        // MARK: User
        case .getUsers, .getUser(_), .patchUser(_, _), .postUser(_):
            return "/user"

        }
    }
    
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.ProductionServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        // Parameters
        switch parameters {
            
        case .body(let params):
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            
        case .url(let params):
            let queryParams = params.map { pair  in
                return URLQueryItem(name: pair.key, value: "\(pair.value)")
            }
            var components = URLComponents(string:url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            urlRequest.url = components?.url
            
        case .header(let params):
            for param in params {
                urlRequest.headers.add(name: param.key, value: param.value)
            }
        }
        
        return urlRequest
    }
}
