//
//  MeusPetsCadastroViewController.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 04/11/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields
import Alamofire

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
    @IBOutlet weak var scrollViewBottomSpace: NSLayoutConstraint!
    
    
    // MARK: Variables
    
    final let CELL_SIZE = 55
    final let NO_CELLS = 0
    final let TAG_NEW_VACCINE_NAME = 99
    final let TAG_NEW_VACCINE_DATA = 88
    final let TAG_NEW_SURGERY_NAME = 77
    final let TAG_NEW_SURGERY_DATA = 66
    let noPetImagePlaceholder = "plus.viewfinder"
    let defaultCameraIcon = {
        UIImage(systemName: "camera.viewfinder")
    }
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
        configureTapGesture()
        imgView.image = defaultCameraIcon()
    }
    
    
    // MARK: IBActions
    
    @IBAction func newVacina(_ sender: UIButton) {
        showAlertController(named: R.string.meusPetsCadastro.nova_vacina_titulo(),
                            withMessage: R.string.meusPetsCadastro.nova_vacina_mensagem(),
                            withNamePlaceholder: R.string.meusPetsCadastro.nova_vacina_placeholder(),
                            withNameTag: TAG_NEW_VACCINE_NAME,
                            andDateTag: TAG_NEW_VACCINE_DATA,
                            andType: .VACCINES)
    }
    
    @IBAction func newCirurgia(_ sender: UIButton) {
        showAlertController(named: R.string.meusPetsCadastro.nova_cirurgia_titulo(),
                            withMessage: R.string.meusPetsCadastro.nova_cirurgia_mensagem(),
                            withNamePlaceholder: R.string.meusPetsCadastro.nova_cirurgia_placeholder(),
                            withNameTag: TAG_NEW_SURGERY_NAME,
                            andDateTag: TAG_NEW_SURGERY_DATA,
                            andType: .SURGERYS)
    }
    
    @IBAction func clickImage(_ sender: UIButton) {
        showImageActionSheet()
    }
    
    @IBAction func stepPeso(_ sender: UIStepper) {
        peso = sender.value
        txtPeso.text = "\(sender.value) Kg"
    }
    
    
    @IBAction func clickSalvar(_ sender: UIButton) {
        guard validateAllFields() else { presentInputError(); return }
        info = Info(coat: segmentPelagem.titleForSegment(at: segmentPelagem.selectedSegmentIndex),
                    gender: segmentSexo.titleForSegment(at: segmentSexo.selectedSegmentIndex),
                    size: segmentPorte.titleForSegment(at: segmentPorte.selectedSegmentIndex),
                    breed: txtRaca.text,
                    birth: txtData.text,
                    weight: peso)
        pet = Pet(image: (imgView.image != nil && imgView.image != defaultCameraIcon()) ? imgView.image!.encodeImageToBase64() : "",
                  name: txtName.text,
                  description: txtDescription.text,
                  adoption: switchAdocao.isOn,
                  info: info, medicalData: medicalData, user: PetUser(id: 1))
        
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
                requestAddPet(newPet)
            }
        }
    }
    
    // MARK: Networking
    
    func requestAddPet(_ pet: Pet) {
       
        loadingIndicator(.start)
        
        APIHelper.request(url: .pet, method: .post, parameters: getParamsToApi(from: pet))
            .responseJSON { response in
                
                self.loadingIndicator(.stop)
                
                switch response.result {
                case .success:
                    if let error = response.error {
                        self.displayError(error.localizedDescription, withTryAgain: { self.requestAddPet(pet) })
                    } else {
                        self.showSuccessPetAdded()
                    }
                    
                case .failure(let error):
                    self.displayError(error.localizedDescription, withTryAgain: { self.requestAddPet(pet) })
                }
                
            }
    }

    private func getParamsToApi(from pet: Pet) -> [String: Any] {
        
        var surgeries: [[String: Any]] = []
        for s in pet.medicalData.surgerys {
            var surgery: [String: Any] = [:]
            surgery["data"] = s.data?.getDate(fromFormatter: defaultDateFormatter)?.iso8601
            surgery["name"] = s.nome
            surgeries.append(surgery)
        }
        
        var vaccines: [[String: Any]] = []
        for v in pet.medicalData.vaccines {
            var vaccine: [String: Any] = [:]
            vaccine["data"] = v.data?.getDate(fromFormatter: defaultDateFormatter)?.iso8601
            vaccine["name"] = v.nome
            vaccines.append(vaccine)
        }
        
        let finalPet: [String: Any] = [
            "adoption": pet.adoption as Any,
            "dataImage": pet.image as Any,
            "description": pet.description as Any,
            "image": pet.image as Any,
            "info": [
                "birth": pet.info.birth?.getDate(fromFormatter: defaultDateFormatter)?.iso8601 as Any,
                "breed": pet.info.breed as Any,
                "coat": pet.info.coat as Any,
                "gender": pet.info.gender as Any,
                "size": pet.info.size as Any,
                "weight": pet.info.weight as Any
            ],
            "medicalData": [
                "surgerys": surgeries,
                "vaccines": vaccines
            ],
            "name": "string",
            "user": [
                "id": 1,
            ]
        ]
        
        return finalPet
    }
    
    
    // MARK: Methods
    
    
    private func configureTapGesture(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    private func setupEditMode() {
        txtName.text = pet?.name
        txtDescription.text = pet?.description
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
    
    private func validateAllFields() -> Bool {
        return
            txtName.validateInput() &&
            txtRaca.validateInput() &&
            txtData.validateInput() &&
            txtPeso.validateInput() &&
            txtDescription.text != nil && txtDescription.text != ""
    }
    
    private func presentInputError() {
        let alert: UIAlertController = UIAlertController(title: R.string.meusPetsCadastro.input_alert(), message: nil, preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        let action: UIAlertAction = UIAlertAction(title: R.string.meusPetsCadastro.input_alert_button(), style: .default)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func displayError(_ error: String, withTryAgain tryAgainAction: EmptyClosure?) {
        let alert = UIAlertController(title: R.string.meusPetsCadastro.title_failure_alert(), message: error, preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        let tryAgain: UIAlertAction = UIAlertAction(title: R.string.meusPetsCadastro.try_again_failure_alert_button(), style: .default) { action -> Void in
            tryAgainAction?()
        }
        let cancel: UIAlertAction = UIAlertAction(title: R.string.meusPetsCadastro.cancel_failure_alert_button(), style: .cancel) { action -> Void in
            
        }
        alert.addAction(tryAgain)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showSuccessPetAdded(){
        let alert: UIAlertController = UIAlertController(title: R.string.meusPetsCadastro.success_alert_title_add(), message: nil, preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        let action: UIAlertAction = UIAlertAction(title: R.string.meusPetsCadastro.success_alert_button(), style: .default) { action -> Void in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showSuccessPetEdited(){
        let alert: UIAlertController = UIAlertController(title: R.string.meusPetsCadastro.success_alert_title_edit(), message: nil, preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        let action: UIAlertAction = UIAlertAction(title: R.string.meusPetsCadastro.success_alert_button(), style: .default) { action -> Void in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showImageActionSheet(){
        let actionSheetController: UIAlertController = UIAlertController(title: R.string.meusPetsCadastro.image_selector_nova_imagem(), message: nil, preferredStyle: .actionSheet)
        actionSheetController.view.tintColor = UIColor.black
        let cancelActionButton: UIAlertAction = UIAlertAction(title: R.string.meusPetsCadastro.image_selector_cancelar(), style: .cancel)
        let saveActionButton: UIAlertAction = UIAlertAction(title: R.string.meusPetsCadastro.image_selector_camera(), style: .default) { action -> Void in
            self.imageFromCamera()
        }
        let deleteActionButton: UIAlertAction = UIAlertAction(title: R.string.meusPetsCadastro.image_selector_galeria(), style: .default) { action -> Void in
            self.imageFromGalery()
        }
        actionSheetController.addAction(cancelActionButton)
        actionSheetController.addAction(saveActionButton)
        actionSheetController.addAction(deleteActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    private func imageFromCamera() {
        let myPickerControllerCamera = UIImagePickerController()
        myPickerControllerCamera.delegate = self
        myPickerControllerCamera.sourceType = UIImagePickerController.SourceType.camera
        myPickerControllerCamera.allowsEditing = true
        self.present(myPickerControllerCamera, animated: true, completion: nil)
    }
    
    private func imageFromGalery() {
        let myPickerControllerGallery = UIImagePickerController()
        myPickerControllerGallery.delegate = self
        myPickerControllerGallery.sourceType = UIImagePickerController.SourceType.photoLibrary
        myPickerControllerGallery.allowsEditing = true
        self.present(myPickerControllerGallery, animated: true, completion: nil)
    }
    
    private func showAlertController(named title: String, withMessage message: String, withNamePlaceholder namePlaceholder: String, withNameTag nameTag: Int, andDateTag dateTag: Int, andType type: MedicalDataType) {
        var textFieldNome = UITextField()
        var textFieldData = UITextField()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: R.string.meusPetsCadastro.nova_cancelar(), style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: R.string.meusPetsCadastro.nova_adicionar(), style: .default) { (action) in
            if let text = textFieldNome.text, let data = textFieldData.text {
                switch type {
                case .SURGERYS:
                    self.medicalData.surgerys.append(Surgery(nome: text, data: data, petId: self.pet?.id))
                    self.tableViewCirurgias.reloadData()
                    return
                case .VACCINES:
                    self.medicalData.vaccines.append(Vaccine(nome: text, data: data, petId: self.pet?.id))
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
        tableView.deselectRow(at: indexPath, animated: true)
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
