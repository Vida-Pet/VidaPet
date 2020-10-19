//
//  MeusPetsListaViewController.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 15/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

class MeusPetsListaViewController: VidaPetMainViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let segueIdentifier = "MeusPetsListaToMeusPetsDetalhes"
    let cellIdentifier = "cell"
    let mockImages = ["pet1", "pet2", "pet3", "pet1", "pet2", "pet3", "pet1", "pet2", "pet3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
    


    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case segueIdentifier:
            if let destinationVC = segue.destination as? MeusPetsDetalheViewController, let cell = sender as? MeusPetsListaCellTableViewCell{
                destinationVC.imgPetData = cell.imgPet.image
                destinationVC.lblNomeData = cell.lblNome.text
                destinationVC.lblDescricaoData = cell.lblDescricao.text
            }
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
        performSegue(withIdentifier: segueIdentifier, sender: tableView.cellForRow(at: indexPath))
    }
}


