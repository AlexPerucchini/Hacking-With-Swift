//
//  ViewController.swift
//  WhiteHousePetitions
//
//  Created by Alex Perucchini on 5/6/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//
//  reference; https://petitions.whitehouse.gov/developers/get-code

import UIKit

class ViewController: UITableViewController {
    
    var petitions: [Petition] = []
    var urlString: String = ""
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))

    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = "WeThePeople"
        
        // loading indicator
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
       
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(promptForSearch))
        
        if navigationController?.tabBarItem.tag == 0 {
            // "https://www.hackingwithswift.com/samples/petitions-1.json"
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=500"
        } else {
            // "https://www.hackingwithswift.com/samples/petitions-2.json"
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=500"
        }
        
        parseURL(urlString)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let vc = DetailViewController()
            vc.detailItem = petitions[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func showInfo() {
        let ac = UIAlertController(title: "Petitions", message: "These petitions were retrieved from \(urlString)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func promptForSearch() {
        let ac = UIAlertController(title: "Search By Title", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        // closure to handle user input
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
        let titleSearch = answer.lowercased()
        if titleSearch.isEmpty {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=200"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?title=\(titleSearch)"
        }
        parseURL(urlString)
    }
    
    func parseURL(_ str: String) {
        let str = str
        if let url = URL(string: str) {
            if let data = try? Data(contentsOf: url){
                parse(json: data)
                return
            }
            showError()
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        loadingIndicator.startAnimating()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
            // dismiss loading indicator
            dismiss(animated: false, completion: nil)
        }
    }
}
