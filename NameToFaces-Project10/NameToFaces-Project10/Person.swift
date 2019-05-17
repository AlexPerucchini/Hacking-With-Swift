//
//  Person.swift
//  NameToFaces-Project10
//
//  Created by Alex Perucchini on 5/16/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
