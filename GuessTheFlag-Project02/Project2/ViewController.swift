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
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var highScoreLabel: UILabel!
    
    let defaults = UserDefaults.standard
    
    var countries =  [String]()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var correctAnswer = 0
    var questionsAsked  = 0
    var highScore = 0 {
        didSet {
            // Display the high score
            highScoreLabel.text = "High Score: \(highScore)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
       
        button1.layer.borderWidth = 2
        button2.layer.borderWidth = 2
        button3.layer.borderWidth = 2
        
        // set caLayer border color for the border
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        button1.layer.cornerRadius = 5
        button2.layer.cornerRadius = 5
        button3.layer.cornerRadius = 5
   
        askQuestion()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        // shuffle the countries
        countries.shuffle()
        // randomize which flag to select as the question
        correctAnswer = Int.random(in: 0...2)
        
        button1.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        button2.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        button3.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        // display the country name in the title
        title = "Guess The Flag: " + countries[correctAnswer].uppercased()
        
        questionsAsked += 1
    }
    
    func resetGame(action: UIAlertAction! = nil) {
        
        // reset score
        score = 0
        questionsAsked  = 0
        askQuestion()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        var flag: String
        
        // the connected buttons are tagged 0/1/2
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 10
            transform(sender)
        } else {
            flag = countries[sender.tag].uppercased()
            title = "That was the flag for \(flag)"
            score -= 5
        }
        
        let ac: UIAlertController

        if questionsAsked <= 3 {
            ac = UIAlertController(title: title, message: "Let's keep playing!", preferredStyle: .alert)
            // review closure. Continue the game and call askQuestion. The handler askQuestion without parens means here is the method to run BUT askQuestions() will execute the method and it will tell you the method to run... which is not what we want
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        } else {
            
            // load previous saved score
            let savedHighScore = defaults.integer(forKey: "highScore")
            
            print(savedHighScore)
            print(score)
            
            if savedHighScore > score {
                // Display the high score
                highScoreLabel.text = "High Score: \(savedHighScore)"
            } else if score > savedHighScore {
                // we have a new high score
                let ac = UIAlertController(title: "Congratulations", message: "New High Score: \(score)!", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Thanks!", style: .default, handler: resetGame))
                
                present(ac, animated: true)
            }
            
            // save high score
            highScore = score
            defaults.set(highScore, forKey: "highScore")
            
            ac = UIAlertController(title: title, message: "Game Over. Your final score: \(score)!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Play Again?", style: .default, handler: resetGame))
        }
        
        present(ac, animated: true)
    }
    
    func transform(_ sender: UIButton) {
        
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity:2.0, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        })
    }
}

