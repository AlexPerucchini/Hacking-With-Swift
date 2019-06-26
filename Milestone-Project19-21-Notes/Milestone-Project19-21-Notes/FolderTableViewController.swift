//
//  FolderTableViewController.swift
//  Milestone-Project19-21-Notes
//
//  Created by Alex Perucchini on 6/23/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit

class FolderTableViewController: UITableViewController {
    
    var folders: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Folders"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(edit))
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.orange
        
        if navigationController?.tabBarItem.tag == 1 {
            promptForItem()
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return folders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Folders", for: indexPath)
        cell.textLabel?.text = folders[indexPath.row]
        return cell
    }

    @objc func promptForItem(){
        let ac = UIAlertController(title: "New Folder", message: "Enter a name for this folder.", preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Save", style: .default) {
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            // call the submit action
            self?.submit(answer)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        ac.addAction(submitAction)
        ac.addAction(cancel)
        
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let item = answer.lowercased()
        // insert item in the shoppingList
        folders.insert(item, at: 0)
        // update the row at the top of the tableView
        let indexPath = IndexPath(row: 0, section: 0)
        // this is for animation and you don't have to reload the entire tableView
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @objc func edit() {
        
    }
}
