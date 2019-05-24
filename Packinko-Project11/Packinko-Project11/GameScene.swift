//
//  GameScene.swift
//  Packinko-Project11
//
//  Created by Alex Perucchini on 5/18/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    var editlabel:  SKLabelNode!
    var clearLabel: SKLabelNode!
    var ballsLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editlabel.text = "Done"
            } else {
                editlabel.text = "Edit"
            }
        }
    }
    
    var ballsLeft = 5 {
        didSet {
            ballsLabel.text = "Balls Left: \(ballsLeft)"
            
            if ballsLeft == 0 {
                newGame()
            }
        }
    }
    
    override func didMove(to view: SKView) {
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        ballsLabel = SKLabelNode(fontNamed: "Chalkduster")
        ballsLabel.text = "Balls left: 5"
        ballsLabel.horizontalAlignmentMode = .right
        ballsLabel.position = CGPoint(x: 980, y: 650)
        addChild(ballsLabel)
        
        editlabel = SKLabelNode(fontNamed: "Chalkduster")
        editlabel.text = "Edit"
        editlabel.horizontalAlignmentMode = .left
        editlabel.position = CGPoint(x: 30, y: 700)
        addChild(editlabel)
        
        clearLabel = SKLabelNode(fontNamed: "Chalkduster")
        clearLabel.text = "Clear"
        clearLabel.horizontalAlignmentMode = .left
        clearLabel.position = CGPoint(x: 30, y: 650)
        addChild(clearLabel)
        
        
        let background = SKSpriteNode(imageNamed: "background.jpg")
        // these are the best CGPoint for iPad
        background.position = CGPoint(x: 512, y: 384)
        // ignore transparancy makes it faster
        background.blendMode = .replace
        // place it in the background
        background.zPosition = -1
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        //assign the current scene to be the physics world's contact delegate
        physicsWorld.contactDelegate = self
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)

        makeBouncer(at: CGPoint(x: 300, y: 400))
        makeBouncer(at: CGPoint(x: 512, y: 250))
        makeBouncer(at: CGPoint(x: 512, y: 550))
        makeBouncer(at: CGPoint(x: 700, y: 400))
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        // find where the touch was in the game scene
        var location = touch.location(in: self)
        
        // check to see if the editLabel was tapped
        let objects = nodes(at: location)
        
        if objects.contains(clearLabel) {
            newGame()
            
        } else if objects.contains(editlabel) {
            // switch to edit mode
            editingMode.toggle()
            
        } else {
            if editingMode {
                /* we're going to use a new property on nodes called zRotation. When creating the background image, we gave it a Z position, which adjusts its depth on the screen, front to back. If you imagine sticking a skewer through the Z position – i.e., going directly into your screen – and through a node, then you can imagine Z rotation: it rotates a node on the screen as if it had been skewered straight through the screen.
                 
                 To create randomness we’re going to be using both Int.random(in:) for integer values and CGFloat.random(in:) for CGFloat values, with the latter being used to create random red, green, and blue values for a UIColor
                 */
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                box.name = "box"
                
                addChild(box)
                
            } else {
                let balls = ["ballRed", "ballBlue", "ballPurple", "ballCyan", "ballYellow"]
                let ballColor = balls.shuffled().first
                let ball  = SKSpriteNode(imageNamed: ballColor!)
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                // The collisionBitMask bitmask means "which nodes should I bump into?" By default, it's set to everything, which is why our ball are already hitting each other and the bouncers. The contactTestBitMask bitmask means "which collisions do you want to know about?" and by default it's set to nothing. So by setting contactTestBitMask to the value of collisionBitMask we're saying, "tell me about every collision."
                ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
                // bounciness the higher the value the more bounce
                ball.physicsBody?.restitution  = 0.4
                // randomize entry point
                // let xRandPos = CGFloat.random(in: 100...1000)
                // ball.position = CGPoint(x: xRandPos, y: 760)
                // we want the ball location to start at the top y axis and not below 760
                if location.y < 760 {
                    location.y = 760
                }
                print("\(location)")
                ball.position = location
                // Apple recommends assigning names to your nodes, then checking the name to see what node it is
                ball.name = "ball"
                
                addChild(ball)
            }
        }
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.restitution  = 1.0
        // the bouncer object will be fixed in place
        bouncer.physicsBody?.isDynamic = false
        
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        var spin: SKAction
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
            spin = SKAction.rotate(byAngle: .pi, duration: 20)
            
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
            spin = SKAction.rotate(byAngle: .pi, duration: 3)
            
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        // spin effect
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
        
        addChild(slotBase)
        addChild(slotGlow)
    }
    
    /* when contact between two physics bodies occurs, we don't know what order it will come in. That is, did the ball hit the slot, did the slot hit the ball, or did both happen? I know this sounds like pointless philosophy, but it's important because we need to know which one is the ball!
     
     Before looking at the actual contact method, I want to look at two other methods first, because this is our ultimate goal. The first one, collisionBetween() will be called when a ball collides with something else. The second one, destroy() is going to be called when we're finished with the ball and want to get rid of it.
     */
    
    /* there is a roblem with this version:
     func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "ball" {
            collisionBetween(ball: contact.bodyA.node!, object: contact.bodyB.node!)
        } else if contact.bodyB.node?.name == "ball" {
            collisionBetween(ball: contact.bodyB.node!, object: contact.bodyA.node!)
        }
     }
     The first time that code runs, we force unwrap both nodes and remove the ball – so far so good. The second time that code runs (for the other half of the same collision), our problem strikes: we try to force unwrap something we already removed, and our game will crash.
     
     To solve this, we’re going to rewrite the didBegin() method to be clearer and safer: we’ll use guard to ensure both bodyA and bodyB have nodes attached. If either of them don’t then this is a ghost collision and we can bail out immediately.
     */
    func didBegin(_ contact: SKPhysicsContact) {
        guard let bodyA = contact.bodyA.node else { return }
        guard let bodyB = contact.bodyB.node else { return }
        
        // print("bodyA \(String(describing: bodyA.name))")
        // print("bodyB \(String(describing: bodyB.name))")
        
        if bodyA.name == "ball" {
            collisionBetween(ball: contact.bodyA.node!, object: contact.bodyB.node!)
        } else if bodyB.name == "ball" {
            collisionBetween(ball: contact.bodyB.node!, object: contact.bodyA.node!)
        } else if bodyA.name == "box" {
            collisionBetween(ball: contact.bodyB.node!, object: contact.bodyA.node!)
        }
    }

    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            ballsLeft += 1
            score += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            ballsLeft -= 1
            score -= 1
        } else if object.name == "box" {
            destroyBox(box: object)
        }
    }
    
    func destroyBox(box: SKNode) {
        if let smokeParticles = SKEmitterNode(fileNamed: "smoke") {
            smokeParticles.position = box.position
            addChild(smokeParticles)
        }
        
        box.removeFromParent()
    }
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        
        ball.removeFromParent()
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

