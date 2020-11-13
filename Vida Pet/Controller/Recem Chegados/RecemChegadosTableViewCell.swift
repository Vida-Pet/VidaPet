//
//  RecemChegadosTableViewCell.swift
//  Vida Pet
//
//  Created by Timoteo Holanda on 10/11/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import Foundation
import UIKit


class RecemChegadosTableViewCell : UITableViewCell {
   
    @IBOutlet weak var petDesc: UILabel!
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var content_view: UIView!
    @IBOutlet weak var racaIdadeDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}


