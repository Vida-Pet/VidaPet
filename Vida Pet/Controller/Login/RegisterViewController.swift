//
//  RegisterViewController.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 15/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SCLAlertView

// MARK: - VidaPetMainViewController

class RegisterViewController: VidaPetMainViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    
    // MARK: - Properties
    
    final let loginButtonCornerRadius: CGFloat = 5
    var userDataa : UserData?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.text = ""
        configureTapGesture()
        configureTextFields()
        setUpElements()
        passwordTextField.enablePasswordToggle()
        confirmPasswordTextField.enablePasswordToggle()
        
    }
    
    
    // MARK: - Setup
    
    private func configureTapGesture(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    private func configureTextFields(){
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
    }
    
    func setUpElements(){
        loginButton.setStyleRounded(withRadius: loginButtonCornerRadius)
        self.errorLabel.isHidden = true
    }
    
    func mockSignIn(_ sender: Any) {
        self.performSegue(withIdentifier: R.segue.registerViewController.registerWelcomeVC, sender: self)
    }
    
    
    // MARK: - IBActions
    
    @IBAction func registerPressed(_ sender: Any) {
        
        self.loadingIndicator(.start)
                
                let errorMessage = ValidateFields.validateFieldsRegister(name: nameTextField.text ?? "", email: emailTextField.text ?? "", password: passwordTextField.text ?? "", confirmPassword: confirmPasswordTextField.text ?? "")
                if let _errorMessage = errorMessage {
                    
                    self.showError(message:_errorMessage )
                    self.loadingIndicator(.stop)
                } else {
                    
                    if let email = emailTextField.text, let password = passwordTextField.text {
                        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                            if let _error = error {
                                
                                print("erro ao registrar user")
                            } else {
                                print("Login Successful.")
                                let user = Auth.auth().currentUser
                                if let _user = user {
                                    let uida = _user.uid
                                    self.userDataa = UserData(uid: uida,  bio: "", isPublicProfile: false, name: self.nameTextField.text, state: nil)
                                }
                                
                                if let newUser = self.userDataa {
                                    self.requestAddUser(newUser)
                                }
                            }
                            self.loadingIndicator(.stop)
                        }
                        
                    }}
                

    }
    
    
    // MARK: - Networking
    
    private func getParamsToApi(from user: UserData) -> [String: Any] {
        
        let finalUser: [String: Any] = [  
            "name" : userDataa?.name as Any,
            "image" : userDataa?.image as Any,
            "bio" : userDataa?.bio as Any,
            "isPublicProfile" : userDataa?.isPublicProfile as Any,
            "state" : userDataa?.state as Any,
            "uid" : userDataa?.uid as Any ]
        return finalUser
    }
    
    func requestAddUser(_ user: UserData) {
        
        self.loadingIndicator(.start)
        
        APIHelper.request(url: .user, method: .post, parameters: getParamsToApi(from: user))
            .responseJSON { response in
                self.loadingIndicator(.stop)
                switch response.result {
                case .success:
                    if let error = response.error {
                        self.displayError(error.localizedDescription, withTryAgain: { self.requestAddUser(user) })
                        
                    } else {
                        guard
                            let data = response.data,
                            let responseUser = try? JSONDecoder().decode(UserData.self, from: data) else { return; }
                        GlobalSession.setUser(withId: responseUser.id, andUid: responseUser.uid)
                        self.mockSignIn(self)
                    }
                case .failure(let error):
                    self.displayError(error.localizedDescription, withTryAgain: { self.requestAddUser(user) })
                }
                
            }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == R.segue.registerViewController.registerWelcomeVC.identifier  {
            let destinationVC = segue.destination as! WelcomeViewController
            destinationVC.userName = nameTextField.text
        }
    }
    
    
    // MARK: - Alerts
    
    func showError( message: String){
        errorLabel.text = message
        errorLabel.isHidden = false
    }
}


// MARK: - UITextFieldDelegate

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case self.nameTextField:
            self.emailTextField.becomeFirstResponder()
        case self.emailTextField:
            self.passwordTextField.becomeFirstResponder()
        case self.passwordTextField:
            self.confirmPasswordTextField.becomeFirstResponder()
        default:
            self.confirmPasswordTextField.resignFirstResponder()
        }
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


