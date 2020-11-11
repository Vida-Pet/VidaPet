//
//  MeusPetsCadastroViewController.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 04/11/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields

class MeusPetsCadastroViewController: VidaPetMainViewController {
    
    
    // MARK: IBOutlets
    
    @IBOutlet weak var tableViewVacinas: UITableView!
    @IBOutlet weak var tableViewCirurgias: UITableView!
    @IBOutlet weak var heightConstraintCirurgias: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintVacinas: NSLayoutConstraint!
    @IBOutlet weak var txtName: VPRoundPlaceholderTextField!
    @IBOutlet weak var txtDescription: VPMultilineRoundPlaceholderTextField!
    @IBOutlet weak var txtRaca: VPRoundPlaceholderTextField!
    @IBOutlet weak var txtData: VPRoundPlaceholderTextField!
    @IBOutlet weak var stepperPeso: UIStepper!
    @IBOutlet weak var txtPeso: VPRoundPlaceholderTextField!
    @IBOutlet weak var segmentPelagem: UISegmentedControl!
    @IBOutlet weak var segmentPorte: UISegmentedControl!
    @IBOutlet weak var segmentSexo: UISegmentedControl!
    @IBOutlet weak var btnSalvar: UIButton!
    @IBOutlet weak var switchAdocao: UISwitch!
    @IBOutlet weak var imgView: UIImageView!
    
    
    // MARK: Variables
    
    final let CELL_SIZE = 55
    final let NO_CELLS = 0
    final let TAG_NEW_VACCINE_NAME = 99
    final let TAG_NEW_VACCINE_DATA = 88
    final let TAG_NEW_SURGERY_NAME = 77
    final let TAG_NEW_SURGERY_DATA = 66
    let noPetImagePlaceholder = "plus.viewfinder"
    let defaultDateDivisor: Character = "/"
    var delegate: UIViewController?
    var editMode: Bool = false
    var pet: Pet?
    var peso: Double?
    var info: Info = Info()
    var medicalData: MedicalData = MedicalData(surgerys: [], vaccines: [])
    enum MedicalDataType {
        case VACCINES
        case SURGERYS
    }
    
    
    // MARK: LifeCicle
    override func viewWillAppear(_ animated: Bool) {
        btnSalvar.layer.cornerRadius = btnSalvar.frame.height / 2
        imgView.layer.cornerRadius = imgView.frame.height / 4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtDescription.textView?.delegate = self
        tableViewCirurgias.dataSource = self
        tableViewVacinas.dataSource = self
        txtName.delegate = self
        txtRaca.delegate = self
        txtData.delegate = self
        txtPeso.delegate = self
        if editMode {
            setupEditMode()
        }
    }
    
    
    // MARK: IBActions
    
    @IBAction func newVacina(_ sender: UIButton) {
        showAlertController(named: R.string.meusPetsCadastro.nova_vacina_titulo(),
                            withMessage: R.string.meusPetsCadastro.nova_vacina_mensagem(),
                            withNamePlaceholder: R.string.meusPetsCadastro.nova_vacina_placeholder(),
                            withNameTag: TAG_NEW_VACCINE_NAME,
                            andDateTag: TAG_NEW_VACCINE_DATA,
                            andType: MedicalDataType.VACCINES)
    }
    
    @IBAction func newCirurgia(_ sender: UIButton) {
        showAlertController(named: R.string.meusPetsCadastro.nova_cirurgia_titulo(),
                            withMessage: R.string.meusPetsCadastro.nova_cirurgia_mensagem(),
                            withNamePlaceholder: R.string.meusPetsCadastro.nova_cirurgia_placeholder(),
                            withNameTag: TAG_NEW_SURGERY_NAME,
                            andDateTag: TAG_NEW_SURGERY_DATA,
                            andType: MedicalDataType.SURGERYS)
    }
    
    @IBAction func clickImage(_ sender: UIButton) {
        showImageActionSheet()
    }
    
