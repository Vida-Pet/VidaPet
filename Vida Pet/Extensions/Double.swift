//
//  Double.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 13/11/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import Foundation

extension Double {
    
    func formatAge() -> String {
        if(self > 1) {
            return "\(Int(floor(self))) anos"
        }
        else {
            let age = self * 12
            return "\(Int(floor(age))) meses"
        }
    }
}
