//
//  ViewController.swift
//  HangMan
//
//  Created by Alex Perucchini on 5/13/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var scoreLabel: UILabel!
    var errorLabel: UILabel!
    var currentAnswer: UITextField!
    var letterButtons = [UIButton]()
    var allWords = [String]()
    var hangManImage: UIImageView!
    var answer: String = ""
    var errors = 0 {
        didSet {
            errorLabel.text = "Errors: \(errors)/4"
        }
    }
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        // score label
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.font = UIFont(name: "AmericanTypewriter", size: 20)
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        // hangman image
        let image: UIImage = UIImage(named:"hg-1.png")!
        hangManImage = UIImageView(image: image)
        hangManImage.translatesAutoresizingMaskIntoConstraints = false
        hangManImage.contentMode = .scaleAspectFit
        view.addSubview(hangManImage)
        
        // error label
        errorLabel = UILabel()
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.font = UIFont(name: "AmericanTypewriter", size: 20)
        errorLabel.textAlignment = .right
        errorLabel.text = "Errors: 0/4"
        view.addSubview(errorLabel)
        
        // current answer
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Guess the word."
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont(name: "AmericanTypewriter", size: 30)
        currentAnswer.isUserInteractionEnabled = false
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("Submit", for: .normal)
        submit.titleLabel?.font = UIFont(name: "AmericanTypewriter", size: 20)
        // connect the button to the view
        submit.addTarget(self, action: #selector(submitTapped(_:)), for: .touchUpInside)
        submit.layer.cornerRadius = 10
        submit.setTitleColor(.white, for: .normal)
        submit.layer.backgroundColor = UIColor.darkGray.cgColor
        submit.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        // connect the button to the view
        clear.addTarget(self, action: #selector(clearTapped(_:)), for: .touchUpInside)
        clear.setTitle("Clear", for: .normal)
        clear.titleLabel?.font = UIFont(name: "AmericanTypewriter", size: 20)
        clear.layer.cornerRadius = 10
        clear.setTitleColor(.white, for: .normal)
        clear.layer.backgroundColor = UIColor.darkGray.cgColor
        clear.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(clear)
        
        // container view for the buttons
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.backgroundColor = UIColor.darkGray.cgColor
        buttonsView.layer.cornerRadius = 20
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 5),
            scoreLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 5),
            errorLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 5),
            errorLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 5),
            // hangMan image
            hangManImage.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 20),
            hangManImage.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            hangManImage.widthAnchor.constraint(equalToConstant: 200),
            hangManImage.heightAnchor.constraint(equalToConstant: 200),
            // currentAnswer
            currentAnswer.topAnchor.constraint(equalTo: hangManImage.bottomAnchor, constant: 20),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor),
            // submit
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 20),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -50),
            submit.heightAnchor.constraint(equalToConstant: 44),
            submit.widthAnchor.constraint(equalToConstant: 70),
            // clear
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 50),
            clear.heightAnchor.constraint(equalTo: submit.heightAnchor),
            clear.widthAnchor.constraint(equalTo: submit.widthAnchor),
            // button view container
            buttonsView.heightAnchor.constraint(equalToConstant: 300),
            buttonsView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 10),
            buttonsView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -10),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 50),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -50)
        ])
        
        // set some values for the width and height of each button
        let width =  60
        let height = 60
        // create 20 buttons as a 4x5 grid
        for row in 0..<5 {
            for col in 0..<6 {
                // create a new button and give it a big font size
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont(name: "AmericanTypewriter", size: 35)
                letterButton.setTitleColor(.white, for: .normal)
                // connect button to letterTapped
                letterButton.addTarget(self, action: #selector(letterTapped(_:)), for: .touchUpInside)
                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                // and also to our letterButtons array
                letterButtons.append(letterButton)
                // add it to the buttons view
                buttonsView.addSubview(letterButton)
            }
        }
        // set letter button titles
        let alphabet = Array("abcdefghijklmnopqrstuvwxyz")
        for (i, ch) in alphabet.enumerated() {
            letterButtons[i].setTitle("\(ch)", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // game info button
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(gameInfo), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
        
        // reset Game
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "NewGame", style: .plain, target: self, action: #selector(resetGame))

        answer = loadData()
        title = answer.masked
    }
    
    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""
    }
    
    @objc func submitTapped(_ sender: UIButton) {
        title = answer.masked
        guard let answerText = currentAnswer.text else { return }
        
        if answer == answerText {
            title = answer + "!"
            score += 10
            
            let ac = UIAlertController(title: "Woot!", message: "You got the correct answer: \(answer)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Select 'New Game' to play again.", style: .default, handler: nil))
            present(ac, animated: true)
            
        } else if errors <= 3 {

            switch errors {
                case 1:
                    hangManImage.image = UIImage(named: "hg-2")
                case 2:
                    hangManImage.image = UIImage(named: "hg-3")
                case 3:
                    hangManImage.image = UIImage(named: "hg-4")
                default:
                    hangManImage.image = UIImage(named: "hg-1")
            }
            
            score -= 1
            errors += 1
            
            let ac = UIAlertController(title: "Whoops!", message: "Not correct keep trying!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
            present(ac, animated: true)
                
        } else {
            
            hangManImage.image = UIImage(named: "hg-5")
            
            let ac = UIAlertController(title: "DEAD!", message: "You lost the game :(!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Select 'NewGame' to play again.", style: .default, handler: nil))
            present(ac, animated: true)
        }
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
    }

    func loadData() -> String {
        if let startWordsURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        let allWordsShuffled = allWords.shuffled()
        let word = allWordsShuffled[0]
        
        print(word)
        return word
    }
    
    @objc func gameInfo() {
        let ac = UIAlertController(title: "How to play...", message: "hangman is a guessing game where a player tries to guess a word within a certain number of tries. Correct answers are worth 10 points, and wrong answers will set you back! Think fast and try not to make mistakes.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Sweet, let's play!", style: .default))
        present(ac, animated: true)
    
    }
    
    @objc func resetGame(_ sender: UIButton) {
        score = 0
        errors = 0
        currentAnswer.text = ""
        answer = loadData()
        title = answer.masked
        hangManImage.image = UIImage(named: "hg-1")
    }
}

extension StringProtocol {
    var masked: String {
        return String(repeating: "•", count: Swift.max(0, count-3)) + suffix(3)
    }
}


