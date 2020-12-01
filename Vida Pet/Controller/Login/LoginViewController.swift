//
//  LoginViewController.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 15/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

// MARK: - VidaPetMainViewController

class LoginViewController: VidaPetMainViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookButton: UIStackView!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    // MARK: Properties
    
    final let eyeButton = UIButton(type: .custom)
    final let defaultButtonCornerRadius: CGFloat = 5
    
    
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
        emailTextField.setStyleRounded(withRadius: defaultButtonCornerRadius)
        passwordTextField.setStyleRounded(withRadius: defaultButtonCornerRadius)
        loginButton.setStyleRounded(withRadius: defaultButtonCornerRadius)
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
            
            if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
               
            
                
                if let _error = error {
                    self.showError(message: "Error creating user")
                    print("erro do firebase \(_error) ")
                } else {
                    //user was created successfully
                    self.performSegue(withIdentifier: R.segue.loginViewController.welcomeVC, sender: self)
                    
                }
            }
            }
            
            
        }
    }
    
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == R.segue.loginViewController.welcomeVC.identifier {
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


