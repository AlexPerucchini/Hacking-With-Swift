//
//  Person.swift
//  NameToFaces-Project10
//
//  Created by Alex Perucchini on 5/16/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit
// NSCoding requires a class
class Person: NSObject, NSCoding {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    // this method is required for the subclasses
    required init(coder aDecoder: NSCoder) {
        // this return any so we typecast as String
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
    }
}
