//
//  SelectedTableViewController.swift
//  PetFinderAPI
//
//  Created by Felicity Johnson on 10/23/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SelectedTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var favoritesTableView: UITableView!
    
    var animalArray = [[String: Any]]()
    var indexPathForCell: Int = 0
    let ref = FIRDatabase.database().reference().root
    let userKey =  FIRAuth.auth()?.currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.downloadFavorites {
            OperationQueue.main.addOperation {
                self.favoritesTableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return animalArray.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DetailTableViewCell
        
        cell.animalNameLabel.text = String(describing: animalArray[indexPath.row]["name"]!)
        cell.breedLabel.text = String(describing: animalArray[indexPath.row]["breed"]!)
        cell.sexLabel.text = String(describing: animalArray[indexPath.row]["sex"]!)
        cell.ageLabel.text = String(describing: animalArray[indexPath.row]["age"]!)
        cell.sizeLabel.text = String(describing: animalArray[indexPath.row]["size"]!)
        cell.unfavButton.addTarget(self, action: #selector(unfavoriteButton), for: .touchUpInside)
        indexPathForCell = indexPath.row
        
        return cell
    }
    
    func unfavoriteButton(sender: UIButton) {
        _ = sender.tag
        
        let cellContent = sender.superview!
        let cell = cellContent.superview! as! UITableViewCell
        let indexPath = self.favoritesTableView.indexPath(for: cell)
        
        self.ref.child("animals").observeSingleEvent(of: .value, with: { (snapshot) in
            if let animalValues = snapshot.value as? [String: Any] {
                
                let animalToRemoveName = self.animalArray[(indexPath?.row)!]["name"] as! String
                let animalToRemoveBreed = self.animalArray[(indexPath?.row)!]["breed"] as! String
                let animalToRemoveSex = self.animalArray[(indexPath?.row)!]["sex"] as! String
                let animalToRemoveAge = self.animalArray[(indexPath?.row)!]["age"] as! String
                let animalToRemoveSize = self.animalArray[(indexPath?.row)!]["size"] as! String
                print(animalToRemoveName)
                
                for animal in animalValues {
                    let value = animal.value as! [String: String]
                    if (value["name"] == animalToRemoveName) && (value["breed"] == animalToRemoveBreed) && (value["sex"] == animalToRemoveSex) && (value["age"] == animalToRemoveAge) && (value["size"] == animalToRemoveSize) {
                        
                        let keyToRemove = animal.key
                        print(keyToRemove)
                        
                        self.ref.child("favorites").child(self.userKey!).observeSingleEvent(of: .value, with: { snapshot in
                            if let favValues = snapshot.value as? [String] {
                                if favValues.contains(keyToRemove) {
                                    for animalValue in favValues {
                                        print(animalValue)
                                        self.ref.child("favorites").child(self.userKey!).child(animalValue).removeValue()
                                    }
                                    
                                }
                            }
                        })
                    }
                }
            }
        })
        
        presentAlertWithTitle(title: "Success", message: "You have refined your favorites list")
        favoritesTableView.reloadData()
    }

    
    func downloadFavorites(with completion: @escaping ()-> ()) {
        animalArray.removeAll()
        let ref = FIRDatabase.database().reference().root
        
        
        ref.child("favorites").child(userKey!).observeSingleEvent(of: .value, with: { snapshot in
            if let favValues = snapshot.value as? [String] {
                ref.child("animals").observeSingleEvent(of: .value, with: { snapshot in
                    if let animalValues = snapshot.value as? [String: Any] {
                        for (_, value) in animalValues.enumerated() {
                            if favValues.contains(value.key) {
                                var animalToAdd = [String: Any]()
                                animalToAdd = value.value as! [String : Any]
                                self.animalArray.append(animalToAdd)
                                completion()
                            }
                        }
                    }
                })
            }
        })
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

   
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "addFavorite" {
            _ = segue.destination as! AnimalImagesCollectionViewController
        }
    }
}

extension UIViewController {
    
    func presentAlertWithTitle(title: String, message : String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .cancel) {
            (action: UIAlertAction) in print("Youve pressed OK Button")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
