//
//  WhackSlot.swift
//  Whack-Pinguin-Project14
//
//  Created by Alex Perucchini on 5/29/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit
import SpriteKit

class WhackSlot: SKNode {
    var charNode: SKSpriteNode!
    var myLabel:  SKLabelNode!
    var isVisible = false
    var isHit = false
    
    func configure(at position: CGPoint) {
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        //cropNode.maskNode = nil
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)
        
        let say = ["Ha-ha!", "Boo!", "Nope!", "Zilch!", "Nada!"]

        myLabel = SKLabelNode(fontNamed: "Chalkduster")
        myLabel.text = say.shuffled().first
        myLabel.fontSize = 20
        myLabel.position = CGPoint(x: 0, y: -80)
    
        cropNode.addChild(myLabel)
        
        addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        if isVisible { return }
        
        // move penguin up the slot
        charNode.run(SKAction.moveBy(x: 0, y: 70, duration: 0.05))
        myLabel.run(SKAction.moveBy(x:0,  y: 100, duration: 0.05))
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")

            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) {
            [weak self] in
            self?.hide()
        }
    }
    
    func hide() {
        if !isVisible { return }
        // move penguin up the slot
        charNode.run(SKAction.moveBy(x: 0, y: -70, duration: 0.05))
        myLabel.run(SKAction.moveBy(x: 0, y: -100, duration: 0.05))
        
        isVisible = false
    }
}
