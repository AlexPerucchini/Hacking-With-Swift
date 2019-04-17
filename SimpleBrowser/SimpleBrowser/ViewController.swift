//
//  ViewController.swift
//  SimpleBrowser
//
//  Created by Alex Perucchini on 4/17/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!

    override func loadView() {
        webView = WKWebView()
        // we need to add the WKNavigationDelegate to the class in order ot prevent
        // compiler error
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://hackingwithswift.com")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}

