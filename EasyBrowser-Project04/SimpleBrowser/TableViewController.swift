//
//  TableViewController.swift
//  SimpleBrowser
//
//  Created by Alex Perucchini on 4/30/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var websites = ["google.com", "apple.com", "hackingwithswift.com", "developer.apple.com"]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SimpleBrowser"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Table view data source
    // override means the function is changing the parent view. How many rows do we need to display?
    override func tableView(_ tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int {
        return websites.count
    }
    
    // cellForRowAt contains one row and one section
    override func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        // recycle unused cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "website", for: indexPath)
        // find the index path of the pictures array and set the picture text
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
    
    // 1) load the detail view controller layout from our storyboard
    // 2) set its selectedImage property to be the correct website
    // 3) show the new view controller
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "View") as? ViewController {
            vc.website = websites[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
