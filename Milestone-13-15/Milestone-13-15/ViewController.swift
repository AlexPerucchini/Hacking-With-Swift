//
//  ViewController.swift
//  Milestone-13-15
//
//  Created by Alex Perucchini on 6/3/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var countriesList: [Country] = []
    var filteredCountry: [Country] = []
    var urlString: String = ""
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Countries"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        title = "OneWorld "

        urlString = "https://restcountries.eu/rest/v2/all"
        
        // load data loading indicator
        loadIndicator()
        
        // GDC
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            if let url = URL(string: self!.urlString) ?? nil {
                if let data = try? Data(contentsOf: url) {
                    // we're OK to parse!
                    self?.parse(json: data)
                }
            } else {
                self?.showError()
            }
        }
    }
    
    // MARK: - TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredCountry.count
        }
        
        return countriesList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        var country : Country
        
        if isFiltering() {
            country = filteredCountry[indexPath.row]
        } else {
            country = countriesList[indexPath.row]
        }
        cell.textLabel?.text = country.name
        cell.detailTextLabel?.text = country.region
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        
        if isFiltering() {
            vc.detailItem = filteredCountry[indexPath.row]
        } else {
            vc.detailItem = countriesList[indexPath.row]
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Error
    
    func showError() {
        let ac = UIAlertController(title: "Loading error",
                                   message: "There was a problem loading the feed; please check your connection and try again.",
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    // MARK: - Json
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonDecoder = try? decoder.decode([Country].self, from: json) {
            countriesList = jsonDecoder
            
            DispatchQueue.main.async {
                [weak self] in
                self?.tableView.reloadData()
            }
        }
        // dismiss loading indicator
        dismiss(animated: false, completion: nil)
    }
    
    // MARK: - Load Indicator
    
    func loadIndicator () {
        // loading indicator
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Search Bar
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredCountry = countriesList.filter({( country : Country) -> Bool in
            return country.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

extension ViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

