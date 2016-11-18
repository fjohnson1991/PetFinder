////
////  ViewController.swift
////  PetFinderAPI
////
////  Created by Felicity Johnson on 10/22/16.
////  Copyright © 2016 FJ. All rights reserved.
////
//
//import UIKit
//import SwiftyJSON
//import Alamofire
//
//class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    @IBOutlet weak var animalListTableView: UITableView!
//
//    var animalArray = [Animal]()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        PetFinderAPIClient.loadAnimals { (animals) in
//            self.animalArray = animals
//            self.animalListTableView.reloadData()
//
//        }
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return animalArray.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DetailTableViewCell
//      
//        cell.animalNameLabel.text = animalArray[indexPath.row].name
//        cell.breedLabel.text = animalArray[indexPath.row].breed
//        cell.sexLabel.text = animalArray[indexPath.row].sex
//        cell.ageLabel.text = animalArray[indexPath.row].age
//        cell.sizeLabel.text = animalArray[indexPath.row].size
//        
//        return cell
//    }
//    
//    
//    
//}
//
