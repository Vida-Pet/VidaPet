//
//  MeusPetsDetalheViewController.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 15/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

class MeusPetsDetalheViewController: VidaPetMainViewController {
    
    
    // MARK: IBOutlets
    
    @IBOutlet weak var lblNome: UILabel!
    @IBOutlet weak var lblDescricao: UILabel!
    @IBOutlet weak var imgPet: UIImageView!
    @IBOutlet weak var viewHeader: UIView!
    
    
    // MARK: Variables
    
    var imgPetData: UIImage?
    var lblNomeData: String?
    var lblDescricaoData: String?
    
    
    // MARK: Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgPet?.image = imgPetData
        lblNome?.text = lblNomeData
        lblDescricao?.text = lblDescricaoData
    }
    
}
