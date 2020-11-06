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
        self.textArea.normalColor = R.color.vidaPetGray()
        self.textArea.activeColor = R.color.vidaPetBlue()
        self.textArea.floatingPlaceholderActiveColor = R.color.vidaPetBlue()
        self.textArea.floatingPlaceholderNormalColor = R.color.vidaPetGray()
        self.tintColor = R.color.vidaPetBlue()
        self.textColor = R.color.vidaPetDarkBlue()
    }
}
