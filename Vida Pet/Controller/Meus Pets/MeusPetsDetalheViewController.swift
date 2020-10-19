//
//  MeusPetsDetalheViewController.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 15/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

class MeusPetsDetalheViewController: VidaPetMainViewController {
    
    @IBOutlet weak var lblNome: UILabel!
    @IBOutlet weak var lblDescricao: UILabel!
    @IBOutlet weak var imgPet: UIImageView!
    @IBOutlet weak var viewHeader: UIView!
    
    
    var imgPetData: UIImage?
    var lblNomeData: String?
    var lblDescricaoData: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgPet.image = imgPetData
        lblNome.text = lblNomeData
        lblDescricao.text = lblDescricaoData
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
