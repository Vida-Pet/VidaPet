//
//  UIImage.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 24/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

extension UIImage {
    
    func encodeImageToBase64() -> String {
        let imageData:NSData = self.jpegData(compressionQuality: 0.50)! as NSData
        return imageData.base64EncodedString()
    }
}
