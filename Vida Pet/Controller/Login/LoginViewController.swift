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
import LocalAuthentication

// MARK: - VidaPetMainViewController

class LoginViewController: VidaPetMainViewController, GIDSignInDelegate {
    
    // MARK: - Properties
    
    final let eyeButton = UIButton(type: .custom)
    final let defaultButtonCornerRadius: CGFloat = 5
    var userData : UserData?
    var getUID : String?
    let context = LAContext()
    var error: NSError?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if GlobalSession.getEmail() != nil && GlobalSession.getPwd() != nil{
            faceId()
        }
    }
    
    // MARK: - IBAction LOGIN
    
    @IBAction func loginPressed(_ sender: Any) {
        login()
    }
    
    func login(){
        self.loadingIndicator(.start)
        let error = ValidateFields.validateFieldsLogin(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
        
        if error != nil {
            self.loadingIndicator(.stop)
            showError(message: error!)
        } else {
            
            if let email = emailTextField.text, let password = passwordTextField.text {
                Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                    if let e = error {
                        self?.loadingIndicator(.stop)
                        print(e)
                        self?.showError(message: R.string.login.invalid_email_pasword())
                    } else {
                        print("Login Successful.")
                        GlobalSession.setEmail(email: email)
                        GlobalSession.setPwd(pwd: password)
                        let user = Auth.auth().currentUser
                        if let _user = user {
                            self?.getUID = _user.uid
                        }
                        self?.getUser()
                    }
                }
            }
        }
    }
    
    func faceId(){
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Identify yourself!"

                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                    [weak self] success, authenticationError in

                    DispatchQueue.main.async {
                        if success {
                            self?.emailTextField.text = GlobalSession.getEmail()!
                            self?.passwordTextField.text = GlobalSession.getPwd()!
                            self?.login()
                        } else {
                            print("ELSE ALERT FALHOU")
//                            let ac = UIAlertController(title: "Autenticação Falhou" , message: "Você não esta verificado! Tente novamente.", preferredStyle: .alert)
//                            ac.addAction(UIAlertAction(title: "OK", style: .default))
//                            self?.present(ac , animated: true)
                        }
                    }
                }
                } else {
                    print("ELSE VALIDACAO DESATIVADA")
                let ac = UIAlertController(title: "Dispositivo com validação desativada" , message: "Você não esta verificado! Tente novamente.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac , animated: true)
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
    
    // MARK: - Google SignIN
    
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
                    let uida = _user.uid
                    let name = _user.displayName
                    self.userData = UserData(uid: uida,  bio: "", isPublicProfile: false, name: name, state: nil)
                }
                if let newUser = self.userData {
                    self.postUser(newUser)
                }}
        }}
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        self.cleanAllInfo()
        if segue.identifier == R.segue.loginViewController.welcomeVC.identifier {
            let destinationVC = segue.destination as! WelcomeViewController
            destinationVC.userName = userData?.name
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
            "uid" : userData?.uid as Any ]
        
        return finalUser
    }
    
    
    func postUser(_ user: UserData) {
           self.loadingIndicator(.start)
           APIHelper.request(url: .user, method: .post, parameters: getParamsToApi(from: user))
               .responseJSON { response in
                   
                   switch response.result {
                   case .success:
                       if let error = response.error {
                           self.displayError(error.localizedDescription, withTryAgain: { self.postUser(user) })
                           
                       } else {
                           guard
                               let data = response.data,
                               let responseUser = try? JSONDecoder().decode(UserData.self, from: data) else { return; }
                           GlobalSession.setUser(withId: responseUser.id, andUid: responseUser.uid)
                           self.loadingIndicator(.stop)
                           self.performSegue(withIdentifier: R.segue.loginViewController.welcomeVC, sender: self)
                       }
                   case .failure(let error):
                       self.displayError(error.localizedDescription, withTryAgain: { self.postUser(user) })
                   }
               }
       }

    
    func cleanAllInfo() {
        DispatchQueue.main.async {
            self.emailTextField.text = nil
            self.passwordTextField.text = nil
        }
    }
    
    func getUser() {
        self.loadingIndicator(.start)
        if let _getUID = getUID {
            let mockUid = "/\(_getUID)"
            
            APIHelper.request(url: .user, aditionalUrl: mockUid, method: .get)
                .responseJSON { response in
                    self.loadingIndicator(.stop)
                    switch response.result {
                    case .success:
                        if let error = response.error {
                            print("deu erro no 1")
                            self.displayError(error.localizedDescription, withTryAgain: { self.getUser() })
                        } else {
                            guard
                                let data = response.data,
                                let responseUser = try? JSONDecoder().decode(UserData.self, from: data)
                            else {
                                self.displayError("", withTryAgain: { self.getUser() })
                                return
                            }
                            
                            self.userData = responseUser
                            GlobalSession.setUser(withId: responseUser.id, andUid: responseUser.uid)
                            self.performSegue(withIdentifier: R.segue.loginViewController.welcomeVC, sender: self)
                            
                        }
                        
                    case .failure(let error):
                        print("deu erro no get")
                        self.displayError(error.localizedDescription, withTryAgain: { self.getUser() })
                    }
                }
        }}
    
    
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



