//
//  LoginViewController.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 15/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

class LoginViewController: VidaPetMainViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookButton: UIStackView!
    @IBOutlet weak var googleButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    

        var isRegisterValid: Bool = false
        
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            setUpElements()
            configureTapGesture()
            configureTextFields()
        }
        
        func setUpElements(){
            Utilities.styleTextField(emailTextField)
            Utilities.styleTextField(passwordTextField)
            Utilities.styleFilledButton(loginButton)
            self.errorLabel.isHidden = true
            
        }
        
        private func configureTapGesture(){
            let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
            self.view.addGestureRecognizer(tap)
        }
        
        private func configureTextFields(){
            emailTextField.delegate = self
            passwordTextField.delegate = self
        }
        
    
    
        
        @IBAction func loginPressed(_ sender: UIButton) {
            //validar os campos
            
            //criar um user
            
            //transicao para home screen
        }
    }

    extension LoginViewController: UITextFieldDelegate {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            
            textField.resignFirstResponder()
            return true
        }
        
    }
