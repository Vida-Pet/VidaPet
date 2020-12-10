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
import GoogleSignIn

// MARK: - VidaPetMainViewController

class LoginViewController: VidaPetMainViewController, GIDSignInDelegate {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
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
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
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
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let auth = user.authentication else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        Auth.auth().signIn(with: credentials) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Login Successful.")
                
                self.performSegue(withIdentifier: R.segue.loginViewController.welcomeVC, sender: self)
            }
        }
    }
    
    // MARK: IBActions
    
    @IBAction func loginPressed(_ sender: Any) {
        
        
        let error = ValidateFields.validateFieldsLogin(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
        
        if error != nil {
            showError(message: error!)
        } else {
            
            if let email = emailTextField.text, let password = passwordTextField.text {
                Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                    if let e = error {
                        print(e)
                        self?.showError(message: R.string.login.invalid_email_pasword())
                    } else {
                        
                        self?.performSegue(withIdentifier: R.segue.loginViewController.welcomeVC, sender: self)
                    }
                }
            }
        }
    }
    
    
    @IBAction func googleSingIn(_ sender: UIButton) {
        
        
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    
    
    @IBAction func forgotPasswordAlert(_ sender: UIButton) {
        
        let forgotPasswordAlert = UIAlertController(title: R.string.login.forgot_password(), message: R.string.login.enter_email(), preferredStyle: .alert)
        forgotPasswordAlert.addTextField { (textField) in
            textField.placeholder = R.string.login.enter_email()
        }
        forgotPasswordAlert.addAction(UIAlertAction(title: R.string.login.cancel(), style: .cancel, handler: nil))
        forgotPasswordAlert.addAction(UIAlertAction(title: R.string.login.reset_password(), style: .default, handler: { (action) in
            let resetEmail = forgotPasswordAlert.textFields?.first?.text
            Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
                if error != nil{
                    let resetFailedAlert = UIAlertController(title: R.string.login.reset_failed(), message: R.string.login.invalid_email_format(), preferredStyle: .alert)
                    resetFailedAlert.addAction(UIAlertAction(title: R.string.login.ok(), style: .default, handler: nil))
                    self.present(resetFailedAlert, animated: true, completion: nil)
                }else {
                    let resetEmailSentAlert = UIAlertController(title: R.string.login.reset_mail_success(), message: R.string.login.check_email(), preferredStyle: .alert)
                    resetEmailSentAlert.addAction(UIAlertAction(title: R.string.login.ok(), style: .default, handler: nil))
                    self.present(resetEmailSentAlert, animated: true, completion: nil)
                }
            })
        }))
        //PRESENT ALERT
        self.present(forgotPasswordAlert, animated: true, completion: nil)
    }
    
    @IBAction func unwindToHome(_ sender: UIStoryboardSegue) {
        
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


