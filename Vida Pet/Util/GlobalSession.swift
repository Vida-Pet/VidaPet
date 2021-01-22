//
//  Util.swift
//  Vida Pet
//
//  Created by Bruno Freire da Silva on 21/01/21.
//  Copyright © 2021 João Pedro Giarrante. All rights reserved.
//

import Foundation


class GlobalSession{
    
    static let userKey = "user"
    
    public static func getUser() -> UserData? {
        if let userData = UserDefaults.standard.data(forKey: userKey),
            let user = try? JSONDecoder().decode(UserData.self, from: userData) {
            return user
        }
        return nil
    }
    
    public static func setUser(user: Data) {
        UserDefaults.standard.set(user, forKey: userKey)
    }
}
