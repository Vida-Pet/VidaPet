//
//  GradientView.swift
//  Vida Pet
//
//  Created by Timoteo Holanda on 12/11/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GradientView: UIView {
    @IBInspectable var FirstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    @IBInspectable var SecondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [FirstColor.cgColor, SecondColor.cgColor]
    }
}
