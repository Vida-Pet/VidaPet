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
        self.textController.normalColor = UIColor.init(named: VPColors.gray.rawValue)
        self.textController.activeColor = UIColor.init(named: VPColors.blue.rawValue)
        self.textController.floatingPlaceholderActiveColor = UIColor.init(named: VPColors.blue.rawValue)
        self.textController.floatingPlaceholderNormalColor = UIColor.init(named: VPColors.gray.rawValue)
        self.tintColor = UIColor.init(named: VPColors.blue.rawValue)
        self.textColor = UIColor.init(named: VPColors.darkBlue.rawValue)
        self.borderView?.bounds = CGRect(origin: self.borderView!.bounds.origin, size: CGSize(width: self.borderView!.bounds.width, height: self.borderView!.bounds.height - 10))
    }
}
