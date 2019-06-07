//
//  Capital.swift
//  Mapkit-Project16
//
//  Created by Alex Perucchini on 6/5/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit
import MapKit   

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
