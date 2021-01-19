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
import Alamofire
import SCLAlertView

// MARK: - VidaPetMainViewController

class LoginViewController: VidaPetMainViewController, GIDSignInDelegate {
    
    // MARK: - Properties
    
    final let eyeButton = UIButton(type: .custom)
    final let defaultButtonCornerRadius: CGFloat = 5
    var userData : UserData?
 
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    // MARK: - IBActions
    
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
                        //TODO fazer o get do usuario
                        
//                        let user = Auth.auth().currentUser
//                        if let user = user {
//                          // The user's ID, unique to the Firebase project.
//                          // Do NOT use this value to authenticate with your backend server,
//                          // if you have one. Use getTokenWithCompletion:completion: instead.
//                          let uid = user.uid
//                          let email = user.email
//                          let photoURL = user.photoURL
//                          var multiFactorString = "MultiFactor: "
//                          for info in user.multiFactor.enrolledFactors {
//                            multiFactorString += info.displayName ?? "[DispayName]"
//                            multiFactorString += " "
//                          }
                       
                            
                    }
                }
            }
        }
    }
    
    
    
   @IBAction func mockSignIn(_ sender: Any) {
        self.performSegue(withIdentifier: R.segue.loginViewController.welcomeVC, sender: self)
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
        
        self.present(forgotPasswordAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func unwindToHome(_ sender: UIStoryboardSegue) {
        
    }
    
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        configureTapGesture()
        configureTextFields()
        passwordTextField.enablePasswordToggle()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    
    // MARK: - Setup
    
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
    
    private func showSuccessUserAdded(){
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton(R.string.login.cancel(), action: {
            self.navigationController?.popViewController(animated: true)
        })
        alertView.showSuccess(R.string.login.cancel(), subTitle: R.string.login.cancel(), colorStyle: UInt(self.colorStyle))

    }
    
    
    // MARK: - Methods
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
                    let user = Auth.auth().currentUser
                    if let _user = user {
                        let uid = _user.uid
                        let name = _user.displayName
                        self.userData = UserData(id: uid, image: "empty_user", name: name, bio: "", isPublicProfile: false, state: "")}

                    if let newUser = self.userData {
                        self.requestAddUser(newUser)
            
                }
            }
        }
    }
        
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == R.segue.loginViewController.welcomeVC.identifier {
            let destinationVC = segue.destination as! WelcomeViewController
        
        }
    }
    
    
    
    // MARK: - Networking
    
    private func getParamsToApi(from user: UserData) -> [String: Any] {
        
    let finalUser: [String: Any] = [
        
        "name" : userData?.name as Any,
        "image" : userData?.image as Any,
        "bio" : userData?.bio as Any,
        "isPublicProfile" : userData?.isPublicProfile as Any,
        "state" : userData?.state as Any,
        "uid" : userData?.id as Any ]
        
        return finalUser
        }
    
    
    func requestAddUser(_ user: UserData) {
        APIHelper.request(url: .user, method: .post, parameters: getParamsToApi(from: user))
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    if let error = response.error {
                        self.displayError(error.localizedDescription, withTryAgain: { self.requestAddUser(user) })
                        print("deu erro")
                    } else {
                        print("user adicionado")
//                        TODO arrumar as strings do alert
                        self.showSuccessUserAdded()
                        self.performSegue(withIdentifier: R.segue.loginViewController.welcomeVC, sender: self)
                    }
                case .failure(let error):
                    self.displayError(error.localizedDescription, withTryAgain: { self.requestAddUser(user) })
                }
                
            }
    }

    
    // MARK: - Alerts
    
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



