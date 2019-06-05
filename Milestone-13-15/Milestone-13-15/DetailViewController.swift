//
//  DetailViewController.swift
//  Milestone-13-15
//
//  Created by Alex Perucchini on 6/4/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//


import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webView: WKWebView!
    var detailItem: Country?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem = detailItem else { return }
        
        let formater = NumberFormatter()
        formater.groupingSeparator = ","
        formater.numberStyle = .decimal
        var formattedNumber: String?
        formattedNumber = formater.string(from: NSNumber(value: detailItem.population))
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 140%; font-family: "CourierNewPSMT"; color: #ffffff; background-color: #808080;} </style>
        <h3>\(detailItem.name)</h3>
        </head>
        <body>
        <ul>
        <li>Capital: \(detailItem.capital)</li>
        <li>Region: \(detailItem.region)</li>
        <li>Sub Region: \(detailItem.subregion)</li>
        <li>Population: \(formattedNumber!)</li>
        <li>Native Name: \(detailItem.nativeName)</li>
        <img src="\(detailItem.flag)" alt="Flag" height="150" width="200" align="left">
        <ul>
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
}
