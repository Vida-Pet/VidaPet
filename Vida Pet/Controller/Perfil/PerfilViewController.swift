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
            _ = segue.destination as! EditarPerfilViewController
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
        
        APIHelper.request(url: .user, method: .get, headers: getHeadersToApi())
            .responseJSON { response in
                self.loadingIndicator(.stop)
                switch response.result {
                case .success:
                    if let error = response.error {
                        print("deu erro no 1")
                        self.displayError(error.localizedDescription, withTryAgain: { self.requestMyUser() })
                    } else {
                        guard
                            let data = response.data,
                            let responseUser = try? JSONDecoder().decode(UserData.self, from: data)
                        else {
                            self.displayError("", withTryAgain: { self.requestMyUser() })
                            return
                        }
                        
                        self.userData = responseUser
                        print("responseUser\(responseUser)")
                        print("user responseUser\(self.userData)")
                        self.upDateUserInfo()
                    }
                    
                case .failure(let error):
                    print("deu erro no get")
                    self.displayError(error.localizedDescription, withTryAgain: { self.requestMyUser() })
                }
            }
    }
    
    // MARK: Private Functions
    
    private func getHeadersToApi() -> HTTPHeaders {
        
        return
            HTTPHeaders(
                arrayLiteral: HTTPHeader.init(name: "uid", value: "9L1cEYZ3hJYAbG4sKlFle4sqhL32"))
                
            
    }

    
}
