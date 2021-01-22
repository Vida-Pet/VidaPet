//
//  Util.swift
//  Vida Pet
//
//  Created by Bruno Freire da Silva on 21/01/21.
//  Copyright © 2021 João Pedro Giarrante. All rights reserved.
//

import Foundation


class GlobalSession{
    
    static let userKey = "userId"
    
    public static func getUserId() -> Int? {
        return UserDefaults.standard.integer(forKey: userKey)
    }
    
    public static func setUser(withId userId: Int?) {
        UserDefaults.standard.set(userId, forKey: userKey)
    }
}
