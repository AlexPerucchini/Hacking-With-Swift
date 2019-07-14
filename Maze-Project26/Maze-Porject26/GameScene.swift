//
//  GameScene.swift
//  Maze-Porject26
//
//  Created by Alex Perucchini on 7/8/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK:- Variables
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    var teleport2:CGPoint?
    var motionManager: CMMotionManager!
    var scoreLabel: SKLabelNode!
    var levelLabel: SKLabelNode!
    var newGameLabel: SKLabelNode!
    var isGameOver = false

    var score = 0 {
        didSet {
            scoreLabel.text = "Bits: \(score)"
        }
    }
    
    var  level = 0 {
        didSet {
            levelLabel.text = "Level: \(level)"
        }
    }
    
    enum CollisionTypes: UInt32 {
        case player = 1
        case wall = 2
        case star = 4
        case vortex = 8
        case finish = 16
        case teleport = 32 
    }

    // MARK: - Functions
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "AppleSDGothicNeo-Medium")
        scoreLabel.text = "Bits: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        scoreLabel.fontSize = 40 
        addChild(scoreLabel)
        
        levelLabel = SKLabelNode(fontNamed: "AppleSDGothicNeo-Medium")
        levelLabel.text = "Level: 1"
        levelLabel.horizontalAlignmentMode = .left
        levelLabel.position = CGPoint(x: 200, y: 16)
        levelLabel.zPosition = 2
        levelLabel.fontSize = 40
        addChild(levelLabel)
        
        newGameLabel = SKLabelNode(fontNamed: "AppleSDGothicNeo-Medium")
        newGameLabel.text = "RESET"
        newGameLabel.horizontalAlignmentMode = .left
        newGameLabel.position = CGPoint(x: 900, y: 16)
        newGameLabel.zPosition = 2
        newGameLabel.fontSize = 40
        addChild(newGameLabel)
        
        
        // set the world's gravity to zero
        physicsWorld.gravity = .zero
        // allow contact bodies
        physicsWorld.contactDelegate = self
        
        // coreMotion accellerometer data
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        
        loadLevel(level: "level1")
        
        createPlayer()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // ghost collisions we're not sure what collision occured
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 96, y: 730)
        // make the players node appear in front of the other nodes
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        addChild(player)
    }

    
    func loadLevel(level: String) {
    
        guard let levelURL = Bundle.main.url(forResource: level, withExtension: "txt") else {
            // always use fatal error
            fatalError("Could not find \(level) in the app bundle.")
        }
        
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Could not load \(level) from the app bundle.")
        }
      
        print("IN LEVEL: \(level)")
        
        var lines = [String]()
        lines.removeAll()
        lines = levelString.components(separatedBy: "\n")
        
        // The categoryBitMask property is a number defining the type of object this is for considering collisions.
        // The collisionBitMask property is a number defining what categories of object this node should collide with,
        // The contactTestBitMask property is a number defining which collisions we want to be notified about.
        print(lines)
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                // +32 if to offset for the centering that spritekit applies
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                
                if letter == "x" {
                    // load wall
                    loadWall(position)
                } else if letter == "v"  {
                    // load vortex
                    loadVortex(position)
                } else if letter == "s"  {
                    // load star
                    loadStar(position)
                } else if letter == "f"  {
                    // load finish
                    loadFinish(position)
                    
                } else if letter == "t" {
                    // load teleport
                    loadTeleport1(position)
                } else if letter == "u" {
                    // load teleport
                    loadTeleport2(position)
                    teleport2 = position
                }
                else if letter == " " {
                    // this is an empty space – do nothing!
                } else {
                    fatalError("Unknown level letter: \(letter)")
                }
            }
        }
    }
    
    func loadFinish(_ position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "finish")
        node.name = "finish"
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        node.zPosition = 1
        addChild(node)
    }
    
    func loadStar(_ position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "star")
        node.name = "star"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        addChild(node)
    }
    
    func loadWall(_ position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "block")
        node.position = position
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        node.physicsBody?.isDynamic = false
        addChild(node)
    }
    
    func loadVortex(_ position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "vortex")
        node.name = "vortex"
        node.position = position
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1.5)))
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    
    func loadTeleport1(_ position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "teleport1")
        node.name = "teleport1"
        node.position = position
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1.5)))
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.teleport.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    
    func loadTeleport2(_ position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "teleport2")
        node.name = "teleport2"
        node.position = position
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1.5)))
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.teleport.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    
    func newGame() {
        self.removeAllActions()
        self.removeAllChildren()
        
        let newScene = GameScene(size: self.size)
        newScene.scaleMode = self.scaleMode
        let animation = SKTransition.fade(withDuration: 2.0)
        self.view?.presentScene(newScene, transition: animation)
    }
    
    // hack this is to simulate the iPad accelarometer
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
        
        let tappedNodes = nodes(at: location)
        
        if tappedNodes.contains(newGameLabel) {
            newGame()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) { [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
            
        } else if node.name == "teleport1" {
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let move = SKAction.move(to: teleport2!, duration: 0.25)
            let scaleUp = SKAction.scale(to: 1.0, duration: 0.25)
        
            let sequence = SKAction.sequence([scale, move, scaleUp])
            
            player.run(sequence)
        
        } else if node.name == "star" {
            node.removeFromParent()
            score += 10
        } else if node.name == "finish" {
            
            if level <= 2 {
                print("here")
                let move = SKAction.move(to: node.position, duration: 0.25)
                let scale = SKAction.scale(to: 0.0001, duration: 0.25)
                let remove = SKAction.removeFromParent()
                let sequence = SKAction.sequence([move, scale, remove])
                player.run(sequence)
                
    
                loadLevel(level: "level2")
                level = 2
                score += 100
                createPlayer()
            
            } else {
                newGame()
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }
        
        #if targetEnvironment(simulator) // simulator only code
        if let currentTouch = lastTouchPosition {
            let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else // executes only on a real device
        if let accelerometerData = motionManager.accelerometerData {
            // flip the coordinates for landscape mode
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
        #endif
    }
}
