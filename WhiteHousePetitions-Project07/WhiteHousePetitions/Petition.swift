//
//  Petition.swift
//  WhiteHousePetitions
//
//  Created by Alex Perucchini on 5/6/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
