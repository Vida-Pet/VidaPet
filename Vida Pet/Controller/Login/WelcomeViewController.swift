//
//  WelcomeViewController.swift
//  Vida Pet
//
//  Created by Toki on 22/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit
import GoogleSignIn

class WelcomeViewController: VidaPetMainViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var userWelcomeLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!

    // MARK: - Properties
    
    var userName: String?
    
    // MARK: - Life Cicle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.userNameLabel.text = self.userName
            self.userWelcomeLabel.text = R.string.main.welcomeBack()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
            self.performSegue(withIdentifier: R.segue.welcomeViewController.segueToNavigation, sender: self)
        }
    }

}
