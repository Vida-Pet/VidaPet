//
//  AdoteDetalheViewController.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 15/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

class AdoteDetalheViewController: VidaPetMainViewController {
    
    var pet: Pet?
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var ivPetImage: UIImageView!
    @IBOutlet weak var ivFavorito: UIImageView!
    
    final let defaultButtonCornerRadius: CGFloat = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.clickFavorito))
        ivFavorito.addGestureRecognizer(tapGR)
        ivFavorito.isUserInteractionEnabled = true
        
        setup()
    }
    
    @objc func clickFavorito(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let refreshAlert = UIAlertController(title: "Favorito", message: "Gostaria de favoritar?", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Sim", style: .default, handler: { (action: UIAlertAction!) in
                self.ivFavorito.tintColor = .yellow

            }))

            refreshAlert.addAction(UIAlertAction(title: "Não", style: .cancel, handler: { (action: UIAlertAction!) in
            }))

            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    func setup(){
        ivPetImage.image = self.pet?.image?.decodeBase64ToImage() ?? R.image.avataDog()!
        
        lbName.text = pet?.name
    }
    
}
