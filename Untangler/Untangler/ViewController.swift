//
//  ViewController.swift
//  Untangler
//
//  Created by Alex Perucchini on 5/19/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var currentLevel = 0
    var connections = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func levelUp() {
        currentLevel += 1
        
        connections.forEach{ $0.removeFromSuperview() }
        connections.removeAll()
        
        for _ 1...(currentLevel + 4) {
            let connection = UIView(frame: CFRect)
        }
    }
}

