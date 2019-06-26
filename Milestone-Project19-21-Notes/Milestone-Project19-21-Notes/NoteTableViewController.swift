//
//  ViewController.swift
//  Milestone-Project19-21-Notes
//
//  Created by Alex Perucchini on 6/23/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit

var notes: [Note] = []

class NoteTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.orange
        
    }

    // MARK:- Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        
        return cell
    }
    
    @objc func addNote() {

    }
}

