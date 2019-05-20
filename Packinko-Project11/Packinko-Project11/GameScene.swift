//
//  GameScene.swift
//  Packinko-Project11
//
//  Created by Alex Perucchini on 5/18/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        // these are the best CGPoint for iPad
        background.position = CGPoint(x: 512, y: 384)
        // ignore transparancy makes it faster
        background.blendMode = .replace
        // place it in the background
        background.zPosition = -1
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        

        makeBouncer(at: CGPoint(x: 300, y: 400))
        makeBouncer(at: CGPoint(x: 512, y: 250))
        makeBouncer(at: CGPoint(x: 512, y: 550))
        makeBouncer(at: CGPoint(x: 700, y: 400))
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        // find where the touch was in the game scene
        let location = touch.location(in: self)
        
        let ball  = SKSpriteNode(imageNamed: "ballRed")
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
        // bounciness the higher the value the more bounce
        ball.physicsBody?.restitution  = 1.0
        ball.position = location
        addChild(ball)
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
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
            spin = SKAction.rotate(byAngle: .pi, duration: 20)
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            spin = SKAction.rotate(byAngle: .pi, duration: 5)
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        addChild(slotBase)
        addChild(slotGlow)
        
        // spin effect
       
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
}

