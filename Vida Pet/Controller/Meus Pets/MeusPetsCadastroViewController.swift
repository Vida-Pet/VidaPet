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
    
    
    // MARK: Variables
    
    let cellVacinasReuseIdentifier = "cell_vacinas"
    let cellCirurgiasReuseIdentifier = "cell_cirurgias"
    
    
    // MARK: LifeCicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewVacinas.dataSource = self
        tableViewCirurgias.dataSource = self
    }
}


// MARK: - UITableViewDataSource

extension MeusPetsCadastroViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = 5
        heightConstraintCirurgias.constant = CGFloat(55 * (count+1))
        heightConstraintVacinas.constant = CGFloat(55 * (count+1))
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
            case tableViewVacinas:
                guard let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellVacinasReuseIdentifier) as UITableViewCell? else { return UITableViewCell() }
                cell.textLabel?.text = "Vacina nº \(indexPath.row)"
                cell.detailTextLabel?.text = "10/12/2019"
                return cell
                
            case tableViewCirurgias:
                guard let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellCirurgiasReuseIdentifier) as UITableViewCell? else { return UITableViewCell() }
                cell.textLabel?.text = "Cirurgia nº \(indexPath.row)"
                cell.detailTextLabel?.text = "10/12/2019"
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

