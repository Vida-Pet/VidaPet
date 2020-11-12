//
//  RecemChegadosListaViewController.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 15/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

class RecemChegadosListaViewController: VidaPetMainViewController {
    
    
    
    @IBOutlet weak var recemChegadosTableView: UITableView!
    
    private let cellName: String = "RecemChegadosTableViewCellv2"
    private let segueToDetails = "RecemChegadosListaToPetsDetalhes"
    
    private var pets : Array<Pet> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recemChegadosTableView.delegate = self
        recemChegadosTableView.dataSource = self
        recemChegadosTableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
        
        
        
        addNewPet(id: 3) {
            DispatchQueue.main.async {
                self.recemChegadosTableView.reloadData()
            }
        }
        
        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        recemChegadosTableView.backgroundView = spinner
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func addNewPet(id: Int, completion : @escaping () -> Void) {
        
        if(id < 1) {
            return
        }
        
        DispatchQueue.global().asyncAfter(deadline: DispatchTime(uptimeNanoseconds: UInt64(Int.random(in: 1000..<1500))), execute: {
            RandomPet.shared().generateRandomPet(id: id) { pet in
                self.pets.append(pet)
                completion()
            }
        })
        self.addNewPet(id: id - 1, completion: completion)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case segueToDetails:
            if let destinationVC = segue.destination as? RecemChegadosDetalheViewController,
                let indexPath = sender as? IndexPath{
                destinationVC.pet = self.pets[indexPath.row]
                destinationVC.selectedPetIndex = indexPath.row
            }
        default: break
        }
    }
    
    
    
}

extension RecemChegadosListaViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(pets[indexPath.row])
        performSegue(withIdentifier: self.segueToDetails, sender: indexPath)
    }
    
}

extension RecemChegadosListaViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pets.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as? RecemChegadosTableViewCellv2 else {
            return UITableViewCell()
        }
        
        let selectedPet = self.pets[indexPath.row]
        
        cell.petImage.layer.cornerRadius = 8.0
        cell.petImage.clipsToBounds = true
        
        cell.imageView?.contentMode = .scaleAspectFit
        
        
        cell.petDesc.text = "\(selectedPet.name!), \n\(selectedPet.info.breed!), \(formatAge(pet: selectedPet))"
        
        
        
        cell.petImage.contentMode = .scaleAspectFit
        cell.petImage.image = UIImage(data: selectedPet.dataImage!)?.squared()
        
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
        
        
        
        //        RandomPet.shared().generateRandomPet(id: indexPath.row) { pet in
        //            DispatchQueue.main.sync {
        //                cell.petDesc.text = pet.name
        //                cell.petImage.image = UIImage(data: pet.dataImage!)?.squared()
        //                cell.contentView.frame.inset(by: UIEdgeInsets(top: 16, left: 20, bottom: 20, right: 16))
        //            }
        //        }
        
        return cell
    }
    
    func formatAge(pet: Pet?) -> String {
        var formattedAge = ""
        if var age = pet!.info.birth?.ageFromDate(withFormatter: defaultDateFormatter) {
            if(age > 1) {
                formattedAge = "\(Int(floor(age))) anos"
            }
            else {
                age *= 12
                formattedAge = "\(Int(floor(age))) meses"
            }
        }
        return formattedAge
        
        
    }
    
    
    
    
    
    
    
}


extension UIImage {
    var isPortrait:  Bool    { size.height > size.width }
    var isLandscape: Bool    { size.width > size.height }
    var breadth:     CGFloat { min(size.width, size.height) }
    var breadthSize: CGSize  { .init(width: breadth, height: breadth) }
    func squared(isOpaque: Bool = false) -> UIImage? {
        guard let cgImage = cgImage?
            .cropping(to: .init(origin: .init(x: isLandscape ? ((size.width-size.height)/2).rounded(.down) : 0,
                                              y: isPortrait  ? ((size.height-size.width)/2).rounded(.down) : 0),
                                size: breadthSize)) else { return nil }
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: breadthSize, format: format).image { _ in
            UIImage(cgImage: cgImage, scale: 1, orientation: imageOrientation)
                .draw(in: .init(origin: .zero, size: breadthSize))
        }
    }
}

