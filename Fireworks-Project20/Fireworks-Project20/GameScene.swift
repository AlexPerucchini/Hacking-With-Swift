//
//  GameScene.swift
//  Fireworks-Project20
//
//  Created by Alex Perucchini on 6/17/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var gameTimer: Timer?
    var fireworks = [SKNode]()
    
    var fireworkObjects = 0
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22
    var scoreLabel: SKLabelNode!
    var explodeLabel: SKLabelNode!
    var newGameLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            // your code here
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Avenir-BlackOblique")
        scoreLabel.position = CGPoint(x: 20, y: 20)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 50
        scoreLabel.zPosition = 1
        scoreLabel.fontColor = UIColor.white
        addChild(scoreLabel)
        
        explodeLabel = SKLabelNode(fontNamed: "Avenir-BlackOblique")
        explodeLabel.position = CGPoint(x: 400, y: 20)
        explodeLabel.horizontalAlignmentMode = .left
        explodeLabel.fontSize = 50
        explodeLabel.zPosition = 1
        explodeLabel.fontColor = UIColor.white
        explodeLabel.text = "Explode!"
        addChild(explodeLabel)
        
        newGameLabel = SKLabelNode(fontNamed: "Avenir-BlackOblique")
        newGameLabel.text = "New Game"
        newGameLabel.horizontalAlignmentMode = .left
        newGameLabel.position = CGPoint(x: 750, y: 20)
        newGameLabel.fontSize = 50
        addChild(newGameLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
        
    }
    
    func createFirework(xMovement: CGFloat, x: Int, y: Int) {
        // 1
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        // 2
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        
        // 3
        switch Int.random(in: 0...2) {
        case 0:
            firework.color = .cyan
            
        case 1:
            firework.color = .green
            
        case 2:
            firework.color = .red
            
        default:
            break
        }
        
        // 4
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        // 5
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 150)
        node.run(move)
        
        // 6
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        
        // 7
        fireworks.append(node)
        addChild(node)
        
        fireworkObjects += 1
        print(fireworkObjects)
        
        if fireworkObjects >= 30 {
            let gameOverSprite = SKSpriteNode(imageNamed: "gameOver")
            gameOverSprite.position = CGPoint(x: 512, y: 384)
            gameOverSprite.zPosition = 1
            addChild(gameOverSprite)
            let scaleUp = SKAction.scale(to: 2.2, duration: 1.0)
            let scaleDown = SKAction.scale(to: 1.0, duration: 1.0)
            
            gameOverSprite.run(SKAction.sequence([scaleUp,scaleDown]))
            
            gameTimer?.invalidate()
        }
        
    }
    
    @objc func launchFireworks() {
        let movementAmount: CGFloat = 1800
        
        switch Int.random(in: 0...3) {
        case 0:
            // fire five, straight up
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)
            
        case 1:
            // fire five, in a fan
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)
            
        case 2:
            // fire five, from the left to the right
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
            
        case 3:
            // fire five, from the right to the left
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
            
        default:
            break
        }
    }
    
    func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        // special for loop
        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "firework" else { continue }
            
            // select fireworks of the same color
            for parent in fireworks {
                // is there a sprite node inside the parent node
                guard let firework = parent.children.first as? SKSpriteNode else { continue }
                
                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
            }
        
            node.name = "selected"
            node.colorBlendFactor = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let objects = nodes(at: location)
        
        if objects.contains(explodeLabel) {
            explodeFireworks()
            print("Explode Fireworks")
        } else if objects.contains(newGameLabel) {
            newGame()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                // this uses a position high above so that rockets can explode off screen
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    
    func explode(firework: SKNode) {
        if let emitter = SKEmitterNode(fileNamed: "explode") {
            emitter.position = firework.position
            addChild(emitter)
        }
        
        firework.removeFromParent()
    }
    
    func explodeFireworks() {
        var numExploded = 0
        
        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else { continue }
            
            if firework.name == "selected" {
                // destroy this firework!
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }
        
        switch numExploded {
        case 0:
            // nothing – rubbish!
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        default:
            score += 4000
        }
        print(score)
    }
    
    func gameOver() {
        
        self.removeAllActions()
        self.removeAllChildren()
        gameTimer?.invalidate()
    }
    
    func newGame() {
        self.removeAllActions()
        self.removeAllChildren()
        
        let newScene = GameScene(size: self.size)
        newScene.scaleMode = self.scaleMode
        let animation = SKTransition.fade(withDuration: 2.0)
        self.view?.presentScene(newScene, transition: animation)
    }
    
//    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
//        guard let skView = view as? SKView else { return }
//        guard let gameScene = skView.scene as? GameScene else { return }
//        gameScene.explodeFireworks()
//        print("exploded")
//    }
}
