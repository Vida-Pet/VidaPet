//
//  AdoteDetalheViewController.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 15/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

class AdoteDetalheViewController: VidaPetMainViewController {
    
    @IBOutlet weak var lbName: UILabel!
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbName.text = self.name
    }
    
    
}
