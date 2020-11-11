//
//  ValidateFields.swift
//  Vida Pet
//
//  Created by Toki on 22/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

enum Errors: String {
    case
        fufillAllFields = "Favor preencher todos os campos",
        invalidNameEmpty = "Favor preencher o Nome",
        invalidEmailEmpty = "Favor preencher o Email",
        invalidPasswordSize = "Favor insira uma senha com no mínimo 6 caracteres",
        invalidPasswordFormat = "Sua senha deve ter pelo menos 1 caracter especial",
        invalidConfirmPassword = "Confirmacao de senha deve ser igual a senha"
}

class ValidateFields {
    
    // MARK: - Properties
    
    static let EMPTY_STRING = ""
    
    
    // MARK: - External Methods
    
    static func validateFieldsLogin(email: String, password: String) -> String? {
        
        let cleanedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let emailError = validateEmail(cleanedEmail) {
            return emailError
            
        } else if let passwordError = validatePassword(cleanedPassword) {
            return passwordError
            
        } else {
            return nil
            
        }
    }
    
    static func validateFieldsRegister(name: String, email:String, password: String, confirmPassword: String) -> String? {
        
        let cleanedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
//        let cleanedConfirmPassword = confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let nameError = validateName(cleanedName) {
            return nameError
            
        } else if let emailError = validateEmail(cleanedEmail) {
            return emailError
            
        } else if let passwordError = validatePassword(cleanedPassword) {
            return passwordError
            
        } else if let confirmPasswordError = validateConfirmPassword(cleanedPassword, confirmPassword) {
            return confirmPasswordError
            
        } else {
            return nil
            
        }
    }
    
    
    // MARK: - Internal Methods
    
    fileprivate static func validateName(_ name: String) -> String? {
        if (name == EMPTY_STRING) {
            return Errors.invalidNameEmpty.rawValue
            
        } else {
            return nil
            
        }
    }
    
    fileprivate static func validateEmail(_ email: String) -> String? {
        if (email == EMPTY_STRING) {
            return Errors.invalidEmailEmpty.rawValue
            
        } else {
            return nil
            
        }
    }
    
    fileprivate static func validatePassword(_ password: String) -> String? {
        
        if(!isPasswordSizeValid(password)) {
            return Errors.invalidPasswordSize.rawValue
        
        } else if(!isPasswordFormatValid(password)) {
            return Errors.invalidPasswordFormat.rawValue
            
        } else {
            return nil
    
        }
    }

    fileprivate static func validateConfirmPassword(_ password: String, _ confirmPassword: String) -> String? {
        
        if(password != confirmPassword ) {
            return Errors.invalidConfirmPassword.rawValue
        } else {
            return nil
        }
    
    }
    
    fileprivate static func isPasswordSizeValid(_ password: String) -> Bool {
        return !(password.count < 6)
    }

    fileprivate static func isPasswordFormatValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,}")
        return passwordTest.evaluate(with: password)
    }
}
