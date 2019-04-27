//
//  DetailViewController.swift
//  Milestone1
//
//  Created by Alex Perucchini on 4/25/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageLabel: UILabel!
    
    var selectedImage: String?
    var countryName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = countryName?.uppercased()
        navigationItem.largeTitleDisplayMode = .never
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
            imageView.layer.borderColor = UIColor.lightGray.cgColor
            imageView.layer.borderWidth = 1
        }
        
        if let labelToLoad = selectedImage {
            imageLabel.text = labelToLoad
        }
    }
}
