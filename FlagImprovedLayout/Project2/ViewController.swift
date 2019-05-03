//
//  ViewController.swift
//  Project2
//
//  Created by Alex Perucchini on 4/11/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var scoreButton: UIBarButtonItem!
    
    var countries =  [String]()
    var score = 0
    var correctAnswer = 0
    var questionsAsked  = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        // set caLayer border color for the border
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        // show the score in the right bar button when tapped
        scoreButton = UIBarButtonItem(title: "Score", style: .done, target: self, action: #selector(shareTapped))
        self.navigationItem.rightBarButtonItem = scoreButton
        
        // not parameters are passed in since the default acttion is nil
        askQuestion()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        // shuffle the countries
        countries.shuffle()
        // randomize which flag to select as the question
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        // display the country name in the title
        title = "Guess the flag: " + countries[correctAnswer].uppercased()
        
        questionsAsked += 1
        print(questionsAsked)
    }
    
    func resetGame(action: UIAlertAction! = nil) {
        score = 0
        questionsAsked  = 0
        askQuestion()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        var flag: String
        
        // reset the rightBarButtonTitle
        scoreButton.title = "Score"
        
        // the connected buttons are tagged 0/1/2
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 100
        } else {
            flag = countries[sender.tag].uppercased()
            title = "That was the flag for \(flag)"
            score -= 100
        }
        
        let ac: UIAlertController

        if questionsAsked <= 10 {
            ac = UIAlertController(title: title, message: "Let's keep playing!", preferredStyle: .alert)
            
            // review closure. Continue the game and call askQuestion. The handler askQuestion without parens means here is the method to run BUT askQuestions() will execute the method and it will tell you the method to run... which is not what we want
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        } else {
            ac = UIAlertController(title: title, message: "Game Over. Your final score: \(score)!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Play Again?", style: .default, handler: resetGame))
        }
        
        present(ac, animated: true)
    }
    
    @objc func shareTapped() {
        // refactor to an alert action
        scoreButton.title = "\(score)"
    }
}

