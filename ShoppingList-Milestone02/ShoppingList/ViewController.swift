//
//  UTableViewController.swift
//  ShoppingList
//
//  Created by Alex Perucchini on 5/5/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit

var shoppingList: [String] = []
class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "MyShoppingList"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearList))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    @objc func promptForItem(){
        let ac = UIAlertController(title: "Enter Shopping Item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            // call the submit action
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let item = answer.lowercased()
        // insert item in the shoppingList
        shoppingList.insert(item, at: 0)
        // update the row at the top of the tableView
        let indexPath = IndexPath(row: 0, section: 0)
        // this is for animation and you don't have to reload the entire tableView
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @objc func clearList() {
        shoppingList = []
        tableView.reloadData()
    }
}