    @IBAction func stepPeso(_ sender: UIStepper) {
        peso = sender.value
        txtPeso.text = "\(sender.value) Kg"
    }
    
    
    @IBAction func clickSalvar(_ sender: UIButton) {
        guard validateAllFields() else { return }
        info = Info(coat: segmentPelagem.titleForSegment(at: segmentPelagem.selectedSegmentIndex),
                    gender: segmentSexo.titleForSegment(at: segmentSexo.selectedSegmentIndex),
                    size: segmentPorte.titleForSegment(at: segmentPorte.selectedSegmentIndex),
                    breed: txtRaca.text,
                    birth: txtData.text,
                    weight: peso)
        pet = Pet(id: 1,
                  image: (imgView.image != nil) ? imgView.image!.encodeImageToBase64() : "",
                  name: txtName.text,
                  petDescription: txtDescription.text,
                  adoption: switchAdocao.isOn,
                  info: info, medicalData: medicalData)

        if let newPet = pet {
            if editMode {
                if let petDetalhesVC = delegate as? MeusPetsDetalheViewController {
                    if let safePet = pet, let safeIndex = petDetalhesVC.selectedPetIndex {
                        petDetalhesVC.pet = safePet
                        MeusPetsListaViewController.pets[safeIndex] = safePet
                    }
                    showSuccessPetEdited()
                }
            } else {
                MeusPetsCadastroViewController.pets.append(newPet)
                showSuccessPetAdded()
            }
        }
    }
    
    
    // MARK: Methods
    
    
    fileprivate func setupEditMode() {
        txtName.text = pet?.name
        txtDescription.text = pet?.petDescription
        imgView.image = pet?.image?.decodeBase64ToImage() ?? UIImage.init(systemName: noPetImagePlaceholder)
        txtRaca.text = pet?.info.breed
        txtData.text = pet?.info.birth
        txtPeso.text = pet?.info.weight != nil ? "\(String(pet!.info.weight!)) Kg" : ""
        peso = pet?.info.weight
        stepperPeso.value = pet?.info.weight ?? 0
        segmentPelagem.selectSegment(thatMatches: pet?.info.coat)
        segmentSexo.selectSegment(thatMatches: pet?.info.gender)
        segmentPorte.selectSegment(thatMatches: pet?.info.size)
        switchAdocao.isOn = pet?.adoption ?? false
        medicalData = pet?.medicalData ?? MedicalData(surgerys: [], vaccines: [])
        tableViewVacinas.reloadData()
        tableViewCirurgias.reloadData()
    }
    
    fileprivate func validateAllFields() -> Bool {
        // TODO: validar campos...
        return true
    }
    
