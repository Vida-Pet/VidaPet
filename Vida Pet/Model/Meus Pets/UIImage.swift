//
//  UIImage.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 24/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

func decodeBase64ToImage(base64: String) -> UIImage {
    let dataDecoded:NSData = NSData(base64Encoded: base64, options: NSData.Base64DecodingOptions(rawValue: 0))!
    return UIImage(data: dataDecoded as Data)!
}
