//
//  ViewController.swift
//  WordScramble
//
//  Created by Alex Perucchini on 4/19/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Game", style: .done, target: self, action: #selector(startGame))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm2"]
        }
        
        startGame()
    }
    
    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            // closure to handle user input
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        let errorTitle: String
        let errorMessage: String
        
        guard let title = title else { return }
        
        if isPossible(word: lowerAnswer) && lowerAnswer != "" {
            if isOriginal(word:lowerAnswer) && lowerAnswer != title.lowercased() {
                if isReal(word: lowerAnswer) {
                    // check for word smaller than or equal to 3 characters
                    if lowerAnswer.utf16.count <= 3 {
                        errorTitle = "Word is too small"
                        errorMessage = "Use a word longer than 3 characters"
                        showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
                    // all good ...
                    } else {
                        usedWords.insert(lowerAnswer, at: 0)
                        // update the row at the top of the tableView
                        let indexPath = IndexPath(row: 0, section: 0)
                        // this is for animation and you don't have to reload the entire tableView
                        tableView.insertRows(at: [indexPath], with: .automatic)
                        // let's get out of the method
                        return
                    }
                } else {
                    // Alert the user that the word is not a real word
                    errorTitle = "Word not recognized"
                    errorMessage = "Use a real word"
                    showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
                }
            } else {
                // Alert the user that the word was already used
                errorTitle = "Word is not original"
                errorMessage = "Be original and use a different word"
                showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
            }
        } else {
            // Alert the user that the word cannot be constructed using the existing letters
            errorTitle = "Word not possible"
            errorMessage = "You cannot spell that word from \(title.lowercased())"
            showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
        }
    }
    // can we build a new word from the existing word?
    func isPossible(word: String) -> Bool {
        // get the original word and make it lower case
        guard var tempWord = title?.lowercased() else { return false }
        // check if each letter in the word used
        for letter in word {
            // get the letter position in the word
            if let position = tempWord.firstIndex(of: letter) {
                // we found the letter and cannot be used again
                tempWord.remove(at: position)
            } else {
                // letter was not found in the word
                return false
            }
        }
        return true
    }
    // did we use the word before?
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    // is the word a valid english word?
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        // utf16 is a legacy Objective C for handling special characters
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        // the word is valid. returns true
        return misspelledRange.location == NSNotFound
    }
    
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
}

