//
//  AdoteListaViewController.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 15/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

class AdoteListaViewController: VidaPetMainViewController , UICollectionViewDelegate , UICollectionViewDataSource {
    
    @IBOutlet weak var cvPets: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MeusPetsListaViewController.pets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = cvPets.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AdotaCollectionViewCell
        cell.imgPet.image = MeusPetsListaViewController.pets[indexPath.row].image?.decodeBase64ToImage()
        cell.lbName.text = MeusPetsListaViewController.pets[indexPath.row].name
        cell.lbAddress.text = MeusPetsListaViewController.pets[indexPath.row].info.size
        cell.layer.cornerRadius = 5
        return cell
    }
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cvPets.dataSource = self
        cvPets.delegate = self
        let nibCell  = UINib(nibName: "AdotaCollectionViewCell", bundle: nil)
        cvPets.register(nibCell, forCellWithReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
