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
import Alamofire

class PerfilViewController: VidaPetMainViewController {
    
    // MARK: - Properties
    
    let emptyField: String = ""
    final let barButtonTitle = "Editar"
    var userData : UserData?
    
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        requestMyUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = R.color.vidaPetBlue()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: barButtonTitle, style: .done, target: self, action: #selector(rightHandAction))
        userImage.setupImage(image: userImage)
        
    }
    
    
    // MARK: - Methods
    
    @objc
    func rightHandAction() {
        performSegue(withIdentifier: R.segue.perfilViewController.fromPerfilToEdit.identifier, sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == R.segue.perfilViewController.fromPerfilToEdit.identifier {
            let destinationVC = segue.destination as! EditarPerfilViewController
            destinationVC.name = userData?.name
            destinationVC.image = userData?.image
            destinationVC.state = userData?.state
            destinationVC.bioUser = userData?.bio
        }
    }
    
    func upDateUserInfo(){
        userNameLabel.text = userData?.name
        userImage.image = UIImage(named: userData?.image ?? "")
        bioLabel.text = userData?.bio
        regiaoLabel.text = userData?.state
        
    }
    
    
    // MARK: - Networking
    
    func requestMyUser() {
        
        self.loadingIndicator(.start)
       
            
        
        let mockUid = "/bEtKiiOCYvcEyGMIcE5jmEIAa8b2"
        
        APIHelper.request(url: .user, aditionalUrl: mockUid, method: .get)
            .responseJSON { response in
                self.loadingIndicator(.stop)
                switch response.result {
                case .success:
                    if let error = response.error {
                        
                        self.displayError(error.localizedDescription, withTryAgain: { self.requestMyUser() })
                    } else {
                        guard
                            let data = response.data,
                            let responseUsers = try? JSONDecoder().decode(UserData.self, from: data)
                        else {
                            self.displayError("", withTryAgain: { self.requestMyUser() })
                            return
                        }

                        self.userData = responseUsers
                      
                        self.upDateUserInfo()
                    }
                    
                case .failure(let error):
                  
                    self.displayError(error.localizedDescription, withTryAgain: { self.requestMyUser() })
                }
            }
        }}


