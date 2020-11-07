//
//  String.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 06/11/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

public extension String {
    
    
    
    func indexFirst(of char: Character) -> Int? {
        return firstIndex(of: char)?.utf16Offset(in: self)
    }
    
    func indexLast(of char: Character) -> Int? {
        return lastIndex(of: char)?.utf16Offset(in: self)
    }
    
    func decodeBase64ToImage() -> UIImage? {
        let dataDecoded:NSData = NSData(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 0))!
        return UIImage(data: dataDecoded as Data)
    }
    
    func ageFromDate(withFormatter formatter: DateFormatter) -> Double {
        let secondsInYear = 31556926.0
        let birthday = formatter.date(from: self)
        let timeInterval = birthday?.timeIntervalSinceNow
        return abs(Double(timeInterval! / secondsInYear))
    }
}
