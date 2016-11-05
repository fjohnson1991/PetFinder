//
//  AnimalDataStore.swift
//  PetFinderAPI
//
//  Created by Felicity Johnson on 10/27/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import Foundation

class AnimalDataStore {
    static let sharedInstance = AnimalDataStore()
    private init() {}
    
    var favorites: [Animal] = []
    var animals: [Animal] = []
    
    class func getAnimalsFromPetFinderAPI(completion: @escaping ()->Void) {
        
        PetFinderAPIClient.loadAnimals { (response) in
            for animal in response {
                let newAnimal = Animal(dict: animal)
                AnimalDataStore.sharedInstance.animals.append(newAnimal)
            }
            
            completion()
        }
        
    }

}
