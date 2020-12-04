//
//  User.swift
//  Vida Pet
//
//  Created by Toki on 05/11/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import Foundation

struct User: Codable {
    var id: Int?
    var image,name,bio: String?
    var isPublicProfile: Bool?
    var ownedPetsIds: [Int]?
}





