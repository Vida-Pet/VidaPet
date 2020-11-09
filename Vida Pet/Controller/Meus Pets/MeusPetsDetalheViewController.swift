//
//  MeusPetsDetalheViewController.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 15/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

class MeusPetsDetalheViewController: VidaPetMainViewController {
    
    
    // MARK: Properties
    
    let segueIdentifierCadastro = "MeusPetsDetalhesToMeusPetsCadastro"
    let cellVacinas = "cell_vacinas_detalhes"
    let cellCirurgias = "cell_cirurgias_detalhes"
    let emptyField: String = ""
    let emptyLinedField: String = " - "
    let defaultRowHeight: Int = 25
    let defaultTableViewMargin: CGFloat = 15
    var selectedPetIndex: Int?
    var pet: Pet!
    
    // MARK: IBOutlets
    
    @IBOutlet weak var imgPet: UIImageView!
    @IBOutlet weak var lblNome: UILabel!
    @IBOutlet weak var lblMiniBio: UILabel!
    @IBOutlet weak var lblDescricao: UILabel!
    @IBOutlet weak var lblRaca: UILabel!
    @IBOutlet weak var lblPorte: UILabel!
    @IBOutlet weak var lblIdade: UILabel!
    @IBOutlet weak var lblPeso: UILabel!
    @IBOutlet weak var lblPelagem: UILabel!
    @IBOutlet weak var lblSexo: UILabel!
    @IBOutlet weak var tableViewVacinas: UITableView!
    @IBOutlet weak var tableViewCirurgias: UITableView!
    @IBOutlet weak var heightVacinas: NSLayoutConstraint!
    @IBOutlet weak var heightCirurgias: NSLayoutConstraint!
    
    
    // MARK: IBActions
    
    @IBAction func clickEdit(_ sender: UIButton) {
        performSegue(withIdentifier: segueIdentifierCadastro, sender: self)
    }
    
    
    // MARK: Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewVacinas.dataSource = self
        tableViewCirurgias.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupFields()
    }
    
    
    // MARK: Methods
    
    fileprivate func setupFields() {
        imgPet.image = pet.image?.decodeBase64ToImage()
        lblNome.text = pet.name
        if var age = pet.info.birth?.ageFromDate(withFormatter: defaultDateFormatter), let breed = pet.info.breed {
            if age > 1 {
                let formattedAge = "\(Int(floor(age))) anos"
                lblMiniBio.text = "\(breed), \(formattedAge)"
                lblIdade.text = formattedAge
            } else {
                age *= 12
                let formattedAge = "\(Int(floor(age))) meses"
                lblMiniBio.text = "\(breed), \(formattedAge)"
                lblIdade.text = formattedAge
            }
        } else {
            lblMiniBio.text = emptyField
            lblIdade.text = emptyLinedField
        }
        lblDescricao.text = pet.petDescription
        lblRaca.text = pet.info.breed
        lblPorte.text = pet.info.size
        if let weight = pet.info.weight {
            lblPeso.text = "\(weight) Kg"
        } else {
            lblPeso.text = emptyLinedField
        }
        lblPelagem.text = pet.info.coat
        lblSexo.text = pet.info.gender
        heightVacinas.constant = CGFloat((pet.medicalData.vaccines.count) * defaultRowHeight) + defaultTableViewMargin
        heightCirurgias.constant = CGFloat((pet.medicalData.surgerys.count) * defaultRowHeight) + defaultTableViewMargin
        tableViewVacinas.reloadData()
        tableViewCirurgias.reloadData()
    }
    
    
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case segueIdentifierCadastro:
            if let cadastroVC = segue.destination as? MeusPetsCadastroViewController {
                cadastroVC.editMode = true
                cadastroVC.delegate = self
                cadastroVC.pet = pet
            }
            break
        default:
            break
        }
    }
    
}

extension MeusPetsDetalheViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case tableViewVacinas:
            return pet.medicalData.vaccines.count
    
        case tableViewCirurgias:
            return pet.medicalData.surgerys.count
            
        default:
            return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case tableViewVacinas:
            guard let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellVacinas) as UITableViewCell? else { return UITableViewCell() }
            cell.textLabel?.text = pet.medicalData.vaccines[indexPath.row].nome
            cell.detailTextLabel?.text = pet.medicalData.vaccines[indexPath.row].data
            cell.textLabel?.textColor = R.color.vidaPetBlue()
            cell.detailTextLabel?.textColor = R.color.vidaPetBlue()
            cell.textLabel?.font = cell.textLabel?.font.withSize(14)
            cell.detailTextLabel?.font = cell.detailTextLabel?.font.withSize(14)
            return cell
            
        case tableViewCirurgias:
            guard let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellCirurgias) as UITableViewCell? else { return UITableViewCell() }
            cell.textLabel?.text = pet.medicalData.surgerys[indexPath.row].nome
            cell.detailTextLabel?.text = pet.medicalData.surgerys[indexPath.row].data
            cell.textLabel?.textColor = R.color.vidaPetBlue()
            cell.detailTextLabel?.textColor = R.color.vidaPetBlue()
            cell.textLabel?.font = cell.textLabel?.font.withSize(14)
            cell.detailTextLabel?.font = cell.detailTextLabel?.font.withSize(14)
            return cell
            
        default:
            return UITableViewCell()
            
        }
        
        
    }
}
