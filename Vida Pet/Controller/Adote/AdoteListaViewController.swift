//
//  AdoteListaViewController.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 15/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

class AdoteListaViewController: VidaPetMainViewController {
    
    
    // MARK: Properties
    
    var pets: Pets = []
    
    // MARK: IBActions
    
    @IBOutlet weak var cvPets: UICollectionView!
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.transition(with: cvPets,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { self.cvPets.reloadData() })
        requestMeusPets()
    }
    
    
    // MARK: Methods
    
    private func setupCollectionView() {
        let nibCell  = UINib(nibName: R.nib.vpCardCollectionViewCell.name, bundle: nil)
        cvPets.register(nibCell, forCellWithReuseIdentifier: R.nib.vpCardCollectionViewCell.identifier)
        cvPets.dataSource = self
    }
    
    func requestMeusPets() {
        
        self.loadingIndicator(.start)
        
        APIHelper.request(url: .pet,aditionalUrl: "?adoption=true" ,method: .get)
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
                        print(self.pets)
                        self.updateTableView()
                    }
                    
                case .failure(let error):
                    self.displayError(error.localizedDescription, withTryAgain: { self.requestMeusPets() })
                }
            }
    }
    
    private func updateTableView() {
        DispatchQueue.main.async { self.cvPets.reloadData() }
    }
}



// MARK: - UICollectionViewDataSource

extension AdoteListaViewController: UICollectionViewDataSource , UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = cvPets.dequeueReusableCell(withReuseIdentifier: R.nib.vpCardCollectionViewCell.identifier, for: indexPath) as! VPCardCollectionViewCell
        
        cell.pet = self.pets[indexPath.row]
        cell.setup()
//        cell.imgPet.image = self.pets[indexPath.row].image?.decodeBase64ToImage()  ?? R.image.avataDog()!
//        cell.lbName.text = self.pets[indexPath.row].name
//        cell.lbAddress.text = self.pets[indexPath.row].info.size
//        cell.layer.cornerRadius = defaultCornerRadius
//        
//        cell.widthConstant.constant = cellWidth
        
        cell.showDetailDelegate = self
        return cell
    }
    
}


extension AdoteListaViewController : ShowDetailProtocol {
    
    func showDetail(pet: Pet) {
        let vc = storyboard?.instantiateViewController(identifier: "AdoteDetalheViewController") as? AdoteDetalheViewController
        vc?.name = pet.name ?? ""
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}
