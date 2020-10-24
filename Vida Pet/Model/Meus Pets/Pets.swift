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
    let id: Int
    let image, name, petDescription: String
    let adoption: Bool
    let info: Info
    let medicalData: MedicalData

    enum CodingKeys: String, CodingKey {
        case id, image, name
        case petDescription = "description"
        case adoption, info, medicalData
    }
}

// MARK: - Info
struct Info: Codable {
    let coat, gender, weight, birth: String
    let size, breed: String
}

// MARK: - MedicalData
struct MedicalData: Codable {
    let surgerys, vaccines: [Surgery]
}

// MARK: - Surgery
struct Surgery: Codable {
    let nome, data: String
}

typealias Pets = [Pet]
