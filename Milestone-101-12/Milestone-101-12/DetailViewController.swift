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
        
        guard let caption = selectedImage?.caption else {return}
        title = "Image: \(caption)"
        // don't inherit the large title. Apple recommends this approach
        navigationItem.largeTitleDisplayMode  = .never
        
        if let imageToLoad = selectedImage?.image {
            // get the path of the image
            let path = getDocumentsDirectory().appendingPathComponent(imageToLoad)
            // load the pciture
            imageView.image = UIImage(contentsOfFile: path.path)
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
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
