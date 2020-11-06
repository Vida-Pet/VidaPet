//
//  MeusPetsDetalheViewController.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 15/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

class MeusPetsDetalheViewController: VidaPetMainViewController {
    
    
    // MARK: Properties
    
    let segueIdentifierCadastro = "MeusPetsDetalhesToMeusPetsCadastro"
    
    
    // MARK: IBOutlets
    
    @IBOutlet weak var lblNome: UILabel!
    @IBOutlet weak var lblDescricao: UILabel!
    @IBOutlet weak var imgPet: UIImageView!
    @IBOutlet weak var viewHeader: UIView!
    
    
    // MARK: IBActions
    
    @IBAction func clickEdit(_ sender: UIButton) {
        performSegue(withIdentifier: segueIdentifierCadastro, sender: self)
    }

    
    
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
    
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case segueIdentifierCadastro: break
//            if let cadastroVC = segue.destination as? MeusPetsCadastroViewController {
//                cadastroVC.pet = // TODO: Enviar dados do Pet para a tela de edição, e modificá-la para edita Pet, e não criar um novo...
//            }
        default: break
        }
    }
    
}
