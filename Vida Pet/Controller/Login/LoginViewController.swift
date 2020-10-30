//
//  LoginViewController.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 15/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

// MARK: - VidaPetMainViewController

class LoginViewController: VidaPetMainViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookButton: UIStackView!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    let eyeButton = UIButton(type: .custom)
    
    // MARK: Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        configureTapGesture()
        configureTextFields()
        passwordTextField.enablePasswordToggle()
        
    }
    
    
    // MARK: Setup
    
    func setUpElements(){
        emailTextField.setStyleRounded(withRadius: 5)
        passwordTextField.setStyleRounded(withRadius: 5)
        loginButton.setStyleRounded(withRadius: 5)
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
    

    // MARK: IBActions
    
    @IBAction func loginPressed(_ sender: Any) {
        let error = ValidateFields.validateFieldsLogin(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
        
        if error != nil {
            showError(message: error!)
        } else {
            self.performSegue(withIdentifier: "WelcomeVC", sender: self)
        }
    }
    
   
    
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == "WelcomeVC"{
            _ = segue.destination
        }
    }
    
    
    // MARK: Alerts
    
    func showError( message: String){
        errorLabel.text = message
        errorLabel.isHidden = false
    }
}


// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //disable the strong password (autofill)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == self.passwordTextField
                && !self.passwordTextField.isSecureTextEntry) {
            self.passwordTextField.isSecureTextEntry = true
        }
        
        return true
    }
    
    
}


