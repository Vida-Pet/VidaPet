//
//  RecemChegadosDetalheViewController.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 15/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

class RecemChegadosDetalheViewController: VidaPetMainViewController {
    
    
    // MARK: Properties
    
    var pet : Pet?
    var selectedPetIndex : Int?
    
    
    // MARK: IBOutlets
    
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
    
    
    // MARK: Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    // MARK: Methods

    private func setupView() {
        detailPetImage.contentMode = .scaleAspectFit
        detailPetImage.clipsToBounds = true
        detailPetImage.image = UIImage(data: pet!.dataImage!)?.squared()
        if let safePet = pet {
            petName.text = safePet.name
            petSub.text = safePet.info.breed
            petDesc.text = safePet.description
            petRace.text = safePet.info.breed
            petAge.text = safePet.info.birth?.ageFromDate(withFormatter: defaultDateFormatter).formatAge()
            petWeight.text = "\(safePet.info.weight!) Kg"
            petCoat.text = safePet.info.coat
            petGender.text = safePet.info.gender
        }
    }
    
    
    
}
