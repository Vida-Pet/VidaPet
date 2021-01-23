//
//  RecemChegadosListaViewController.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 15/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

class RecemChegadosListaViewController: VidaPetMainViewController {
    
    
    // MARK: IBOutlets
    
    @IBOutlet weak var recemChegadosTableView: UITableView!
    
    
    // MARK: Properties
    
    private var pets : Array<Pet> = []
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setupLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupTableView()
    }
    
    // MARK: Methods
    
    private func setupTableView() {
        recemChegadosTableView.delegate = self
        recemChegadosTableView.dataSource = self
        recemChegadosTableView.register(UINib(nibName: R.nib.vpLargeRoundedTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.vpLargeRoundedTableViewCell.identifier)
        
        requestMeusPets()
        //        addNewPet(id: 3) {
        //            DispatchQueue.main.async {
        //                self.recemChegadosTableView.reloadData()
        //            }
        //        }
    }
    
    //    private func setupLoad() {
    //        let spinner = UIActivityIndicatorView()
    //        spinner.startAnimating()
    //        recemChegadosTableView.backgroundView = spinner
    //    }
    
    //    func addNewPet(id: Int, completion : @escaping () -> Void) {
    //        if(id < 1) {
    //            return
    //        }
    //        DispatchQueue.global().asyncAfter(deadline: DispatchTime(uptimeNanoseconds: UInt64(Int.random(in: 1000..<1500))), execute: {
    //            RandomPet.shared().generateRandomPet(id: id) { pet in
    //                self.pets.append(pet)
    //                completion()
    //            }
    //        })
    //        self.addNewPet(id: id - 1, completion: completion)
    //    }
    
    func requestMeusPets() {
        
        self.loadingIndicator(.start)
        
        APIHelper.request(url: .pet,aditionalUrl: "?informationType=NEW_PETS" ,method: .get)
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
    
    private func updateTableView() {
        DispatchQueue.main.async { self.recemChegadosTableView.reloadData() }
    }
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case R.segue.recemChegadosListaViewController.recemChegadosListaToPetsDetalhes.identifier:
            if let destinationVC = segue.destination as? RecemChegadosDetalheViewController,
               let indexPath = sender as? IndexPath{
                destinationVC.pet = self.pets[indexPath.row]
                destinationVC.selectedPetIndex = indexPath.row
            }
        default: break
        }
    }
    
    
    
}


// MARK: - UITableViewDelegate

extension RecemChegadosListaViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(pets[indexPath.row])
        performSegue(withIdentifier: R.segue.recemChegadosListaViewController.recemChegadosListaToPetsDetalhes.identifier, sender: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - UITableViewDataSource

extension RecemChegadosListaViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pets.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.vpLargeRoundedTableViewCell.identifier, for: indexPath) as? VPLargeRoundedTableViewCell else {
            return UITableViewCell()
        }
        
        let selectedPet = self.pets[indexPath.row]
        cell.petImage.layer.cornerRadius = 8.0
        cell.petImage.clipsToBounds = true
        cell.imageView?.contentMode = .scaleAspectFit
        cell.petDesc.text = "\(selectedPet.name!), \n\(selectedPet.info.breed!), \(selectedPet.info.birth?.ageFromDate(withFormatter: Date.Formatter.iso8601)?.formatAge() ?? "")"
        cell.petImage.contentMode = .scaleAspectFill
        cell.petImage.image = self.pets[indexPath.row].image?.decodeBase64ToImage() ?? R.image.avataDog()!
        
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.5)
        
        let whiteColor = UIColor.white
        gradient.colors = [
            whiteColor.withAlphaComponent(0.0).cgColor,
            whiteColor.withAlphaComponent(0.5).cgColor,
            whiteColor.withAlphaComponent(1.0).cgColor]
        gradient.locations = [
            NSNumber(value: 0.0),
            NSNumber(value: 0.3),
            NSNumber(value: 0.7)
        ]
        gradient.frame = cell.petImage.bounds
        cell.petImage.layer.mask = gradient
        
        return cell
    }
}


