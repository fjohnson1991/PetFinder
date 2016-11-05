//
//  PetFinderAPIClient.swift
//  PetFinderAPI
//
//  Created by Felicity Johnson on 10/22/16.
//  Copyright © 2016 FJ. All rights reserved.
//

//API Key: bdd45c8f6e757c91dd529fa76516c1e6
//API Secret: d991ae263c4e50e8aed040bd6eaa77cd

//http://api.petfinder.com/auth.getToken?key=bdd45c8f6e757c91dd529fa76516c1e6
//http://api.petfinder.com/my.method?key=bdd45c8f6e757c91dd529fa76516c1e6&arg1=foo&token=67890
//http://api.petfinder.com/pet.getRandom?format=json&key=bdd45c8f6e757c91dd529fa76516c1e6&animal=dog&output=basic
//http://api.petfinder.com/pet.find?format=json&key=bdd45c8f6e757c91dd529fa76516c1e6&animal=dog&location=94089&age=senior&count=10

import Foundation
import SwiftyJSON
import Alamofire

class PetFinderAPIClient {
    
    class func loadAnimals(completion:@escaping ([JSON]) -> ()) {
        Alamofire.request("http://api.petfinder.com/pet.find?format=json&key=\(Constants.key)&animal=dog&location=94089&age=senior").responseJSON { (response) in
            if let jsonData = response.data {
                var jsonObj = JSON(data: jsonData)
                let jsonArray = jsonObj["petfinder"]["pets"]["pet"].arrayValue
                
                completion(jsonArray)
                
                }
            }
        }

    }



