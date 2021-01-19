//
//  EditarPerfilViewController.swift
//  Vida Pet
//
//  Created by Toki on 03/11/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

class EditarPerfilViewController: VidaPetMainViewController {
    
    // MARK: - Properties
    
    final let numberOfComponents = 1
    var selectedState: String?
 
    
    var bioUser: String?
    var isPublicProfile: Bool = false
    var image: String?
    var name: String?
    var state: String?
    
    
    var userModel = UserModel()
    var userData : UserData?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var estadoTextField: UITextField!
    @IBOutlet weak var bio: VPMultilineRoundPlaceholderTextField!
    
    
    // MARK: - IBActions
    
    @IBAction func perfilPublico(_ sender: UISwitch) {
        if (sender.isOn == true){
             isPublicProfile = true
          }
          else{
            isPublicProfile = false
          }
    }
    
    
    @IBAction func imagePressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: R.string.editarPerfil.image_title(), message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: R.string.editarPerfil.image_option_camera(), style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: R.string.editarPerfil.image_option_galery(), style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: R.string.editarPerfil.cancel(), style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Life Cycles
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        userImage.setupImage(image: userImage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = R.color.vidaPetBlue()
        saveButton()
        configureTapGesture()
        self.createAndSetupPickerView()
        self.dismissAndClosePickerView()
        setupFields()
    }
    
    // MARK: - Networking
    
    func pathUser(_ user: UserData) {
        
        self.loadingIndicator(.start)
       
        
        let mockUid = "/mnxX36vV7gYYWO0lO6AEzq3Ur8D2"
        APIHelper.request(url: .user, aditionalUrl: mockUid, method: .patch, parameters: getParamsToApi(from: user))
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    if let error = response.error {
                        self.displayError(error.localizedDescription, withTryAgain: { self.pathUser(user) })
                       
                    } else {
                        self.loadingIndicator(.stop)
                        self.rightHandAction()
                        
                       
                    }
                case .failure(let error):
                    self.displayError(error.localizedDescription, withTryAgain: { self.pathUser(user) })
                }
            }
    }
    
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
    
    // MARK: - Navigation
    
    func saveButton(){
        
       
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: R.string.editarPerfil.bar_button_title(), style: .done, target: self, action: #selector(rightHandAction))
    }
    
    
    @objc func rightHandAction() {
        bioUser = bio.text
        name = userNameTextField.text
        var mockUid = "/mnxX36vV7gYYWO0lO6AEzq3Ur8D2"
        if let _bio = bioUser, let _state = state, let _name = name{
            
            userData = UserData(uid: mockUid , bio: _bio, isPublicProfile: isPublicProfile ?? false, image: "", name: _name, state: _state)}
        print("userpatch")
        print(userData)
        
        if let _userData = userData {
            pathUser(_userData)
            print("userpatch")
            print(_userData)
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    
    
    // MARK: - Methods
    func updateProfile(){
        
        
        
    }
    
    
    private func configureTapGesture(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    

    
    func setupFields(){
        self.userNameTextField.text = name
        self.estadoTextField.text = state
        self.bio.text = bioUser
    }
    
    
    func openCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: R.string.editarPerfil.warning(), message: R.string.editarPerfil.camera_access(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: R.string.editarPerfil.ok(), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func openGallery() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: R.string.editarPerfil.warning(), message: R.string.editarPerfil.galery_access(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: R.string.editarPerfil.ok(), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func createAndSetupPickerView() {
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        self.estadoTextField.inputView = pickerView
    }
    
    
    func dismissAndClosePickerView() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let button = UIBarButtonItem(title: R.string.editarPerfil.picker_state(), style: .plain, target: self, action: #selector(self.dismissAction))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        self.estadoTextField.inputAccessoryView = toolBar
    }
    
    
    @objc func dismissAction(){
        self.view.endEditing(true)
    }
    
}


//MARK: - Image Picker

extension EditarPerfilViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            userImage.image = pickedImage
            print(userImage.image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}


//MARK: - Picker View

extension EditarPerfilViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return numberOfComponents
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userModel.stateArray.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return userModel.stateArray[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        estadoTextField.text = userModel.stateArray[row]
       state = estadoTextField.text
    }
}
