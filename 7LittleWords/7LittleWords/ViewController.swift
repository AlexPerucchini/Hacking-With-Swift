//
//  ViewController.swift
//  7LittleWords
//
//  Created by Alex Perucchini on 5/9/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var levelLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    //property observer
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    var success = 0

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        // score label
        levelLabel = UILabel()
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.font = UIFont.systemFont(ofSize: 20)
        levelLabel.textAlignment = .right
        levelLabel.text = "Level: 1"
        view.addSubview(levelLabel)
        // score label
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.font = UIFont.systemFont(ofSize: 20)
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        // Clues
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text =  "CLUES"
        cluesLabel.numberOfLines = 0
        // we need to be able to stretch and compress the view as needed
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        // answer label
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.numberOfLines = 0
        answersLabel.textAlignment = .right
        // we need to be able to stretch and compress the view as needed
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        // current answer
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess!"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("Submit", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped(_:)), for: .touchUpInside)
        submit.layer.cornerRadius = 10
        submit.setTitleColor(.white, for: .normal)
        submit.layer.backgroundColor = UIColor.darkGray.cgColor
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.addTarget(self, action: #selector(clearTapped(_:)), for: .touchUpInside)
        clear.setTitle("Clear", for: .normal)
        clear.layer.cornerRadius = 10
        clear.setTitleColor(.white, for: .normal)
        clear.layer.backgroundColor = UIColor.darkGray.cgColor
        view.addSubview(clear)
        
        let reset = UIButton(type: .system)
        reset.translatesAutoresizingMaskIntoConstraints = false
        reset.addTarget(self, action: #selector(resetGame), for: .touchUpInside)
        reset.setTitle("Reset Game", for: .normal)
        reset.setTitleColor(.white, for: .normal)
        reset.layer.cornerRadius = 10
        reset.layer.backgroundColor = UIColor.darkGray.cgColor
        view.addSubview(reset)
        
        
        // container view for the buttons
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            reset.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 5),
            reset.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 5),
            reset.widthAnchor.constraint(equalToConstant: 100),
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 5),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            levelLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 5),
            levelLabel.trailingAnchor.constraint(equalTo: scoreLabel.trailingAnchor, constant: -100),
            // pin the top of the clues label to the bottom of the score label
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            // pin the leading edge of the clues label to the leading edge of our layout margins, adding 100 for some space
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 150),
            // make the clues label 60% of the width of our layout margins, minus 100 to account for the leading
            // edge margin
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            // also pin the top of the answers label to the bottom of the score label
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            // make the answers label stick to the trailing edge of our layout margins, minus 100
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -150),
            // make the answers label take up 40% of the available space, minus 100
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            // make the answers label match the height of the clues label
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            // currentAnswer
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
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
            buttonsView.widthAnchor.constraint(equalToConstant: 770 ),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 50),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -50)
            ])
        
        // set some values for the width and height of each button
        let width = 150
        let height = 80
        
        // create 20 buttons as a 4x5 grid
        for row in 0..<4 {
            for col in 0..<5 {
                // create a new button and give it a big font size
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitleColor(.white, for: .normal)
                letterButton.layer.backgroundColor = UIColor.darkGray.cgColor
                letterButton.titleEdgeInsets = UIEdgeInsets(top: 20,left: 20,bottom: 20,right: 20)
                // connect button to letterTapped
                letterButton.addTarget(self, action: #selector(letterTapped(_:)), for: .touchUpInside)
                // give the button some temporary text so we can see it on-screen
                letterButton.setTitle("WWW", for: .normal)
                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                // add it to the buttons view
                buttonsView.addSubview(letterButton)
                // and also to our letterButtons array
                letterButtons.append(letterButton)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLevel()
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
    }
    
    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else { return }
        
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()
        
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            
            currentAnswer.text = ""
            score += 1
            success += 1
    
            if success == 7 {
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        } else {
            // submited answer is not part of the solution text
            let ac = UIAlertController(title: "Ooopsy", message: "Not correct keep trying!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
            present(ac, animated: true)
            score -= 1
        }
    }
    
    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""
        
        for button in activatedButtons {
            button.isHidden = false
        }
        activatedButtons.removeAll()
    }
    
    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        
        // trim out white spaces in clues and answer
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterBits.shuffle()
        
        // count letter bits to letter buttons and set buttons titles
        if letterBits.count == letterButtons.count {
            for i in 0 ..< letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
    
    func levelUp(action: UIAlertAction) {
        level += 1
        levelLabel.text = "Level: \(level)"
        
        solutions.removeAll(keepingCapacity: true)
        
        loadLevel()
        
        for btn in letterButtons {
            btn.isHidden = false
        }
    }
    
    @objc func resetGame() {
        level = 1
        levelLabel.text = "Level: \(level)"
        solutions.removeAll(keepingCapacity: false)
        loadLevel()
        
        for btn in letterButtons {
            btn.isHidden = false
        }
    }
}
