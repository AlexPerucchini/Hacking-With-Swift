//
//  ViewController.swift
//  Project1
//
//  Created by Alex Perucchini on 4/9/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // create an array to hold our pictures
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        loadData()
        print(pictures)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? PictureCell else {
            fatalError("Error: CollectionView failed to load.")
        }
        
        let picture = pictures[indexPath.item]
        cell.title.text = picture
        cell.imageView.image = UIImage(named: picture)
        
        cell.imageView.layer.cornerRadius = 3
        cell.imageView.layer.borderWidth = 1
        cell.imageView.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.cornerRadius = 7
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.title.textColor = UIColor.white
        
        return cell
    }
    
    @objc func loadData() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                // this is the picture to load
                pictures.append(item)
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

