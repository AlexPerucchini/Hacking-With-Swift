//
//  Picture.swift
//  Milestone-101-12
//
//  Created by Alex Perucchini on 5/24/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit

class Picture: NSObject, Codable {
    var caption: String
    var image: String
    
    init(caption: String, image: String) {
        self.caption = caption
        self.image = image
    }
}
