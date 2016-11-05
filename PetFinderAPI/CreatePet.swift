//
//  Animals.swift
//  PetFinderAPI
//
//  Created by Felicity Johnson on 10/22/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Animal {
    let type: String
    let sex: String
    let breed: String
    let name: String
    let imageLink: String
    let age: String
    let size: String
    let description: String
    
    init(dict: JSON) {
        self.type = dict["animal"]["$t"].stringValue
        self.sex = dict["sex"]["$t"].stringValue
        self.age = dict["age"]["$t"].stringValue
        self.size = dict["size"]["$t"].stringValue
        self.breed = dict["breeds"]["breed"]["$t"].stringValue
        self.name = dict["name"]["$t"].stringValue
        self.imageLink = dict["media"]["photos"]["photo"][2]["$t"].stringValue
        self.description = dict["description"]["$t"].stringValue
    }
    
    init(type: String, sex: String, breed: String, name: String, imageLink: String, age: String, size: String, description: String) {
        self.type = type
        self.sex = sex
        self.breed = breed
        self.name = name
        self.imageLink = imageLink
        self.age = age
        self.size = size
        self.description = description
    }
}
