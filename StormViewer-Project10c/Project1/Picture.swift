//
//  Image.swift
//  Project1
//
//  Created by Alex Perucchini on 5/17/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit

class Picture: NSObject, Comparable {
    var image: String
    var title: String
    
    init(image: String, title: String) {
        self.image = image
        self.title = title
    }
    
    static func < (lhs: Picture, rhs: Picture) -> Bool {
        return true
    }
    
}
