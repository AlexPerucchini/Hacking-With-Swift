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
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background.jpg")
        // these are the best CGPoint for iPad
        background.position = CGPoint(x: 385, y: 330 )
        // ignore transparancy makes it faster
        background.blendMode = .replace
        // place it in the background
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        //assign the current scene to be the physics world's contact delegate
        physicsWorld.contactDelegate = self
        
        makeSlot(at: CGPoint(x: 390, y: 0), isGood: false)
       
        makeGlow(at: CGPoint(x: 0, y: 0))
        makeGlow(at: CGPoint(x: 770, y: 0))
        makeGlow(at: CGPoint(x: 0, y: 1020))
        makeGlow(at: CGPoint(x: 770, y: 1020))


        makeBouncer(at: CGPoint(x: 195, y: 700))
        makeBouncer(at: CGPoint(x: 390, y: 550))
        //makeBouncer(at: CGPoint(x: 390, y: 850))
        makeBouncer(at: CGPoint(x: 590, y: 700))
        
        makeBouncer(at: CGPoint(x: 195, y: 400))
        makeBouncer(at: CGPoint(x: 590, y: 400))
        
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        // find where the touch was in the game scene
        let location = touch.location(in: self)
        
        let ball  = SKSpriteNode(imageNamed: "ballBlue")
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
        // The collisionBitMask bitmask means "which nodes should I bump into?" By default, it's set to everything, which is why our ball are already hitting each other and the bouncers. The contactTestBitMask bitmask means "which collisions do you want to know about?" and by default it's set to nothing. So by setting contactTestBitMask to the value of collisionBitMask we're saying, "tell me about every collision."
        ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
        // bounciness the higher the value the more bounce
        ball.physicsBody?.restitution  = 0.4
        ball.position = location
        // Apple recommends assigning names to your nodes, then checking the name to see what node it is
        ball.name = "ball"
        addChild(ball)
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
    
    func makeGlow(at position: CGPoint) {
        var slotGlow: SKSpriteNode
        var spin: SKAction
       
        slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
        spin = SKAction.rotate(byAngle: .pi, duration: 20)
    
        slotGlow.position = position
        
        // spin effect
        spin = SKAction.rotate(byAngle: .pi, duration: 20)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
        
        addChild(slotGlow)
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
            spin = SKAction.rotate(byAngle: .pi, duration: 5)
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
    
    /* there is a problem with this version:
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
        
        if bodyA.name == "ball" {
            collisionBetween(ball: contact.bodyA.node!, object: contact.bodyB.node!)
        } else if bodyB.name == "ball" {
            collisionBetween(ball: contact.bodyB.node!, object: contact.bodyA.node!)
        }
    }
    

    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
        } else if object.name == "bad" {
            destroy(ball: ball)
        }
    }
    
    func destroy(ball: SKNode) {
        ball.removeFromParent()
    }
}
