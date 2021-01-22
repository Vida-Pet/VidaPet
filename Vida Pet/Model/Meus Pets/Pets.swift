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
    var medicalData: MedicalData?
    var dataImage: Data?
    var user: PetUser
    
    enum CodingKeys: String, CodingKey { 
        case id, image, name
        case description = "description"
        case adoption, info, medicalData, user
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
    var name, data: String?
    var id, petId: Int?
}

// MARK: - Vaccine
struct Vaccine: Codable {
    var name, data: String?
    var id, petId: Int?
}

// MARK: - User
struct PetUser: Codable {
    var id: Int
    var bio: String? = nil
    var isPublicProfile: Bool? = nil
    var image: String? = nil
    var name: String? = nil
}

typealias Pets = [Pet]
