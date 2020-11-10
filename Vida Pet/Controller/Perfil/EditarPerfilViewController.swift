//
//  EditarPerfilViewController.swift
//  Vida Pet
//
//  Created by Toki on 03/11/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

class EditarPerfilViewController: VidaPetMainViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var estadoTextField: UITextField!
    @IBOutlet weak var bio: UITextField!
    
    final let barButtonTitle = "Salvar"
    let numberOfComponents = 1
    var selectedState: String?
    var userModel =  UserModel()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()


        userImage.setupImage(image: userImage)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = R.color.vidaPetBlue()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: barButtonTitle, style: .done, target: self, action: #selector(rightHandAction))
    
        self.createAndSetupPickerView()
        self.dismissAndClosePickerView()
  
    }

    @objc
    func rightHandAction() {
        _ = navigationController?.popViewController(animated: true)
    }
            
    
    
    @IBAction func perfilPublico(_ sender: Any) {
        // MARK: - TODO: retirar log depois -
        print("pressed")
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

    func openCamera()
    {
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

    func openGallery()
    {
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
    
    func createAndSetupPickerView(){
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
        self.selectedState = userModel.stateArray[row]
        self.estadoTextField.text = self.selectedState
        
        
    }
    
}
