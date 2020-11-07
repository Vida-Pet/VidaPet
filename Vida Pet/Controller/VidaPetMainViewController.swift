//
//  VidaPetMainViewController.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 15/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit
typealias EmptyClosure = () -> Void
class VidaPetMainViewController: UIViewController {
    
    let defaultDateFormatter: DateFormatter = DateFormatter()
    
    static var pets = [
        Pet(id: 1, image: nil, name: "Rodolfo", petDescription: "Rodolfo é top, ele é demais. Sério, puta dog top! Ele gosta muito de brincar de comer o sofá e sempre faz xixi no tapete... Adoro este cachorrinho sapeca!", adoption: false, info: Info(coat: "Curta", gender: "Macho", size: "Médio", breed: "Vira Lata", birth: "15/07/2000", weight: 5.0), medicalData: MedicalData(surgerys: [Surgery(nome: "Castração", data: "20/09/2010")], vaccines: [Vaccine(nome: "Corona Virus Animal", data: "11/03/2013"), Vaccine(nome: "Tetravalente", data: "28/01/2015"), Vaccine(nome: "Outra Vacina Boa", data: "09/11/2014")])),
        Pet(id: 2, image: nil, name: "Rodolfo", petDescription: "Rodolfo é top, ele é demais. Sério, puta dog top! Ele gosta muito de brincar de comer o sofá e sempre faz xixi no tapete... Adoro este cachorrinho sapeca!", adoption: false, info: Info(coat: "Curta", gender: "Macho", size: "Médio", breed: "Vira Lata", birth: "15/07/2000", weight: 5.0), medicalData: MedicalData(surgerys: [Surgery(nome: "Castração", data: "20/09/2010")], vaccines: [Vaccine(nome: "Corona Virus Animal", data: "11/03/2013"), Vaccine(nome: "Tetravalente", data: "28/01/2015"), Vaccine(nome: "Outra Vacina Boa", data: "09/11/2014")])),
        Pet(id: 3, image: nil, name: "Rodolfo", petDescription: "Rodolfo é top, ele é demais. Sério, puta dog top! Ele gosta muito de brincar de comer o sofá e sempre faz xixi no tapete... Adoro este cachorrinho sapeca!", adoption: false, info: Info(coat: "Curta", gender: "Macho", size: "Médio", breed: "Vira Lata", birth: "15/07/2000", weight: 5.0), medicalData: MedicalData(surgerys: [Surgery(nome: "Castração", data: "20/09/2010")], vaccines: [Vaccine(nome: "Corona Virus Animal", data: "11/03/2013"), Vaccine(nome: "Tetravalente", data: "28/01/2015"), Vaccine(nome: "Outra Vacina Boa", data: "09/11/2014")]))]

    override func viewDidLoad() {
        super.viewDidLoad()
        defaultDateFormatter.dateFormat = R.string.meusPetsCadastro.default_date_formater()
    }
    
}
