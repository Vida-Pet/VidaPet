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
    
    
    var selectedState: String?
    var listOfStates = ["a", "b"]
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()


        userImage.layer.cornerRadius = userImage.frame.width / 2
        userImage.layer.borderColor = R.color.vidaPetBlue()?.cgColor
        // MARK: - TODO: guardar este valor como um let lá em cima -
        userImage.layer.borderWidth = 2.0
        userImage.clipsToBounds = true

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = R.color.vidaPetBlue()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done,target: self,
                                                                 action: #selector(rightHandAction))
    
        self.createAndSetupPickerView()
        self.dismissAndClosePickerView()
    }

    @objc
    func rightHandAction() {
        // MARK: - TODO: retirar log depois -
        print("right bar button action")
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
        // MARK: - TODO: seguir os passos e adicionar nos strings -
        alert.addAction(UIAlertAction.init(title: "Cancelar", style: .cancel, handler: nil))

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
            // MARK: - TODO: seguir os passos e adicionar nos strings -
            let alert  = UIAlertController(title: "Aviso", message: "Você não tem câmera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
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
            // MARK: - TODO: seguir os passos e adicionar nos strings -
            let alert  = UIAlertController(title: "Aviso", message: "Você não tem acesso a galeria", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
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
        
        // MARK: - TODO: seguir os passos e adicionar nos strings -
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissAction))
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
    // MARK: - TODO: ou usar ou apagar código comentado sempre -
    //    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    //        picker.dismiss(animated: true, completion: nil)
    //    }
}


//MARK: - Picker View
\
extension EditarPerfilViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // MARK: - TODO: guardar como um let lá em cima -
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.listOfStates.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.listOfStates[row]
    }
   
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedState = self.listOfStates[row]
        self.estadoTextField.text = self.selectedState
    }
    
}
