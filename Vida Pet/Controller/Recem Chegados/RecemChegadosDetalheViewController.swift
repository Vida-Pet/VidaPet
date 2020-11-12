//
//  RecemChegadosDetalheViewController.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 15/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

class RecemChegadosDetalheViewController: VidaPetMainViewController {
    
    var pet : Pet?
    var selectedPetIndex : Int?
    
    @IBOutlet weak var detailPetImage: UIImageView!
    @IBOutlet weak var petName: UILabel!
    @IBOutlet weak var petSub: UILabel!
    @IBOutlet weak var petDesc: UILabel!
    @IBOutlet weak var petRace: UILabel!
    @IBOutlet weak var petSize: UILabel!
    @IBOutlet weak var petAge: UILabel!
    @IBOutlet weak var petWeight: UILabel!
    @IBOutlet weak var petCoat: UILabel!
    @IBOutlet weak var petGender: UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        detailPetImage.contentMode = .scaleAspectFit
        detailPetImage.clipsToBounds = true
        
        detailPetImage.image = UIImage(data: pet!.dataImage!)?.squared()
        petName.text = pet!.name
        petSub.text = pet!.info.breed
        petDesc.text = pet!.petDescription
        petRace.text = pet!.info.breed
        petAge.text = formatAge()
        petWeight.text = "\(pet!.info.weight!) Kg"
        petCoat.text = pet!.info.coat
        petGender.text = pet!.info.gender
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func formatAge() -> String {
        var formattedAge = ""
        if var age = pet!.info.birth?.ageFromDate(withFormatter: defaultDateFormatter) {
            if(age > 1) {
                formattedAge = "\(Int(floor(age))) anos"
            }
            else {
                age *= 12
                formattedAge = "\(Int(floor(age))) meses"
            }
        }
        return formattedAge
        
        
    }
    
    
    
}
