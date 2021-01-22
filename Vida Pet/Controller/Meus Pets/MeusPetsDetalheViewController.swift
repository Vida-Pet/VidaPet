//
//  MeusPetsDetalheViewController.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 15/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit
import Alamofire

class MeusPetsDetalheViewController: VidaPetMainViewController {
    
    
    // MARK: Properties
    
    let emptyField: String = ""
    let emptyLinedField: String = " - "
    let defaultRowHeight: Int = 25
    let defaultTableViewMargin: CGFloat = 15
    let defaultFontSize: CGFloat = 14
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
    @IBOutlet weak var lblTitleCirurgias: UILabel!
    @IBOutlet weak var lblTitleVacinas: UILabel!
    @IBOutlet weak var lblDadosMedicos: UILabel!
    
    
    // MARK: IBActions
    
    @IBAction func clickEdit(_ sender: UIButton) {
        performSegue(withIdentifier: R.segue.meusPetsDetalheViewController.meusPetsDetalhesToMeusPetsCadastro, sender: self)
    }
    
    
    
    // MARK: Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewVacinas.dataSource = self
        tableViewCirurgias.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupFields()
        setupTableViews()
    }
    
    
    // MARK: Methods
    
    fileprivate func setupFields() {
        imgPet.image = pet.image?.decodeBase64ToImage() ?? R.image.avataDog()!
        pet.image = imgPet.image?.encodeImageToBase64()
        lblNome.text = pet.name
        if let age = pet.info.birth?.ageFromDate(withFormatter: Date.Formatter.iso8601)
           , let breed = pet.info.breed {
            lblMiniBio.text = "\(breed), \(age.formatAge())"
            lblIdade.text = age.formatAge()
        } else {
            lblMiniBio.text = emptyField
            lblIdade.text = emptyLinedField
        }
        lblDescricao.text = pet.description
        lblRaca.text = pet.info.breed
        lblPorte.text = pet.info.size
        if let weight = pet.info.weight {
            lblPeso.text = "\(weight) Kg"
        } else {
            lblPeso.text = emptyLinedField
        }
        lblPelagem.text = pet.info.coat
        lblSexo.text = pet.info.gender
        heightVacinas.constant = CGFloat((pet.medicalData?.vaccines.count ?? 0) * defaultRowHeight) + defaultTableViewMargin
        heightCirurgias.constant = CGFloat((pet.medicalData?.surgerys.count ?? 0) * defaultRowHeight) + defaultTableViewMargin
        
    }
    
    fileprivate func setupTableViews() {
        if let medicalData = pet.medicalData {
            if medicalData.vaccines.count > 0 {
                showVaccines(true)
            } else {
                showVaccines(false)
            }
            if medicalData.surgerys.count > 0 {
                showSurgerys(true)
            } else {
                showSurgerys(false)
            }
        } else {
            showVaccines(false)
            showSurgerys(false)
        }
        
        lblDadosMedicos.isHidden = tableViewCirurgias.isHidden && tableViewVacinas.isHidden
    }
    
    private func showVaccines(_ show: Bool) {
        if show {
            tableViewCirurgias.isHidden = false
            lblTitleCirurgias.isHidden = false
            tableViewCirurgias.reloadData()
        } else {
            tableViewCirurgias.isHidden = true
            lblTitleCirurgias.isHidden = true
        }
    }
    
    private func showSurgerys(_ show: Bool) {
        if show {
            tableViewVacinas.isHidden = false
            lblTitleVacinas.isHidden = false
            tableViewVacinas.reloadData()
        } else {
            tableViewVacinas.isHidden = true
            lblTitleVacinas.isHidden = true
        }
    }
    
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case R.segue.meusPetsDetalheViewController.meusPetsDetalhesToMeusPetsCadastro.identifier:
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
            return pet.medicalData?.vaccines.count ?? 0
            
        case tableViewCirurgias:
            return pet.medicalData?.surgerys.count ?? 0
            
        default:
            return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case tableViewVacinas:
            guard let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.cell_vacinas_detalhes.identifier) else { return UITableViewCell() }
            cell.textLabel?.text = pet.medicalData?.vaccines[indexPath.row].name
            cell.detailTextLabel?.text =  Date.Formatter.defaultDate.string(from: pet.medicalData?.vaccines[indexPath.row].data?.getDate(fromFormatter: Date.Formatter.iso8601) ?? Date())
            cell.textLabel?.textColor = R.color.vidaPetBlue()
            cell.detailTextLabel?.textColor = R.color.vidaPetBlue()
            cell.textLabel?.font = cell.textLabel?.font.withSize(defaultFontSize)
            cell.detailTextLabel?.font = cell.detailTextLabel?.font.withSize(defaultFontSize)
            return cell
            
        case tableViewCirurgias:
            guard let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.cell_cirurgias_detalhes.identifier) else { return UITableViewCell() }
            cell.textLabel?.text = pet.medicalData?.surgerys[indexPath.row].name
            cell.detailTextLabel?.text =  Date.Formatter.defaultDate.string(from: pet.medicalData?.surgerys[indexPath.row].data?.getDate(fromFormatter: Date.Formatter.iso8601) ?? Date())
            cell.textLabel?.textColor = R.color.vidaPetBlue()
            cell.detailTextLabel?.textColor = R.color.vidaPetBlue()
            cell.textLabel?.font = cell.textLabel?.font.withSize(defaultFontSize)
            cell.detailTextLabel?.font = cell.detailTextLabel?.font.withSize(defaultFontSize)
            return cell
            
        default:
            return UITableViewCell()
            
        }
        
        
    }
}
