//
//  ViewController.swift
//  Milestone1
//
//  Created by Alex Perucchini on 4/25/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var countries = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Flag Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasSuffix("png") {
                countries.append(item)
            }
        }
       
        //print("hello \(countries)")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        
        // return the countries sorted
        countries = countries.sorted()
        
        cell.textLabel?.text = countries[indexPath.row]
        
        let image: UIImage = UIImage(named: countries[indexPath.row])!
        cell.imageView?.image = image
        cell.imageView?.layer.borderColor = UIColor.lightGray.cgColor
        cell.imageView?.layer.borderWidth = 1
        
        return cell
    }
    
    // 1) load the detail view controller layout from our storyboard.
    // 2) set its selectedImage property to be the correct item from the countries array.
    // 3) show the new view controller.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = countries[indexPath.row]
            // split the  countries array and get the country name for the Detail View title
            vc.countryName = countries[indexPath.row].components(separatedBy: "@").first
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

