//
//  VPRoundPlaceholderTextField.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 04/11/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields

class VPRoundPlaceholderTextField: MDCTextField {
    var textController: MDCTextInputControllerOutlined!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.textController = MDCTextInputControllerOutlined(textInput: self)
        self.textController.normalColor = R.color.vidaPetGray()
        self.textController.activeColor = R.color.vidaPetBlue()
        self.textController.floatingPlaceholderActiveColor = R.color.vidaPetBlue()
        self.textController.floatingPlaceholderNormalColor = R.color.vidaPetGray()
        self.tintColor = R.color.vidaPetBlue()
        self.textColor = R.color.vidaPetDarkBlue()
    }
    
    func toggleError(_ error: String?) {
        textController.setErrorText(error, errorAccessibilityValue: nil)
    }
    
    func toggleNormal() {
        textController.setErrorText(nil, errorAccessibilityValue: nil)
    }
}