    fileprivate func showSuccessPetAdded(){
        let alert: UIAlertController = UIAlertController(title: NSLocalizedString(R.string.meusPetsCadastro.success_alert_title_add(), comment: ""), message: nil, preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        let action: UIAlertAction = UIAlertAction(title: NSLocalizedString(R.string.meusPetsCadastro.success_alert_button(), comment: ""), style: .default) { action -> Void in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func showSuccessPetEdited(){
        let alert: UIAlertController = UIAlertController(title: NSLocalizedString(R.string.meusPetsCadastro.success_alert_title_edit(), comment: ""), message: nil, preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        let action: UIAlertAction = UIAlertAction(title: NSLocalizedString(R.string.meusPetsCadastro.success_alert_button(), comment: ""), style: .default) { action -> Void in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func showImageActionSheet(){
        let actionSheetController: UIAlertController = UIAlertController(title: NSLocalizedString(R.string.meusPetsCadastro.image_selector_nova_imagem(), comment: ""), message: nil, preferredStyle: .actionSheet)
        actionSheetController.view.tintColor = UIColor.black
        let cancelActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString(R.string.meusPetsCadastro.image_selector_cancelar(), comment: ""), style: .cancel)
        let saveActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString(R.string.meusPetsCadastro.image_selector_camera(), comment: ""), style: .default) { action -> Void in
            self.imageFromCamera()
        }
        let deleteActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString(R.string.meusPetsCadastro.image_selector_galeria(), comment: ""), style: .default) { action -> Void in
            self.imageFromGalery()
        }
        actionSheetController.addAction(cancelActionButton)
        actionSheetController.addAction(saveActionButton)
        actionSheetController.addAction(deleteActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    fileprivate func imageFromCamera() {
        let myPickerControllerCamera = UIImagePickerController()
        myPickerControllerCamera.delegate = self
        myPickerControllerCamera.sourceType = UIImagePickerController.SourceType.camera
        myPickerControllerCamera.allowsEditing = true
        self.present(myPickerControllerCamera, animated: true, completion: nil)
    }
    
    fileprivate func imageFromGalery() {
        let myPickerControllerGallery = UIImagePickerController()
        myPickerControllerGallery.delegate = self
        myPickerControllerGallery.sourceType = UIImagePickerController.SourceType.photoLibrary
        myPickerControllerGallery.allowsEditing = true
        self.present(myPickerControllerGallery, animated: true, completion: nil)
    }
    
    
    
    
    fileprivate func showAlertController(named title: String, withMessage message: String, withNamePlaceholder namePlaceholder: String, withNameTag nameTag: Int, andDateTag dateTag: Int, andType type: MedicalDataType) {
        var textFieldNome = UITextField()
        var textFieldData = UITextField()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: R.string.meusPetsCadastro.nova_cancelar(), style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: R.string.meusPetsCadastro.nova_adicionar(), style: .default) { (action) in
            if let text = textFieldNome.text, let data = textFieldData.text {
                switch type {
                case MedicalDataType.SURGERYS:
                    self.medicalData.surgerys.append(Surgery(nome: text, data: data))
                    self.tableViewCirurgias.reloadData()
                    return
                case MedicalDataType.VACCINES:
                    self.medicalData.vaccines.append(Vaccine(nome: text, data: data))
                    self.tableViewVacinas.reloadData()
                    return
                }
            }
        }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField { (field) in
            textFieldNome = field
            textFieldNome.placeholder = namePlaceholder
            textFieldNome.tag = nameTag
            textFieldNome.delegate = self
        }
        alert.addTextField { (field) in
            textFieldData = field
            textFieldData.placeholder = R.string.meusPetsCadastro.nova_data()
            textFieldData.tag = dateTag
            textFieldData.delegate = self
        }
        present(alert, animated: true, completion: nil)
    }
}


// MARK: - UITableViewDataSource

extension MeusPetsCadastroViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
        case tableViewVacinas:
            let count = medicalData.vaccines.count
            heightConstraintVacinas.constant = CGFloat(CELL_SIZE * (count+1))
            return count
        case tableViewCirurgias:
            let count = medicalData.surgerys.count
            heightConstraintCirurgias.constant = CGFloat(CELL_SIZE * (count+1))
            return count
        default:
            return NO_CELLS
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case tableViewVacinas:
            guard let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.cell_vacinas.identifier) else { return UITableViewCell() }
            cell.textLabel?.text = medicalData.vaccines[indexPath.row].nome
            cell.detailTextLabel?.text = medicalData.vaccines[indexPath.row].data
            return cell
            
        case tableViewCirurgias:
            guard let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.cell_cirurgias.identifier) else { return UITableViewCell() }
            cell.textLabel?.text = medicalData.surgerys[indexPath.row].nome
            cell.detailTextLabel?.text = medicalData.surgerys[indexPath.row].data
            return cell
            
        default:
            return UITableViewCell()
            
        }
    }
}


// MARK: - UITableViewDelegate

extension MeusPetsCadastroViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


// MARK: - UITableViewDelegate

extension MeusPetsCadastroViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case txtData:
            if textField.text!.isEmpty { (textField as! VPRoundPlaceholderTextField).toggleNormal() }
            return
        default:
            return
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField.tag {
        case TAG_NEW_SURGERY_DATA:
            return textField.validateDate(string: string, range: range, dateFormatter: defaultDateFormatter, dateDivisor: defaultDateDivisor)
        case TAG_NEW_VACCINE_DATA:
            return textField.validateDate(string: string, range: range, dateFormatter: defaultDateFormatter, dateDivisor: defaultDateDivisor)
        default:
            switch textField {
            case txtData:
                return txtData.validateDate(string: string, range: range, dateFormatter: defaultDateFormatter, dateDivisor: defaultDateDivisor)
            default:
                return true
            }
        }
        
        
    }
}


// MARK: - UITextViewDelegate

extension MeusPetsCadastroViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        
    }
}


// MARK: - UIImagePickerControllerDelegate

extension MeusPetsCadastroViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.originalImage] as? UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
            imgView.image = selectedImage
            dismiss(animated: true, completion: nil)
        }
}


// MARK: - UINavigationControllerDelegate

extension MeusPetsCadastroViewController: UINavigationControllerDelegate {
    
}
