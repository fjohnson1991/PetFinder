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
    
    var animalArray = [[String: Any]]()
    var allAnimals = [[String: Any]]()
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

    
    
    func downloadAnimals(with completion: @escaping ([String: Any]) -> ()) {
        
        ref.child("animals").observeSingleEvent(of: .value, with: { snapshot in
            if let animalValues = snapshot.value as? [String: Any] {
                self.allAnimals.append(animalValues)
                completion(animalValues)
                
            }
            
        })
    }

    
    
    func downloadFavorites(with completion: @escaping ()-> ()) {
        animalArray.removeAll()
        
        ref.child("favorites").child(userKey!).observeSingleEvent(of: .value, with: { snapshot in
            if let favValues = snapshot.value as? [String: String] {
                self.downloadAnimals(with: { (animals) in
                    for (_, value) in animals.enumerated() {
                        for fav in favValues {
                            if fav.key == value.key {
                                if fav.value == "true" {
                                    var animalToAdd = [String: Any]()
                                    animalToAdd = value.value as! [String : Any]
                                    AnimalDataStore.sharedInstance.animalArray.append(animalToAdd)
                                    completion()
                                }
                            }
                        }
                    }
                })
            }
        })
    }
        
}
