//
//  VPLargeRoundedTableViewCell.swift
//  Vida Pet
//
//  Created by Timoteo Holanda on 12/11/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class VPLargeRoundedTableViewCell : UITableViewCell, NibLoadable {

    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var petDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
}
