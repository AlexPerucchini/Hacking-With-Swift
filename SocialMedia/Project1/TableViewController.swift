//
//  ViewController.swift
//  Project1
//
//  Created by Alex Perucchini on 4/9/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    // create an array to hold our pictures
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // let's get the pictures
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        for item in items {
            if item.hasPrefix("nssl") {
                // we found the the picture to load
                pictures.append(item)
            }
        }
        //sort pictures
        pictures = pictures.sorted()
    }

    // override means the function is changing the parent view. How many rows do we need to display?
    override func tableView(_ tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int {
        return pictures.count
    }
    
    // cellForRowAt contains one row and one section
    override func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        // recycle unused cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "picture", for: indexPath)
        // find the index path of the pictures array and set the picture text
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    // 1) load the detail view controller layout from our storyboard.
    // 2) set its selectedImage property to be the correct item from the pictures array.
    // 3) show the new view controller. 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // try loading the detail view controller and typecast as DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // great, set it's selectedImage property
            vc.selectedImage = pictures[indexPath.row]
            // set the picture index
            vc.selectedPictureNumber = indexPath.row + 1
            // set total number of pictures
            vc.totalPictures  = pictures.count
            // now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

