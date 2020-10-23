//
//  ValidateFields.swift
//  Vida Pet
//
//  Created by Toki on 22/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import Foundation

struct ValidateFields {
    
    static func validateFieldsLogin(email: String, password: String) -> String? {
        if email.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            password.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Favor preencher todos os campos"
        }
        
        let cleanedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //valida uma senha
        if cleanedPassword.count < 6 {
            return "Favor insira uma senha valida com 6 caracteres"
        }
        
        return nil
    }
    
    static func validateFieldsRegister(name: String, email:String, password: String, confirmPassword: String) -> String? {
        
    
        if name.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            email.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            {
            return "Favor preencher todos os campos"
        }
        
        let cleanedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedConfirmaPassword = confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        if cleanedPassword.count < 6 {
            return "Favor insira uma senha valida com 6 caracteres"
        }
        
        return nil
    }

//    static func isPasswordValid(_ password : String) -> Bool {
//
//    let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
//    return passwordTest.evaluate(with: password)
//}
    
   }
