//
//  UITextField.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 06/11/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

extension UITextField {
    
    func validateDate(string: String, range: NSRange, dateFormatter: DateFormatter, dateDivisor: Character, errorAction: EmptyClosure? = nil, normalAction: EmptyClosure? = nil) -> Bool {
        var errorAction: EmptyClosure? = errorAction
        var normalAction: EmptyClosure? = normalAction
        if let vpTxtField = self as? VPRoundPlaceholderTextField {
            errorAction = {
                vpTxtField.toggleError(R.string.meusPetsCadastro.error_wrong_date())
            }
            normalAction = {
                vpTxtField.toggleNormal()
            }
        }
        guard Int(string) != nil || string.isEmpty else { return false }
        guard range.location <= dateFormatter.dateFormat.count-1 else { return false }
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
    
    func setStyleRounded(withRadius radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    private func setPasswordToggleImage(_ button: UIButton) {
        if(isSecureTextEntry){
            button.setImage(UIImage(named: "eyeopen.png"), for: .normal)
        }else{
            button.setImage(UIImage(named: "eyeclosed.png"), for: .normal)
            
        }
    }
    
    func enablePasswordToggle(){
        let button = UIButton(type: .custom)
        setPasswordToggleImage(button)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.togglePasswordView), for: .touchUpInside)
        self.rightView = button
        self.rightViewMode = .always
    }
    
    @IBAction func togglePasswordView(_ sender: Any) {
        self.isSecureTextEntry = !self.isSecureTextEntry
        setPasswordToggleImage(sender as! UIButton)
    }
    
    func validateInput() -> Bool {
        return self.text != nil && self.text!.count > 0
    }
}
