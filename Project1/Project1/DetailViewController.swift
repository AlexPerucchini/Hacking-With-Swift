//
//  DetailViewController.swift
//  Project1
//
//  Created by Alex Perucchini on 4/10/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var selectedPictureNumber = 0
    var totalPictures = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Image: " + selectedImage! + " No: \(selectedPictureNumber) of \(totalPictures)"
        // don't inherit the large title. Apple recommends this approach
        navigationItem.largeTitleDisplayMode  = .never
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
