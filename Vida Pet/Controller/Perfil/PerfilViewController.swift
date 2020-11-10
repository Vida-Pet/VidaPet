//
//  PerfilViewController.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 15/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

class PerfilViewController: VidaPetMainViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var petsLabel: UILabel!
    @IBOutlet weak var regiaoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    var userModel = UserModel()
    final let segueIdentifierEdit = "fromPerfilToEdit"
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = R.color.vidaPetBlue()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit,target: self,
                                                                 action: #selector(rightHandAction))
    }
    
    @objc
    func rightHandAction() {
        performSegue(withIdentifier: segueIdentifierEdit, sender: self)
    }
    
    func setupImage(){
        userImage.layer.cornerRadius = userImage.frame.width / 2
        userImage.layer.borderColor = R.color.vidaPetBlue()?.cgColor
        // MARK: - TODO: guardar este valor como um let lá em cima -
        userImage.layer.borderWidth = 2.0
        userImage.clipsToBounds = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == segueIdentifierEdit {
            _ = segue.destination as! EditarPerfilViewController
            
        }
    }
    
    func upDateUserInfo(){
        userNameLabel.text = userModel.user.name
        userImage.image = UIImage(named: userModel.user.image)
        
    }
}
