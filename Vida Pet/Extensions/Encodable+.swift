//
//  Encodable+.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 13/01/21.
//  Copyright © 2021 João Pedro Giarrante. All rights reserved.
//

import Foundation

extension Encodable {
    func asJSON() -> String {
        guard
            let jsonData = try? JSONEncoder().encode(self),
            let jsonString = String(data: jsonData, encoding: .utf8)
        else { return "" }
        return jsonString
    }
}
