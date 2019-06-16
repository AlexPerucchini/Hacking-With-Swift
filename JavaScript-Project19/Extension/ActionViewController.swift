//
//  ActionViewController.swift
//  Extension
//
//  Created by Alex Perucchini on 6/13/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Select JS", style: .plain, target: self, action: #selector(openTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        // notify when the keyboard changes
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) {
                    [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    print(javaScriptValues)
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    // another closure
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }
                }
            }
        }
    }
    
    /*
     Calling completeRequest(returningItems:) on our extension context will cause the extension to be closed, returning back to the parent app. However, it will pass back to the parent app any items that we specify, which in the current code is the same items that were sent in.
     
     In a Safari extension like ours, the data we return here will be passed in to the finalize() function in the Action.js JavaScript file, so we're going to modify the done() method so that it passes back the text the user entered into our text view.
     
     To make this work, we need to:
     
     - Create a new NSExtensionItem object that will host our items.
     - Create a dictionary containing the key "customJavaScript" and the value of our script.
     - Put that dictionary into another dictionary with the key NSExtensionJavaScriptFinalizeArgumentKey.
     - Wrap the big dictionary inside an NSItemProvider object with the type identifier kUTTypePropertyList.
     - Place that NSItemProvider into our NSExtensionItem as its attachments.
     - Call completeRequest(returningItems:), returning our NSExtensionItem.
    */

    @IBAction func done(action: UIAlertAction) {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text ?? ""]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        
        extensionContext?.completeRequest(returningItems: [item])
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        //get the size of the keyboard
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        // covert the size in case the device is landscape or rotated
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "Select JavaScript Sample...", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Alert", style: .default, handler: setScript))
        ac.addAction(UIAlertAction(title: "JSDateTime", style: .default, handler: setScript))
        ac.addAction(UIAlertAction(title: "BackgroundColors", style: .default, handler: setScript))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        
        present(ac, animated: true)
    }
    
    @objc func setScript(action: UIAlertAction) {
        if action.title == "Alert" {
            script.text = """
            // press the Done button to run
            var msg = document.title + " " + document.URL
            alert(msg)
            """
        } else if action.title == "JSDateTime" {
            script.text = """
            // press the Done button to run
            var today= new Date()
            alert(today)
            """
        } else if action.title == "BackgroundColors" {
            script.text = """
            // press the Done button to run
            setTimeout("document.bgColor='white'", 1000)
            setTimeout("document.bgColor='lightpink'", 1500)
            setTimeout("document.bgColor = 'pink'", 2000)
            setTimeout("document.bgColor =  'deeppink'", 2500)
            setTimeout("document.bgColor = 'red'", 3000)
            setTimeout("document.bgColor = 'tomato'", 3500)
            setTimeout("document.bgColor = 'darkred'", 4000)
            setTimeout("document.bgColor='white'", 4500)
            setTimeout("document.bgColor='lightpink'", 5000)
            setTimeout("document.bgColor = 'pink'", 5500)
            setTimeout("document.bgColor =  'deeppink'", 6000)
            setTimeout("document.bgColor = 'red'", 6500)
            setTimeout("document.bgColor = 'tomato'", 7000)
            setTimeout("document.bgColor = 'darkred'", 7500)
            """
        }
    }
}
