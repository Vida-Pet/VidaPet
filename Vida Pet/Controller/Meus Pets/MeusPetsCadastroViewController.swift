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
import SCLAlertView

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
    var addButton: SCLButton?
    
    
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
        pet = Pet(id: pet?.id, image: (imgView.image != nil && imgView.image != defaultCameraIcon()) ? imgView.image!.encodeImageToBase64() : "",
                  name: txtName.text,
                  description: txtDescription.text,
                  adoption: switchAdocao.isOn,
                  info: info, medicalData: medicalData, user: pet?.user ?? PetUser(id: 1))
        
        if let newPet = pet {
            if editMode {
//                if let petDetalhesVC = delegate as? MeusPetsDetalheViewController {
//                    if let safePet = pet, let safeIndex = petDetalhesVC.selectedPetIndex {
//                        petDetalhesVC.pet = safePet
//                        MeusPetsListaViewController.pets[safeIndex] = safePet
//                    }
//                    showSuccessPetEdited()
//                }
                requestEditPet(newPet)
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
    
    func requestEditPet(_ pet: Pet) {
        
        loadingIndicator(.start)
        
        guard let id = pet.id else { self.displayError("", withTryAgain: { self.requestEditPet(pet) }); return }
        
        APIHelper.request(url: .pet, aditionalUrl: "/\(id)", method: .patch, parameters: getParamsToApi(from: pet))
            .responseJSON { response in
                
                self.loadingIndicator(.stop)
                
                switch response.result {
                case .success:
                    if let error = response.error {
                        self.displayError(error.localizedDescription, withTryAgain: { self.requestEditPet(pet) })
                    } else {
                        guard
                            let data = response.data,
                            let responsePet = try? JSONDecoder().decode(Pet.self, from: data)
                        else {
                            self.displayError("", withTryAgain: { self.requestEditPet(pet) })
                            return
                        }
                        
                        if let petDetalhesVC = self.delegate as? MeusPetsDetalheViewController {
                            petDetalhesVC.pet = responsePet
                        }
                        
                        self.showSuccessPetEdited()
                    }
                    
                case .failure(let error):
                    self.displayError(error.localizedDescription, withTryAgain: { self.requestEditPet(pet) })
                }
                
            }
    }
    
    private func getParamsToApi(from pet: Pet) -> [String: Any] {
        
        var surgeries: [[String: Any]] = []
        var vaccines: [[String: Any]] = []
        if let medicalData = pet.medicalData {
            for s in medicalData.surgerys {
                var surgery: [String: Any] = [:]
                surgery["data"] = s.data?.getDate(fromFormatter: Date.Formatter.defaultDate)?.iso8601
                surgery["name"] = s.nome
                surgeries.append(surgery)
            }
            
            for v in medicalData.vaccines {
                var vaccine: [String: Any] = [:]
                vaccine["data"] = v.data?.getDate(fromFormatter: Date.Formatter.defaultDate)?.iso8601
                vaccine["name"] = v.nome
                vaccines.append(vaccine)
            }
        }
        
        let finalPet: [String: Any] = [
            "adoption": pet.adoption as Any,
            "dataImage": pet.image as Any,
            "description": pet.description as Any,
            "image": pet.image as Any,
            "id": pet.id as Any,
            "info": [
                "birth": pet.info.birth?.getDate(fromFormatter: Date.Formatter.defaultDate)?.iso8601 as Any,
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
            "name": pet.name as Any,
            "user": [
                "id": VidaPetMainViewController.globalUserId,
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
        txtData.text = pet?.info.birth?.getDate(fromFormatter: Date.Formatter.iso8601)?.defaultDate
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
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton( R.string.meusPetsCadastro.input_alert_button(), action: {})
        alertView.showError(R.string.meusPetsCadastro.input_alert(), subTitle: "")
    }
    
    private func showSuccessPetAdded(){
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton(R.string.meusPetsCadastro.success_alert_button(), action: {
            self.navigationController?.popViewController(animated: true)
        })
        alertView.showSuccess(R.string.meusPetsCadastro.success_alert_title_add(), subTitle: R.string.meusPetsCadastro.success_alert_subtitle_add(), colorStyle: UInt(self.colorStyle))

    }
    
    private func showSuccessPetEdited(){
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton(R.string.meusPetsCadastro.success_alert_button(), action: {
            self.navigationController?.popViewController(animated: true)
        })
        alertView.showSuccess(R.string.meusPetsCadastro.success_alert_title_edit(), subTitle: R.string.meusPetsCadastro.success_alert_subtitle_edit(), colorStyle: UInt(self.colorStyle))
    }
    
    private func showImageActionSheet(){
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton(R.string.meusPetsCadastro.image_selector_camera(), action: {
            self.imageFromCamera()
        })
        alertView.addButton(R.string.meusPetsCadastro.image_selector_galeria(), action: {
            self.imageFromGalery()
        })
        alertView.addButton(R.string.meusPetsCadastro.image_selector_cancelar(), action: {})
        alertView.showInfo(R.string.meusPetsCadastro.image_selector_nova_imagem(), subTitle: "", colorStyle: UInt(self.colorStyle))
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
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        let textFieldNome = alertView.addTextField(namePlaceholder)
        let textFieldData = alertView.addTextField(R.string.meusPetsCadastro.nova_data())
        textFieldNome.delegate = self
        textFieldNome.tag = nameTag
        textFieldData.delegate = self
        textFieldData.tag = dateTag
        self.addButton = alertView.addButton(R.string.meusPetsCadastro.nova_adicionar(), action: {
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
        })
        addButton?.isEnabled = false
        alertView.addButton(R.string.meusPetsCadastro.nova_cancelar(), action: {})
        alertView.showEdit(title, subTitle: message, colorStyle: UInt(self.colorStyle))
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
            return textField.validateDate(string: string, range: range, dateFormatter: Date.Formatter.defaultDate, dateDivisor: defaultDateDivisor, errorAction: { self.addButton?.isEnabled = false }, normalAction: { self.addButton?.isEnabled = true} )
        case TAG_NEW_VACCINE_DATA:
            return textField.validateDate(string: string, range: range, dateFormatter: Date.Formatter.defaultDate, dateDivisor: defaultDateDivisor, errorAction: { self.addButton?.isEnabled = false }, normalAction: { self.addButton?.isEnabled = true} )
        default:
            switch textField {
            case txtData:
                return txtData.validateDate(string: string, range: range, dateFormatter: Date.Formatter.defaultDate, dateDivisor: defaultDateDivisor)
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
