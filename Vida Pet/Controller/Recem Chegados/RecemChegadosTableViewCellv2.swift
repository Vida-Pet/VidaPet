//
//  RecemChegadosTableViewCellv2.swift
//  Vida Pet
//
//  Created by Timoteo Holanda on 12/11/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RecemChegadosTableViewCellv2 : UITableViewCell, NibLoadable {
    let nibName = "RecemChegadosTableViewCellv2"
    
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var petDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
       
        
        
        
    }
}
