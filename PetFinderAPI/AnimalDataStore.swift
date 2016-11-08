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
    
    var favorites: [Animal] = []
    var animalFavs = [[String: Any]]()
    var animals: [Animal] = []
    var username = ""
    
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
    
    class func downloadFavorites(with completion: @escaping () -> Void) {
        
        let ref = FIRDatabase.database().reference().root
        let key = (AnimalDataStore.sharedInstance.username)
        
        ref.child("favorites").observeSingleEvent(of: .value, with: { snapshot in
            if let values = snapshot.value as? [String : AnyObject] {
                guard let favs = values[key] as? [[String: Any]] else {return}
                for fav in favs {
                    AnimalDataStore.sharedInstance.animalFavs.append(fav)
                }
                completion()
            }
        })
    }
    
    
    
}
