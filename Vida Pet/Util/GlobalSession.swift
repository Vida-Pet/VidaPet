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
    static let userUid = "userUid"
    static let emailKey = "email"
    static let pwdKey = "pwd"
    
    public static func getUserId() -> Int? {
        return UserDefaults.standard.integer(forKey: userKey)
    }
    
    public static func getUserUid() -> String? {
        return UserDefaults.standard.string(forKey: userUid)
    }
    
    public static func setUser(withId userId: Int?, andUid uid: String?) {
        UserDefaults.standard.set(userId, forKey: userKey)
        UserDefaults.standard.set(uid, forKey: userUid)
    }
    
    public static func setEmail(email: String){
        UserDefaults.standard.set(email, forKey: emailKey)
    }
    
    public static func getEmail() -> String? {
        return UserDefaults.standard.string(forKey: emailKey)
    }
    
    public static func setPwd(pwd: String){
        UserDefaults.standard.set(pwd, forKey: pwdKey)
    }
    
    public static func getPwd() -> String? {
        return UserDefaults.standard.string(forKey: pwdKey)
    }
    
}
