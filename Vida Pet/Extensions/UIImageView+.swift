//
//  AvatarImage.swift
//  Vida Pet
//
//  Created by Toki on 09/11/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func setupImage(image: UIImageView){
        image.layer.cornerRadius = image.frame.width / 2
        image.layer.borderColor = R.color.vidaPetBlue()?.cgColor
        image.layer.borderWidth = 2.0
        image.clipsToBounds = true
    }
    
}
