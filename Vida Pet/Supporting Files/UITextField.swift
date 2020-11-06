//
//  UITextField.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 06/11/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

extension UITextField {
    
    func validateDate(string: String, range: NSRange, dateFormatter: DateFormatter, dateDivisor: Character) -> Bool {
        var errorAction: EmptyClosure?
        var normalAction: EmptyClosure?
        if let vpTxtField = self as? VPRoundPlaceholderTextField {
            errorAction = {
                vpTxtField.toggleError(R.string.meusPetsCadastro.error_wrong_date())
            }
            normalAction = {
                vpTxtField.toggleNormal()
            }
        }
        guard Int(string) != nil || string.isEmpty else { return false }
        guard range.location <= dateFormatter.dateFormat.count-11 else { return false }
        if self.text?.count == dateFormatter.dateFormat.indexFirst(of: dateDivisor) || self.text?.count == dateFormatter.dateFormat.indexLast(of: dateDivisor) {
            if !(string.isEmpty) {
                self.text?.append(dateDivisor)
            }
        }
        if dateFormatter.date(from: self.text?.appending(string) ?? "") == nil && range.location == 9 {
            errorAction?()
        } else {
            if let data = dateFormatter.date(from: self.text?.appending(string) ?? "")  {
                if data.timeIntervalSinceNow > 0 {
                    errorAction?()
                } else {
                    normalAction?()
                }
            } else {
                normalAction?()
            }
        }
        return !(self.text!.count > 9 && (string.count ) > range.length)
    }
}
