//
//  GameScene.swift
//  Milestone-Project16-18
//
//  Created by Alex Perucchini on 6/10/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    var smokeParticles: SKEmitterNode!
    var newGameLabel: SKLabelNode!
    var gameScore: SKLabelNode!
    let possibleEnemies = ["target1", "target2", "target3"]
    var gameTimer: Timer?
    var timerInterval: Double = 3.0
    
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .orange
        
        gameScore = SKLabelNode(fontNamed: "GillSans-UltraBold")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 50, y: 40)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 50
        gameScore.zPosition = 1
        addChild(gameScore)
        
        let gameLabel = SKLabelNode(fontNamed: "GillSans-UltraBold")
        gameLabel.text = "Lazy Ducky Time"
        gameLabel.horizontalAlignmentMode = .center
        gameLabel.position = CGPoint(x: 550, y: 700)
        gameLabel.fontSize = 60
        gameLabel.zPosition = 1
        addChild(gameLabel)
        
        newGameLabel = SKLabelNode(fontNamed: "GillSans-UltraBold")
        newGameLabel.text = "New Game"
        newGameLabel.horizontalAlignmentMode = .right
        newGameLabel.position = CGPoint(x: 950, y: 40)
        newGameLabel.fontSize = 50
        newGameLabel.zPosition = 1
        addChild(newGameLabel)
        
        player = SKSpriteNode(imageNamed: "cursor")
        player.position = CGPoint(x: 500, y: 390)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.collisionBitMask = 0
        player.zPosition = 1
        addChild(player)
        
        let curtains = SKSpriteNode(imageNamed: "curtains")
        curtains.position = CGPoint(x: 510, y: 375)
        curtains.size = CGSize(width: 1034, height: 770)
        addChild(curtains)
        
        let background = SKSpriteNode(imageNamed: "wood-background")
        background.position = CGPoint(x: 510, y: 440)
        //background.size = CGSize(width: 990, height: 750)
        background.zPosition = -8
        addChild(background)
        
        let land = SKSpriteNode(imageNamed: "grass-trees")
        land.position  = CGPoint(x: 510, y: 380)
        land.size = CGSize(width: 980, height: 380)
        land.zPosition = -6
        addChild(land)
        
        let water = SKSpriteNode(imageNamed: "water-bg")
        water.position  = CGPoint(x: 510, y: 230)
        water.size = CGSize(width: 950, height: 230)
        water.zPosition = -3
        addChild(water)
        
        let water2 = SKSpriteNode(imageNamed: "water-fg")
        water2.position  = CGPoint(x: 510, y: 180)
        water2.size = CGSize(width: 950, height: 180)
        water2.zPosition = -1
        addChild(water2)
        
        let waveToright = SKAction.moveBy(x: -40, y: 0, duration: 1.0)
        let waveToleft = SKAction.moveBy(x: 40, y: 0, duration: 1.0)
        
        water.run(SKAction.repeatForever(SKAction.sequence([waveToleft, waveToright])))
        water2.run(SKAction.repeatForever(SKAction.sequence([waveToright, waveToleft])))
        
        // disable gravity
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self as SKPhysicsContactDelegate
        
        // call gameTimer
        gameTimer = Timer.scheduledTimer(timeInterval: timerInterval , target: self, selector: #selector(createTargets), userInfo: nil, repeats: true)
    }

    func touchMoved(toPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)

        player.position = location
        for node in tappedNodes {
            if node.name == "Ducks" {
                score += 5
                node.removeFromParent()
            
            } else if node.name == "Target" {
                score += 10
                node.removeFromParent()
            }
          
            if node.contains(newGameLabel) {
                newGame()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        if location.y < 80 {
            location.y = 100
        } else if location.y > 700 {
            location.y = 700
        }
        
        player.position = location
        
       
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    @objc func createTargets() {
        guard let enemy = possibleEnemies.randomElement() else { return }
        
        let ducks = SKSpriteNode(imageNamed: enemy)
        
        if Int.random(in: 0...2) == 0 {
            ducks.physicsBody = SKPhysicsBody(texture: ducks.texture!, size: ducks.size)
            ducks.position = CGPoint(x: 10, y: 350)
            ducks.physicsBody?.collisionBitMask = 0
            ducks.zPosition = -4
            
            if Int.random(in: 0...2) == 0 {
                ducks.physicsBody?.velocity = CGVector(dx: 140, dy: 0)
            } else {
                ducks.physicsBody?.velocity = CGVector(dx: 80, dy: 0)
            }
        } else {
            ducks.physicsBody = SKPhysicsBody(texture: ducks.texture!, size: ducks.size)
            ducks.position = CGPoint(x: 1040, y: 280)
            ducks.xScale = -1.0
            ducks.physicsBody?.collisionBitMask = 0
            ducks.zPosition = -2
           
            if Int.random(in: 0...2) == 0 {
                ducks.physicsBody?.velocity = CGVector(dx: -140, dy: 0)
            } else {
                ducks.physicsBody?.velocity = CGVector(dx: -80, dy: 0)
            }
        }

        ducks.name = "Ducks"
        addChild(ducks)
        
        ducks.physicsBody?.linearDamping = 0
        ducks.physicsBody?.angularDamping = 0
        
        let target = SKSpriteNode(imageNamed: "target0")
        target.physicsBody = SKPhysicsBody(texture: ducks.texture!, size: ducks.size)
        target.position = CGPoint(x: 10, y: 470)
        target.physicsBody?.collisionBitMask = 0
        target.physicsBody?.velocity = CGVector(dx: 160, dy: 0)
        target.physicsBody?.angularDamping = 1
        target.zPosition = -7
        target.name = "Target"
        
        addChild(target)
        
        let scaleUp = SKAction.scale(to: 1.8, duration: 1.2)
        let scaleDown = SKAction.scale(to: 0.5, duration: 1.2)
        let scale =  SKAction.scale(to: 0.5, duration: 1.2)
        
        target.run(SKAction.sequence([scaleUp,scaleDown,scale,scaleUp,scaleDown,scale]))
    }
    
    func newGame() {
        self.removeAllActions()
        self.removeAllChildren()
        
        let newScene = GameScene(size: self.size)
        newScene.scaleMode = self.scaleMode
        let animation = SKTransition.fade(withDuration: 2.0)
        self.view?.presentScene(newScene, transition: animation)
    }
}
