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
        Pet(id: 1, image: images[0], name: "Rodolfo", description: "Rodolfo é top, ele é demais. Sério, puta dog top! Ele gosta muito de brincar de comer o sofá e sempre faz xixi no tapete... Adoro este cachorrinho sapeca!", adoption: false, info: Info(coat: "Curta", gender: "Macho", size: "Grande", breed: "Beagle", birth: "15/01/2007", weight: 9.0), medicalData: MedicalData(surgerys: [Surgery(nome: "Hérnia de disco", data: "04/09/2018"), Surgery(nome: "Castração", data: "01/10/2007")], vaccines: [Vaccine(nome: "Corona Virus Animal", data: "11/03/2013"), Vaccine(nome: "Raiva", data: "28/01/2015"), Vaccine(nome: "Múltiplas: V6 e V10", data: "12/10/2008")]), user: PetUser(id: 1)),
        Pet(id: 2, image: images[1], name: "Zequinha", description: "Zequinha é o gato mais fofo do mundo. Ele é um vira lata sem vergonha, que gosta de arranhar a casa toda... Carinhoso, mas apenas com quem conheçe! Costuma ser muito arisco com visitas.", adoption: true, info: Info(coat: "Média", gender: "Macho", size: "Médio", breed: "Vira Lata", birth: "15/07/2000", weight: 5.0), medicalData: MedicalData(surgerys: [Surgery(nome: "Ligamento cruzado", data: "20/09/2010")], vaccines: [Vaccine(nome: "Corona Virus Animal", data: "11/03/2013"), Vaccine(nome: "Giardíase", data: "28/01/2015")]), user: PetUser(id: 1)),
        Pet(id: 3, image: images[2], name: "Carlinha", description: "Carlinha é uma cadela bem engraçada... salvei ela da rua, e ela é super apegada a mim! Carinhosa, dengosa, e brincalhona!", adoption: false, info: Info(coat: "Longa", gender: "Fêmea", size: "Pequeno", breed: "Buldogue", birth: "15/07/2013", weight: 2.0), medicalData: MedicalData(surgerys: [Surgery(nome: "Castração", data: "01/10/2014")], vaccines: [Vaccine(nome: "Anti-Rábica", data: "11/01/2015"), Vaccine(nome: "Outra Vacina Boa", data: "09/11/2014")]), user: PetUser(id: 1))]

   
    private static let images = [(R.image.beagle()!).encodeImageToBase64(), (R.image.gato()!).encodeImageToBase64(), (R.image.bullDog()!).encodeImageToBase64()]

    override func viewDidLoad() {
        super.viewDidLoad()
        defaultDateFormatter.dateFormat = R.string.meusPetsCadastro.default_date_formater()
    }
    
}
