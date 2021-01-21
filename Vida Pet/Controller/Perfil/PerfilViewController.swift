//
//  PerfilViewController.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 15/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit
import Firebase

class PerfilViewController: VidaPetMainViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var petsLabel: UILabel!
    @IBOutlet weak var regiaoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    var userModel = UserModel()
    final let barButtonTitle = "Editar"
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        upDateUserInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = R.color.vidaPetBlue()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: barButtonTitle, style: .done, target: self, action: #selector(rightHandAction))
        
        userImage.setupImage(image: userImage)
    }
    
    @objc
    func rightHandAction() {
        performSegue(withIdentifier: R.segue.perfilViewController.fromPerfilToEdit.identifier, sender: self)
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == R.segue.perfilViewController.fromPerfilToEdit.identifier {
            _ = segue.destination as! EditarPerfilViewController
            
        }
    }
    
    func upDateUserInfo(){
        userNameLabel.text = userModel.user.name
        userImage.image = UIImage(named: userModel.user.image ?? "")
        bioLabel.text = userModel.user.bio
        //        petsLabel.text = userModel.user.ownedPetsIds
        //        dateLabel.text = userModel.user.date
        
    }
    
    @IBAction func logOutButton(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            
        }
    }
}
