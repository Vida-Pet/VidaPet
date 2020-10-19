//
//  MeusPetsListaCellTableViewCell.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 19/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

class MeusPetsListaCellTableViewCell: UITableViewCell {

    @IBOutlet weak var imgPet: UIImageView!
    @IBOutlet weak var lblNome: UILabel!
    @IBOutlet weak var lblDescricao: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var viewShadow: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let faded = UIView(frame: bounds)
        faded.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2527989665)
        self.selectedBackgroundView = faded
        
        
        
        // Rounded Corner
        viewContent.layer.cornerRadius = 12
        viewContent.layer.masksToBounds = true
    }
}


