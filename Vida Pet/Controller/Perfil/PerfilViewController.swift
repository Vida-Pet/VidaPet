//
//  PerfilViewController.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 15/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

class PerfilViewController: VidaPetMainViewController {

    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var petsLabel: UILabel!
    @IBOutlet weak var regiaoLabel: UILabel!
    @IBOutlet weak var inicioLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageButton.setImage(UIImage(named: "userImage.png"), for: .normal)
        imageButton.imageView?.contentMode = .scaleAspectFit
        imageButton.imageView?.layer.cornerRadius = (imageButton.imageView?.frame.width)! / 2
        imageButton.imageView?.layer.borderColor = #colorLiteral(red: 0.1842333972, green: 0.7304695249, blue: 0.7287064195, alpha: 1)
        imageButton.imageView?.layer.borderWidth = 2.0
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    
   
    @IBAction func imagePressed(_ sender: UIButton) {
        print("image pressed")
    }
}
