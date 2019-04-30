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
    var progressView: UIProgressView!
    var websites = ["google.com", "apple.com", "hackingwithswift.com", "developer.apple.com"]

    override func loadView() {
        webView = WKWebView()
        // we need to add the WKNavigationDelegate to the class in order to prevent compiler errors
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // navigation bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        // flexibleSpace acts a container spring for buttons
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        // create a refresh button for the webView
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let back = UIBarButtonItem(title: "< Back", style: .plain, target: webView, action: #selector(webView.goBack))
        let forward = UIBarButtonItem(title: "Fwd >", style: .plain, target: webView, action: #selector(webView.goForward))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        
        let progressButton = UIBarButtonItem(customView: progressView)
        // load buttons on the toolbar
        toolbarItems = [back, progressButton, forward, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        // we need values for the progress bar
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        // load the default webView
        let url = URL(string: "https:" + websites[0])!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        // used by ipad for anchoring the button
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        // notice the double unwrap(!). We're unwrapping the title and the URL string
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://" + actionTitle) else { return }
        // print(url)
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    // a nice to have is the current web page title in the navigation bar
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    // this is needed to handle the webView observer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    // allow only websites on our list of approved sites. This method calls the decisionHandler closure and
    // expects an allow or cancel response based on the site host
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    // set opacity
                    view.alpha = CGFloat(1.0)
                    // exit the function
                    return
                }
            }
        }
        // site is not allowed
        decisionHandler(.cancel)
        // set opacity
        view.alpha = CGFloat(0.1)
        // alert the user that the site is not in the approved list
        let ac = UIAlertController(title: "The website is not available", message: "This website is not in the current approved list", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
}

