//
//  AnimalDataStore.swift
//  PetFinderAPI
//
//  Created by Felicity Johnson on 10/27/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

class AnimalDataStore {
    
    static let sharedInstance = AnimalDataStore()
    private init() {}
    
    var animalArray = [[String: String]]()
    var allAnimals = [[String: String]]()
    var animals: [Animal] = []
    var username = ""
    
    let ref = FIRDatabase.database().reference().root
    let userKey =  FIRAuth.auth()?.currentUser?.uid
    
    class func getAnimalsFromPetFinderAPI(completion: @escaping ()->Void) {
        PetFinderAPIClient.loadAnimals { (response) in
            for animal in response {
                let newAnimal = Animal(dict: animal)
                AnimalDataStore.sharedInstance.animals.append(newAnimal)
            }
            
            completion()
        }
        
    }
    
    class func displayName(email: String) {
        let usernameArray = email.components(separatedBy: "@")
        let username = usernameArray[0]
        AnimalDataStore.sharedInstance.username = username
    }

    
    func downloadAnimals(with completion: @escaping ([String: String]) -> ()) {
        
        ref.child("animals").observeSingleEvent(of: .value, with: { snapshot in
            if let animalValues = snapshot.value as? [String: Any] {
                for animal in animalValues {
                    let animalString = animal.value as! [String: String]
                    self.allAnimals.append(animalString)
                    completion(animalString)
                
                }
            }
        })
    }

    
    
    func downloadFavorites(with completion: @escaping ()-> ()) {
        animalArray.removeAll()
        
        ref.child("favorites").child(userKey!).observeSingleEvent(of: .value, with: { snapshot in
            if let favValues = snapshot.value as? [String: String] {
                self.downloadAnimals(with: { (animal) in
                        for fav in favValues {
                             print("FavKey: \(fav.key) vs. AnimalKey: \(animal["uniqueID"])")
                            if fav.key == animal["uniqueID"]! {
                                if fav.value == "true" {
                                    AnimalDataStore.sharedInstance.animalArray.append(animal)
                                    completion()
                                
                            }
                        }
                    }
                })
            }
        })
    }

    
}
