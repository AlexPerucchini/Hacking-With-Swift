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
        title = selectedImage! + " (\(selectedPictureNumber) of \(totalPictures))"
        // don't inherit the large title. Apple recommends this approach
        navigationItem.largeTitleDisplayMode  = .never
        
        //Project 3 create a new bar button share icon
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        // load the selected image into UIImageView since it's an optional we need to uwrap it
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
    
    // project 3
    @objc func shareTapped() {
        // get the images to share
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        // pass in the images to share to the activityItems
        let vc = UIActivityViewController(activityItems: ["\(selectedImage!)", image], applicationActivities: [])
        // show in the ipad
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
