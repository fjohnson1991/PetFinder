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
    
    var firebaseAnimals = [String: Any]()
    var animalFavs = [String: Any]()
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

    
    
//    class func downloadAnimals(with completion: @escaping () -> Void) {
//        
//        let ref = FIRDatabase.database().reference().root
//        let key =  ref.child("animals").childByAutoId()
//        
//        ref.child("animals").observeSingleEvent(of: .value, with: { snapshot in
//            if let values = snapshot.value as? [String : AnyObject] {
//                guard let animals = values[key] as? [[String: Any]] else {return}
//                for animal in animals {
//                    AnimalDataStore.sharedInstance.firebaseAnimals.append(animal)
//                }
//                completion()
//            }
//        })
//    }
//    
    
    
}
