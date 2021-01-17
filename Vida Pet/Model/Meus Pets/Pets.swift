//
//  Pets.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 24/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//
//  Como usar:
//   let pets = try? newJSONDecoder().decode(Pets.self, from: jsonData)

import Foundation

// MARK: - Pet
struct Pet: Codable {
    var id: Int? 
    var image, name, description: String?
    var adoption: Bool?
    var info: Info
    var medicalData: MedicalData
    var dataImage: Data?

    enum CodingKeys: String, CodingKey { 
        case id, image, name
        case description = "description"
        case adoption, info, medicalData
    }
}

// MARK: - Info
struct Info: Codable {
    var coat, gender, size, breed, birth: String?
    var weight: Double?
}

// MARK: - MedicalData
struct MedicalData: Codable {
    var surgerys: [Surgery]
    var vaccines: [Vaccine]
}

// MARK: - Surgery
struct Surgery: Codable {
    var nome, data: String?
    var id, petId: Int?
}

// MARK: - Vaccine
struct Vaccine: Codable {
    var nome, data: String?
    var id, petId: Int?
}

typealias Pets = [Pet]
