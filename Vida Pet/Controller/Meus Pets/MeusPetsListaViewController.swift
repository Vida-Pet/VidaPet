//
//  MeusPetsListaViewController.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 15/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit
import Alamofire


class MeusPetsListaViewController: VidaPetMainViewController {
    
    
    // MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyPetsStack: UIStackView!
    @IBOutlet weak var addPetsButton: UIButton!
    
    
    // MARK: Variables
    
    var pets: Pets = []
    final let defaultButtonCornerRadius: CGFloat = 5
    
    
    // MARK: LifeCicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestMeusPets()
        emptyPetsStack.isHidden = true
        addPetsButton.setStyleRounded(withRadius: defaultButtonCornerRadius)
    }
    
    
    // MARK: Setup
    
    fileprivate func setupNavBar() {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = addItem
    }
    
    
    // MARK: Actions
    
    @IBAction func addPet(_ sender: UIButton) {
        addTapped()
    }
    
    @objc fileprivate func addTapped() {
        performSegue(withIdentifier: R.segue.meusPetsListaViewController.meusPetsListaToMeusPetsCadastro, sender: self)
    }
    
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case R.segue.meusPetsListaViewController.meusPetsListaToMeusPetsDetalhes.identifier:
            if let destinationVC = segue.destination as? MeusPetsDetalheViewController, let indexPath = sender as? IndexPath{
                destinationVC.pet = pets[indexPath.row]
                destinationVC.selectedPetIndex = indexPath.row
            }
        case R.segue.meusPetsListaViewController.meusPetsListaToMeusPetsCadastro.identifier: break
        default: break
        }
    }
    
    
    // MARK: Networking
    
    func requestMeusPets() {
        
        self.loadingIndicator(.start)
        let userId: Int = GlobalSession.getUserId() ?? 1
        APIHelper.request(url: .pet, aditionalUrl: "?informationType=MY_PETS&userId=\(userId)", method: .get)
            .responseJSON { response in
                self.loadingIndicator(.stop)
                switch response.result {
                case .success:
                    if let error = response.error {
                        self.displayError(error.localizedDescription, withTryAgain: { self.requestMeusPets() })
                    } else {
                        guard
                            let data = response.data,
                            let responsePets = try? JSONDecoder().decode(Pets.self, from: data)
                        else {
                            self.displayError("", withTryAgain: { self.requestMeusPets() })
                            return
                        }
                        self.pets = responsePets
                        self.updateTableView()
                    }
                case .failure(let error):
                    self.displayError(error.localizedDescription, withTryAgain: { self.requestMeusPets() })
                }
            }
    }
    
    
    // MARK: Private Functions
    
    private func updateTableView() {
        DispatchQueue.main.async {
            if self.pets.count > 0 {
                self.emptyPetsStack.isHidden = true
            } else {
                self.emptyPetsStack.isHidden = false
            }
            self.tableView.reloadData()
        }
    }
    
}


// MARK: - UITableViewDataSource

extension MeusPetsListaViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.cell, for: indexPath) else {
            return UITableViewCell()
        }
        if let age = pets[indexPath.row].info.birth?.ageFromDate(withFormatter: Date.Formatter.iso8601)
           , let breed = pets[indexPath.row].info.breed {
            cell.lblDescricao.text = "\(breed), \(age.formatAge())"
        }
        cell.lblNome.text = pets[indexPath.row].name
        cell.imgPet.image = pets[indexPath.row].image?.decodeBase64ToImage() ?? R.image.avataDog()!
        
        return cell
    }
}


// MARK: - UITableViewDelegate

extension MeusPetsListaViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: R.segue.meusPetsListaViewController.meusPetsListaToMeusPetsDetalhes, sender: indexPath)
    }
}


