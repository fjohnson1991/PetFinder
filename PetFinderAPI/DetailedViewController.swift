//
//  DetailedViewController.swift
//  PetFinderAPI
//
//  Created by Felicity Johnson on 10/23/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class DetailedViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var animalPic: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    let ref = FIRDatabase.database().reference().root
    var nameArray = [String]()
    var breedArray = [String]()
    var ageArray = [String]()
    
    var favNameArray = [String]()
    var favBreedArray = [String]()
    var favAgeArray = [String]()
    
    var animalToAdd: Animal?
    var animalArray = [[String: String]]()
    
    var newFavorite = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = animalToAdd?.name
        breedLabel.text = animalToAdd?.breed
        ageLabel.text = animalToAdd?.age
        sizeLabel.text = animalToAdd?.size
        sexLabel.text = animalToAdd?.sex
        descriptionTextView.text = animalToAdd?.description
        animalPic.image = animalToAdd?.imageLink.setImageFromURl(stringImageUrl: (animalToAdd?.imageLink)!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AnimalDataStore.sharedInstance.downloadFavorites {
            OperationQueue.main.addOperation {
                self.animalArray = AnimalDataStore.sharedInstance.animalArray
            }
        }
    }
    
    //MARK: - Check for duplicates
    
    func checkIfAnimalAlreadyExists(with completion: @escaping (Bool) -> ()) {
        var completionToPass = false
        
        guard let animalName = animalToAdd?.name,
            let animalBreed = animalToAdd?.breed,
            let animalAge = animalToAdd?.age
            else { return }
        
        for animal in AnimalDataStore.sharedInstance.allAnimals {
            self.nameArray.append(animal["name"]!)
            self.breedArray.append(animal["breed"]!)
            self.ageArray.append(animal["age"]!)
        }

        if (self.nameArray.contains(animalName) && self.breedArray.contains(animalBreed) && self.ageArray.contains(animalAge)) {
            completionToPass = false
        } else {
            completionToPass = true
        }
        completion(completionToPass)
    }
    
    
    func checkIfAnimalAlreadyFavorite(with completion: @escaping (Bool) -> ()) {
        
        var completionToPass = false
        
        guard let animalName = animalToAdd?.name,
            let animalBreed = animalToAdd?.breed,
            let animalAge = animalToAdd?.age
            else { return }
        
        for animal in AnimalDataStore.sharedInstance.animalArray {
            
            favNameArray.append(animal["name"]!)
            favBreedArray.append(animal["breed"]!)
            favAgeArray.append(animal["age"]!)
        }
        
        if ((favNameArray.contains(animalName)) && (favAgeArray.contains(animalAge)) && (favBreedArray.contains(animalBreed))) {
            completionToPass = false
        } else {
            completionToPass = true
        }
        completion(completionToPass)
        
    }
    
    
    //MARK: - Add to favorites
    
    func generateIdToPass(with completion: (String) -> ()) {
        var idToPass = String()
        
        for animal in AnimalDataStore.sharedInstance.allAnimals {
            print(animal)
            print(animal["name"]!)
            print(animalToAdd!.name)
            if animal["name"]! == animalToAdd!.name {
                idToPass = animal["uniqueID"]!
                print(animalToAdd!.name)
                print(idToPass)
                
            }
        }
        completion(idToPass)
        
    }
    
    
    func createNewFavorite(with completion: ([String: String], [String: String]) -> ()) {
        let key =  ref.child("animals").childByAutoId().key
        guard let animalName = animalToAdd?.name,
            let animalBreed = animalToAdd?.breed,
            let animalAge = animalToAdd?.age,
            let animalSize = animalToAdd?.size,
            let animalSex = animalToAdd?.sex
            else { return }
        
        var newDictionary = [String: String]()
        newDictionary["name"] = animalName
        newDictionary["breed"] = animalBreed
        newDictionary["age"] = animalAge
        newDictionary["size"] = animalSize
        newDictionary["sex"] = animalSex
        newDictionary["uniqueID"] = key
        
        self.newFavorite[key] = "true"
        
        completion(newDictionary, newFavorite)
        
    }
    
    
    @IBAction func addToFavoritesButton(_ sender: AnyObject) {
        guard let userKey = FIRAuth.auth()?.currentUser?.uid else {return}
        
        if self.animalArray.count == 0 {
            
            checkIfAnimalAlreadyExists(with: { (doesNotExist) in
                
                if doesNotExist == false {
                    self.generateIdToPass(with: { (passedID) in
                        self.newFavorite[passedID] = "true"
                        self.ref.child("favorites").child(userKey).updateChildValues(self.newFavorite)
                    })
                } else {
                    self.createNewFavorite(with: { (newDictionary, newFavorite) in
                        self.ref.child("animals").updateChildValues(["\(newDictionary["uniqueID"]!)": newDictionary])
                        self.ref.child("favorites").child(userKey).updateChildValues(self.newFavorite)
                    })
                }
                self.presentAlertWithTitle(title: "Congrats!", message: "You successfully added a favorite")
            })
        }
        
        
        checkIfAnimalAlreadyFavorite { (addToFavorite) in
            
            if addToFavorite == true {
                self.checkIfAnimalAlreadyExists(with: { (doesNotExist) in
                    if doesNotExist == false {
                        self.generateIdToPass(with: { (passedID) in
                            self.newFavorite[passedID] = "true"
                            self.ref.child("favorites").child(userKey).updateChildValues(self.newFavorite)
                        })
                        
                        
                    } else {
                        self.createNewFavorite(with: { (newDictionary, newFavorite) in
                            self.ref.child("animals").updateChildValues(["\(newDictionary["uniqueID"]!)": newDictionary])
                            self.ref.child("favorites").child(userKey).updateChildValues(self.newFavorite)
                        })
                    }
                    self.presentAlertWithTitle(title: "Congrats!", message: "You successfully added a favorite")
                })
            } else if addToFavorite == false {
                self.presentAlertWithTitle(title: "Ooops!", message: "Already a favorite")
            }
        }
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
