//
//  Card.swift
//  
//
//  Created by Alex Perucchini on 8/10/19.
//

import SpriteKit

enum CardType :Int {
    case wolf
    case bear
    case dragon
}

class Card : SKSpriteNode {
    let cardType :CardType
    let frontTexture :SKTexture
    let backTexture :SKTexture
    
    var damage = 0
    let damageLabel :SKLabelNode
    var faceUp = true
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(cardType: CardType) {
        self.cardType = cardType
        backTexture = SKTexture(imageNamed: "card_back")
        
        damageLabel = SKLabelNode(fontNamed: "OpenSans-Bold")
        damageLabel.name = "damageLabel"
        damageLabel.fontSize = 12
        damageLabel.fontColor = SKColor(red: 0.47, green: 0.0, blue: 0.0, alpha: 1.0)
        damageLabel.text = "0"
        damageLabel.position = CGPoint(x: 25, y: 40)
        
        switch cardType {
        case .wolf:
            frontTexture = SKTexture(imageNamed: "card_creature_wolf")
        case .bear:
            frontTexture = SKTexture(imageNamed: "card_creature_bear")
        case .dragon:
            frontTexture = SKTexture(imageNamed: "card_creature_dragon")
        }
        
        // This is the general pattern for initializing Swift objects. First, initialize all non-optional properties; then, call super.init(texture:color:size:); finally, call any instance methods needed to complete initialization.
        super.init(texture: frontTexture, color: .clear, size: frontTexture.size())
        addChild(damageLabel)
    }
    
    func flip() {
        let firstHalfFlip = SKAction.scaleX(to: 0.0, duration: 0.4)
        let secondHalfFlip = SKAction.scaleX(to: 1.0, duration: 0.4)
        
        setScale(1.0)
        
        if faceUp {
            run(firstHalfFlip) {
                self.texture = self.backTexture
                self.damageLabel.isHidden = true
                
                self.run(secondHalfFlip)
            }
        } else {
            run(firstHalfFlip) {
                self.texture = self.frontTexture
                self.damageLabel.isHidden = false
                
                self.run(secondHalfFlip)
            }
        }
        faceUp = !faceUp
    }
}
