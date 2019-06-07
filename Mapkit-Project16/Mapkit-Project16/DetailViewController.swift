//
//  DetailViewController.swift
//  Mapkit-Project16
//
//  Created by Alex Perucchini on 6/6/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var website:String?
    var city: String?
    
    override func loadView() {
        webView = WKWebView()
        
        view = webView
        navigationItem.largeTitleDisplayMode  = .never
       
        if city!.contains("Washington DC") {
            city = "Washington,_D.C."
        }
        
        if let url = URL(string: "https://en.wikipedia.org/wiki/" + city!) {
            let request = URLRequest(url: url)
            webView.load(request)
            webView.allowsBackForwardNavigationGestures = true
        }
    
    }
}

