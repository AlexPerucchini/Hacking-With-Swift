//
//  GameScene.swift
//  Card-Gsme
//
//  Created by Alex Perucchini on 8/10/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//
// https://www.raywenderlich.com/1062-card-game-mechanics-in-sprite-kit-with-swift#toc-anchor-001

import SpriteKit

enum CardLevel: CGFloat {
    case board = 10
    case moving = 100
    case enlarged = 200
}

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
    
        let wolf = Card(cardType: .wolf)
        wolf.position = CGPoint(x: 100, y: 200)
        addChild(wolf)
        
        let bear = Card(cardType: .bear)
        bear.position = CGPoint(x: 300, y: 200)
        addChild(bear)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let card = atPoint(location) as? Card {
                // Make sure you pick a zPosition value that is greater than other cards will be, as well as less than any interface elements that should be displayed on top of the card layer.
                card.zPosition = CardLevel.moving.rawValue
                
                card.removeAction(forKey: "drop")
                card.run(SKAction.scale(to: 1.3, duration: 0.25), withKey: "pickup")
                
                let wiggleIn = SKAction.rotate(byAngle:  0.2, duration: 0.2)
                let wiggleOut = SKAction.rotate(byAngle: -0.2, duration: 0.2)
                let wiggle = SKAction.sequence([wiggleIn, wiggleOut])
                
                card.run(SKAction.repeatForever(wiggle), withKey: "wiggle")
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let card = atPoint(location) as? Card {
                // The line to remove and add the card to the scene may look strange, but it prevents the wolf from jumping underneath the card for the bear if they overlap when the touch ends. The SKNodes are displayed in reverse order that they were added to the scene, with the later nodes on top. You can’t rearrange the order of nodes in SKNode‘s internal storage, but removing and adding the node again has the desired effect.
                card.zPosition = CardLevel.board.rawValue
                card.removeFromParent()
                addChild(card)
                
                card.removeAction(forKey: "pickup")
                card.run(SKAction.scale(to: 1.0, duration: 0.25), withKey: "drop")
                
                card.removeAction(forKey: "wiggle")
                // set card to the orginal position
                card.run(SKAction.rotate(toAngle: 0, duration: 0.2), withKey:"rotate")
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            // The location(in:) method converts the touch location into the scene coordinates.
            let location = touch.location(in: self)
            // Use atPoint(_:) to determine which node was touched. This method will always return a value, even if you didn’t touch any of the cards. In that case, you get some other SKNode class. The as? Card keyword then either returns a Card object, or nil if that node isn’t a Card. The if let then guarantees that card contains an actual Card, and not anything else. Without this step, you might accidentally move the background node, which is amusing, but not what you want.
            if let card = atPoint(location) as? Card {
                card.position = location
            }
        }
    }
}
