//
//  WelcomeViewController.swift
//  Vida Pet
//
//  Created by Toki on 22/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

class WelcomeViewController: VidaPetMainViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    // MARK: - Life Cicle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            self.performSegue(withIdentifier: R.segue.welcomeViewController.segueToNavigation, sender: self)
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}
