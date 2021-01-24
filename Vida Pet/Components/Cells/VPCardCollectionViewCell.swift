//
//  AdotaCollectionViewCell.swift
//  Vida Pet
//
//  Created by Bruno Freire da Silva on 11/11/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

class VPCardCollectionViewCell: UICollectionViewCell {
    
    var pet : Pet!

    @IBOutlet weak var imgPet: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var imgGender: UIImageView!
    @IBOutlet weak var widthConstant: NSLayoutConstraint!
    final let defaultCornerRadius: CGFloat = 5
    final let defaultNumberOfCollumns: CGFloat = 2
    final let defaultCardSpaces: CGFloat = 15
    final let mockCellCountMultiplier: Int = 5
    var mockCellIndex: [Int] = []
    var cellWidth: CGFloat {
        return (UIScreen.main.bounds.width / defaultNumberOfCollumns) - (((defaultNumberOfCollumns+1) * defaultCardSpaces)/defaultNumberOfCollumns)
    }
    var showDetailDelegate : ShowDetailProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(){
        if self.pet != nil {
            self.imgPet.image = self.pet.image?.decodeBase64ToImage()  ?? R.image.avataDog()!
            self.lbName.text = pet.name
            self.lbAddress.text = pet.info.size
            self.layer.cornerRadius = defaultCornerRadius
            self.widthConstant.constant = cellWidth
        }
    }
    
    @IBAction func showDetail(_ sender: UIButton) {
        showDetailDelegate.showDetail(pet: pet)
    }
   
    
    
}
