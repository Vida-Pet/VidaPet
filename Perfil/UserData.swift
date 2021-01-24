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

//struct UserData: Codable {
//    var id: Int
//    var image, name, bio, uid, state: String?
//    var isPublicProfile: Bool?
//}

// MARK: - UserData
struct UserData: Codable {
    var uid: String?
    var id: Int? = 0
    var bio: String?
    var isPublicProfile: Bool?
    var image: String? = nil
    var name: String?
    var state: String?
    var phone: String?
}

struct SimpleUser: Codable {
    var id: Int?
    
    init(id: Int) {
        self.id = id
    }
}




