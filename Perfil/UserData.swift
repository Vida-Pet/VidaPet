//
//  User.swift
//  Vida Pet
//
//  Created by Toki on 05/11/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import Foundation

//// MARK: - WelcomeElement
//struct UserData: Codable {
//    var id, image, name, bio: String
//    var ownedPetsAmount: Int
//    var state: String
//}

struct UserData: Codable {
    var id: String?
    var image,name,bio: String?
    var isPublicProfile: Bool?
    var state: String?
}

struct SimpleUser: Codable {
    var id: Int?
    
    init(id: Int) {
        self.id = id
    }
}




