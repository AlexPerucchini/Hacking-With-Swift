//
//  GameScene.swift
//  Space-Project17
//
//  Created by Alex Perucchini on 6/7/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    let possibleEnemies = ["ball", "hammer", "tv"]
    var objectCount: Int = 0
    var isGameOver = false
    var gameTimer: Timer?
    var timerInterval: Double = 1.0
    var scoreLabel: SKLabelNode!
    var debrisLabel: SKLabelNode!
    var newGameLabel: SKLabelNode!
    var debrisCount: Int = 0 {
        didSet {
            debrisLabel.text = "Debris: \(debrisCount)"
        }
    }
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: 1024, y: 400)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        debrisLabel = SKLabelNode(fontNamed: "Chalkduster")
        debrisLabel.position = CGPoint(x: 250, y: 16)
        debrisLabel.horizontalAlignmentMode = .left
        addChild(debrisLabel)
        
        newGameLabel = SKLabelNode(fontNamed: "Chalkduster")
        newGameLabel.text = "NewGame"
        newGameLabel.horizontalAlignmentMode = .left
        newGameLabel.position = CGPoint(x: 780, y: 16)
        newGameLabel.fontSize = 40
        addChild(newGameLabel)
        
        // set debris and score
        score = 0
        debrisCount = 0
        
        // disable gravity
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: timerInterval , target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        if location.y < 80 {
            location.y = 80
        } else if location.y > 730 {
            location.y = 730
        }
        
        player.position = location
        
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let objects = nodes(at: location)
        
        if objects.contains(newGameLabel) {
            newGame()
        }
    }
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        
        gameTimer?.invalidate()
        
        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        gameOver.position = CGPoint(x: 512, y: 384)
        gameOver.zPosition = 1
        addChild(gameOver)
        let scaleUp = SKAction.scale(to: 2.2, duration: 1.0)
        let scaleDown = SKAction.scale(to: 1.0, duration: 1.0)
        
        gameOver.run(SKAction.sequence([scaleUp,scaleDown]))
        
        isGameOver = true
    }
    
    @objc func createEnemy() {
        guard let enemy = possibleEnemies.randomElement() else { return }
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        // the debris will never slow down
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        
        objectCount += 1
        debrisCount += 1
        print("object before loop : \(objectCount)")
        
        if objectCount >= 20 {
            objectCount = 0
            timerInterval -= 0.1
            
            // invalidate the previous gametimer set the new gamertimer
            gameTimer?.invalidate()
            gameTimer = Timer.scheduledTimer(timeInterval: timerInterval , target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        }
        print("interval: \(timerInterval)")
    }
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        if !isGameOver {
            score += 1
        }
    }
    
    func newGame() {
        self.removeAllActions()
        self.removeAllChildren()
        gameTimer?.invalidate()
        
        let newScene = GameScene(size: self.size)
        newScene.scaleMode = self.scaleMode
        let animation = SKTransition.fade(withDuration: 2.0)
        self.view?.presentScene(newScene, transition: animation)
    }
}
