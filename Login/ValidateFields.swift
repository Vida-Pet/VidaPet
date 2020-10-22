//
//  ValidateFields.swift
//  Vida Pet
//
//  Created by Toki on 22/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import Foundation

struct ValidateFields {
    
    func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
   
}
