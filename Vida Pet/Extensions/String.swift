//
//  String.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 06/11/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import Foundation

public extension String {
    func indexFirst(of char: Character) -> Int? {
        return firstIndex(of: char)?.utf16Offset(in: self)
    }
    
    func indexLast(of char: Character) -> Int? {
        return lastIndex(of: char)?.utf16Offset(in: self)
    }
}
