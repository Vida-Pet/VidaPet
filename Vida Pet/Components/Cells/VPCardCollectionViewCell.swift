//
//  AdotaCollectionViewCell.swift
//  Vida Pet
//
//  Created by Bruno Freire da Silva on 11/11/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

class VPCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgPet: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var imgGender: UIImageView!
    @IBOutlet weak var widthConstant: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}