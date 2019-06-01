//
//  GameScene.swift
//  Whack-Pinguin-Project14
//
//  Created by Alex Perucchini on 5/29/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene {
 
    var gameScore: SKLabelNode!
    var highScore: SKLabelNode!
    var newGameLabel: SKLabelNode!
    var numRounds = 0
    var popupTime = 0.85
    var slots = [WhackSlot]()
    let defaults = UserDefaults.standard
    
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        startMessage()
    
        let background = SKSpriteNode(imageNamed: "whackBackground") 
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        let savedHighScore = defaults.integer(forKey: "highScore")
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 10, y: 15)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 40
        addChild(gameScore)
        
        highScore = SKLabelNode(fontNamed: "Chalkduster")
        highScore.text = "HighScore: \(savedHighScore)"
        highScore.position = CGPoint(x: 512, y: 15)
        highScore.horizontalAlignmentMode = .center
        highScore.fontSize = 40
        addChild(highScore)
        
        newGameLabel = SKLabelNode(fontNamed: "Chalkduster")
        newGameLabel.text = "NewGame"
        newGameLabel.horizontalAlignmentMode = .left
        newGameLabel.position = CGPoint(x: 780, y: 15)
        newGameLabel.fontSize = 40
        addChild(newGameLabel)
        
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }
    
        createEnemy()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
            if !whackSlot.isVisible { continue }
            if whackSlot.isHit { continue }
            // we got a waack!
            whackSlot.hit()
            if node.name == "charFriend" {
                // they shouldn't have whacked this penguin
                score -= 5
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion:false))
            } else if node.name == "charEnemy" {
                // they should have whacked this one
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                
                score += 5
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            }
        }
        
        let objects = nodes(at: location)
        
        if objects.contains(newGameLabel) {
            newGame()
        }
    }
    
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    func createEnemy() {
        numRounds += 1
        
        if numRounds >= 15 {
            for slot in slots {
                slot.hide()
            }
            
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
            let scaleUp = SKAction.scale(to: 2.2, duration: 1.0)
            let rotate = SKAction.rotate(byAngle: 25, duration: 0.5)
            let scaleDown = SKAction.scale(to: 1.0, duration: 1.0)
            
            gameOver.run(SKAction.sequence([rotate,scaleUp,scaleDown]))
            
            // grab high score and compare
            let savedHighScore = defaults.integer(forKey: "highScore")
            
            if score > savedHighScore {
                // Display the high score
                highScore.text = "High Score: \(score)"
            } else if savedHighScore >=  score{
                highScore.text = "High Score: \(savedHighScore)"
            }
            print("saved HS: \(savedHighScore)")
            // without this return createEnemy gets called again!
            print(score)
            
            // save high score to disk
            let hscore = score
            if hscore > 0 {
                defaults.set(hscore, forKey: "highScore")
            }
            return
            
        }
        popupTime *= 0.991 // make popuptime get faster and faster
        
        slots.shuffle()
        slots[0].show(hideTime: popupTime)
        // randomize which slot to show
        if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 8 {  slots[2].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: popupTime)  }
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
        
        // GCD grand central dispatch
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            [weak self] in
            self?.createEnemy()
        }
    }
    
    func newGame() {
        self.removeAllActions()
        self.removeAllChildren()
        
        let newScene = GameScene(size: self.size)
        newScene.scaleMode = self.scaleMode
        let animation = SKTransition.fade(withDuration: 2.0)
        self.view?.presentScene(newScene, transition: animation)
    }
    
    func startMessage() {
        let startScreen = SKLabelNode(fontNamed: "ChalkDuster")
        startScreen.text = "WHACK!"
        startScreen.fontSize = 100
        startScreen.position = CGPoint(x: 512, y: 384)
        startScreen.zPosition = 1
        addChild(startScreen)
        let scaleUp = SKAction.scale(to: 2.2, duration: 1.0)
        let rotate = SKAction.rotate(byAngle: 25, duration: 0.5)
        let scaleDown = SKAction.scale(to: 0.5, duration: 1.0)
        let fade = SKAction.fadeOut(withDuration: 1.0)
        // without this return createEnemy gets called again!
        startScreen.run(SKAction.sequence([rotate,scaleUp,scaleDown, fade]))
    }
}
