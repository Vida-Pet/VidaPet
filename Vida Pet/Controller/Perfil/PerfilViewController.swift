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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1842333972, green: 0.7304695249, blue: 0.7287064195, alpha: 1)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit,target: self,
                                                                 action: #selector(rightHandAction))
    }
    
    @objc
    func rightHandAction() {
        print("right bar button action")
        performSegue(withIdentifier: "fromPerfilToEdit", sender: self)
    }
    
    func setupImage(){
        userImage.layer.cornerRadius = userImage.frame.width / 2
                userImage.layer.borderColor = #colorLiteral(red: 0.1842333972, green: 0.7304695249, blue: 0.7287064195, alpha: 1)
                userImage.layer.borderWidth = 2.0
                userImage.clipsToBounds = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "fromPerfilToEdit" {
            let destinationVC = segue.destination as! EditarPerfilViewController
    
        }
    }
    
    func upDateUserInfo(){
        userNameLabel.text = userModel.user.name
        userImage.image = UIImage(named: userModel.user.image)
        
    }
}
