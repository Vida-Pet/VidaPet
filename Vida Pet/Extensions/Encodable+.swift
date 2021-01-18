//
//  Encodable+.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 13/01/21.
//  Copyright © 2021 João Pedro Giarrante. All rights reserved.
//

import Foundation

extension Encodable {
    
    func asJSON() -> Any? {
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(self)
        let json = String(data: jsonData!, encoding: String.Encoding.utf8)
        
        if let data = json!.data(using: .utf8) {
            do {
                if let jsonArray = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                    return jsonArray
                }
            } catch {
                return nil
            }
        }
        return nil
    }
}
