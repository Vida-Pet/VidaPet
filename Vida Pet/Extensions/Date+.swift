//
//  Date+.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 17/01/21.
//  Copyright © 2021 João Pedro Giarrante. All rights reserved.
//

import Foundation

extension Date {
    struct Formatter {
        static let iso8601: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
            return formatter
        }()
        
        
        static let defaultDate: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter
        }()
    }
    var iso8601: String { return Formatter.iso8601.string(from: self) }
    var defaultDate: String  { return Formatter.defaultDate.string(from: self) }
}
