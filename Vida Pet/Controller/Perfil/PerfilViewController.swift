//
//  PerfilViewController.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 15/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class PerfilViewController: VidaPetMainViewController {
    
    // MARK: - Properties
    
    let emptyField: String = ""
    final let barButtonTitle = "Editar"
    var user : UserData!
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var petsLabel: UILabel!
    @IBOutlet weak var regiaoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    
    // MARK: - IBActions
    
    @IBAction func logOutButton(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
        }
    }
    
    
    // MARK: - Life Cycles
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = R.color.vidaPetBlue()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: barButtonTitle, style: .done, target: self, action: #selector(rightHandAction))
        userImage.setupImage(image: userImage)
//        upDateUserInfo()
    }
    
    
    // MARK: - Methods
    
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
        userNameLabel.text = user.name ?? emptyField
//        userImage.image = UIImage(named: user.image ?? "empty_user")
//        bioLabel.text = user.bio ?? "Bio"
//        
////        if let ownedPet = user.ownedPetsAmount {
////            petsLabel.text = String(ownedPet)
////        } else {
////            petsLabel.text = "Voce ainda não adicionou um pet"
////        }
//        
//        regiaoLabel.text = user.state ?? emptyField
        
    }
}
