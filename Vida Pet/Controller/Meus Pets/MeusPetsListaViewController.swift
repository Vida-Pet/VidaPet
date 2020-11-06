//
//  MeusPetsListaViewController.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 15/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

class MeusPetsListaViewController: VidaPetMainViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Variables
    
    let segueIdentifierDetalhes = "MeusPetsListaToMeusPetsDetalhes"
    let segueIdentifierCadastro = "MeusPetsListaToMeusPetsCadastro"
    let cellIdentifier = "cell"
    let mockImages = ["pet1", "pet2", "pet3", "pet1", "pet2", "pet3", "pet1", "pet2", "pet3"]
    
    
    // MARK: LifeCicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setupNavBar()
    }

    fileprivate func setupNavBar() {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = addItem
    }
    
    @objc fileprivate func addTapped() {
        performSegue(withIdentifier: segueIdentifierCadastro, sender: self)
    }

    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case segueIdentifierDetalhes:
            if let destinationVC = segue.destination as? MeusPetsDetalheViewController, let cell = sender as? MeusPetsListaCellTableViewCell{
                destinationVC.imgPetData = cell.imgPet.image
                destinationVC.lblNomeData = cell.lblNome.text
                destinationVC.lblDescricaoData = cell.lblDescricao.text
            }
        case segueIdentifierCadastro: break
        default: break
        }
    }

}


// MARK: - UITableViewDataSource

extension MeusPetsListaViewController: UITableViewDataSource {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MeusPetsListaCellTableViewCell else {
            return UITableViewCell()
        }
        
        cell.imgPet.image = UIImage(named: mockImages[indexPath.row])
        
        return cell
    }
}


// MARK: - UITableViewDelegate

extension MeusPetsListaViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueIdentifierDetalhes, sender: tableView.cellForRow(at: indexPath))
    }
}


