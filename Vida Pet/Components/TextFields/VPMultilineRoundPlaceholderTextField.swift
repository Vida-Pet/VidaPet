//
//  VPMultilineRoundPlaceholderTextField.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 04/11/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields

class VPMultilineRoundPlaceholderTextField: MDCMultilineTextField {
    var textArea: MDCTextInputControllerOutlinedTextArea!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.textArea = MDCTextInputControllerOutlinedTextArea(textInput: self)
        self.textArea.normalColor = UIColor.init(named: VPColors.gray.rawValue)
        self.textArea.activeColor = UIColor.init(named: VPColors.blue.rawValue)
        self.textArea.floatingPlaceholderActiveColor = UIColor.init(named: VPColors.blue.rawValue)
        self.textArea.floatingPlaceholderNormalColor = UIColor.init(named: VPColors.gray.rawValue)
        self.tintColor = UIColor.init(named: VPColors.blue.rawValue)
        self.textColor = UIColor.init(named: VPColors.darkBlue.rawValue)
    }
}
