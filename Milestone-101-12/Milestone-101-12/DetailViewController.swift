//
//  DetailViewController.swift
//  Milestone-101-12
//
//  Created by Alex Perucchini on 5/24/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var selectedImage: Picture?
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Caption"
        // don't inherit the large title. Apple recommends this approach
        navigationItem.largeTitleDisplayMode  = .never
        
        print("PICTURE: \(String(describing: selectedImage?.image))")
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad.image)
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
