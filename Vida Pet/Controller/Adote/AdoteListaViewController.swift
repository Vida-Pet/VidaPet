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
    
    final let defaultCornerRadius: CGFloat = 5
    final let defaultNumberOfCollumns: CGFloat = 2
    final let defaultCardSpaces: CGFloat = 15
    final let mockCellCountMultiplier: Int = 5
    var mockCellIndex: [Int] = []
    var cellWidth: CGFloat {
        return (UIScreen.main.bounds.width / defaultNumberOfCollumns) - (((defaultNumberOfCollumns+1) * defaultCardSpaces)/defaultNumberOfCollumns)
    }
    
    
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
    }
    
    
    // MARK: Methods
    
    private func setupCollectionView() {
        let nibCell  = UINib(nibName: R.nib.vpCardCollectionViewCell.name, bundle: nil)
        cvPets.register(nibCell, forCellWithReuseIdentifier: R.nib.vpCardCollectionViewCell.identifier)
        cvPets.dataSource = self
        
        for _ in 0...mockCellCountMultiplier*MeusPetsListaViewController.pets.count {
            mockCellIndex.append(Int.random(in: 0...2))
        }
    }
    
}



// MARK: - UICollectionViewDataSource

extension AdoteListaViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MeusPetsListaViewController.pets.count * mockCellCountMultiplier
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cvPets.dequeueReusableCell(withReuseIdentifier: R.nib.vpCardCollectionViewCell.identifier, for: indexPath) as! VPCardCollectionViewCell
        
        cell.imgPet.image = MeusPetsListaViewController.pets[mockCellIndex[indexPath.row]].image?.decodeBase64ToImage()
        cell.lbName.text = MeusPetsListaViewController.pets[mockCellIndex[indexPath.row]].name
        cell.lbAddress.text = MeusPetsListaViewController.pets[mockCellIndex[indexPath.row]].info.size
        cell.layer.cornerRadius = defaultCornerRadius
        
        cell.widthConstant.constant = cellWidth
        return cell
    }
}
