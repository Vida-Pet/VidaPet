//
//  RandomPet.swift
//  Vida Pet
//
//  Created by Timoteo Holanda on 10/11/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import Foundation
import Fakery



class RandomPet {
    
    
    // MARK: - Properties
    
    private let PET_URL : String = "https://random.dog/woof.json";
    private let faker = Faker(locale: "en-US")
    private var used_images : Array<String> = []
    private let pelagemMock : Array<String> = [
        "Pequena",
        "Média",
        "Alta"
    ]
    private var pet_image_url : String?
    private var pet_image_data : Data?
    private static var randomPet: RandomPet = {
        return RandomPet()
    }()
    private init() {
        
    }
    
    
    // MARK: - Accessors
    
    class func shared() -> RandomPet {
        return randomPet
    }
    
    
    // MARK: - Methods
    
    func generateRandomPet(id: Int?, completionHandler: @escaping (Pet) -> Void) {
        print("🐾 RandomPet: Generating random pet")
        getRandomPetImage() { imgData in
            let pet = Pet(
                id: id,
                image: self.pet_image_url,
                name: self.faker.name.firstName(),
                petDescription: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus eu magna non lectus consectetur hendrerit. Fusce fringilla sapien sit amet lorem gravida tincidunt quis sit amet tellus. Phasellus elementum interdum ante, vel facilisis sapien consectetur non. Aliquam erat volutpat. Suspendisse consequat vel neque eu ultricies. Proin et fermentum justo. In leo sapien, laoreet nec dictum sit amet, interdum vitae mauris. Morbi a sodales nisl. Mauris egestas, ante nec posuere molestie, orci lectus laoreet leo, nec mattis purus lectus in magna.",
                adoption: self.faker.number.randomBool(),
                info: Info(
                    coat: self.pelagemMock.randomElement(),
                    gender: self.faker.gender.binaryType(),
                    size: String(self.faker.number.randomFloat(min: 0.3, max: 4.5)),
                    breed: self.faker.cat.breed(),
                    birth: "\(self.faker.number.randomInt(min: 1, max: 31))/\(self.faker.number.randomInt(min: 1, max: 12))/\(self.faker.number.randomInt(min: 2010, max: 2020))",
                    weight: Double(self.faker.number.randomInt(min: 1, max: 10))),
                medicalData: MedicalData(surgerys: [], vaccines: []),
                dataImage: imgData)
            completionHandler(pet)
        }
    }
    
    func getRandomPetImage(completion: @escaping (Data) -> Void) {
        getJsonImage(from: URL(string: PET_URL)!) { result in
            self.getImageData(from: URL(string: result)!) { data, response, error in
                guard let data = data, error == nil else { return }
                completion(data)
            }
        }
    }
    
    private func getJsonImage(from url : URL, completion: @escaping (String)->Void) {
        print("🐾 RandomPet: Get image for random pet")
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let image_url = json["url"] as! String
                    
                    if(self.used_images.contains(image_url) || image_url.contains(".mp4")) {
                        self.getJsonImage(from: url, completion: completion)
                    } else {
                        self.used_images.append(image_url)
                        self.pet_image_url = image_url
                        completion(image_url)
                    }
                    
                }
            } catch let error as NSError {
                print("🐾 RandomPet: Failed to load: \(error.localizedDescription)")
            }
        }
        task.resume()
        
    }
    
    private func getImageData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
