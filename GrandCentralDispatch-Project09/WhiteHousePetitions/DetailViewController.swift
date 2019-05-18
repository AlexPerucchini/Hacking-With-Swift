//
//  DetailViewController.swift
//  WhiteHousePetitions
//
//  Created by Alex Perucchini on 5/6/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem = detailItem else { return }
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 100%; font-family: "CourierNewPSMT" } </style>
        <h3>\(detailItem.title)</h3>
        </head>
        <body>
        \(detailItem.body)
        </body>
        </footer><p>Signatures: \(detailItem.signatureCount)</footer>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
}
