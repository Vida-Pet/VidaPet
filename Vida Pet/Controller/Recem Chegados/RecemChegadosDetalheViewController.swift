//
//  RecemChegadosDetalheViewController.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 15/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

class RecemChegadosDetalheViewController: VidaPetMainViewController {
    @IBOutlet weak var detailPetImage: UIImageView!
    
    var pet : Pet?
    var selectedPetIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailPetImage.contentMode = .scaleAspectFit
        detailPetImage.clipsToBounds = true
        
        detailPetImage.image = UIImage(data: pet!.dataImage!)?.squared()
        

        // Do any additional setup after loading the view.
    }
    

    

}
