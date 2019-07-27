//
//  BuildingNode.swift
//  Gorillas-Project29
//
//  Created by Alex Perucchini on 7/24/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit
import SpriteKit

enum CollisionTypes: UInt32 {
    case banana = 1
    case building = 2
    case player = 4
}

class BuildingNode: SKSpriteNode {
    // Initially, this class needs to have three methods:
    // 1. setup() will do the basic work required to make this thing a building: setting its name, texture, and physics.
    // 2. configurePhysics() will set up per-pixel physics for the sprite's current texture.
    // 3. drawBuilding() will do the Core Graphics rendering of a building, and return it as a UIImage.
    
    var currentImage: UIImage!
    
    
    func setup() {
        name = "building"
        
        currentImage = drawBuilding(size: size)
        texture = SKTexture(image: currentImage)
        
        configurePhysics()
    }
    
    func configurePhysics() {
        physicsBody = SKPhysicsBody(texture: texture!, size: size)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = CollisionTypes.building.rawValue
        physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
    }
    
    //1. Create a new Core Graphics context the size of our building.
    //2. Fill it with a rectangle that's one of three colors.
    //3. Draw windows all over the building in one of two colors: there's either a light on (yellow) or not (gray).
    //4. Pull out the result as a UIImage and return it for use elsewhere.
    
    func drawBuilding(size: CGSize) -> UIImage {
        // 1
        let renderer = UIGraphicsImageRenderer(size: size)
        let img = renderer.image { ctx in
            // 2
            let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            let color: UIColor
            
            switch Int.random(in: 0...2) {
            case 0:
                color = UIColor(hue: 0.502, saturation: 0.98, brightness: 0.67, alpha: 1)
            case 1:
                color = UIColor(hue: 0.999, saturation: 0.99, brightness: 0.67, alpha: 1)
            default:
                color = UIColor(hue: 0, saturation: 0, brightness: 0.67, alpha: 1)
            }
            
            color.setFill()
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fill)
            
            // 3
            let lightOnColor = UIColor(hue: 0.190, saturation: 0.67, brightness: 0.99, alpha: 1)
            let lightOffColor = UIColor(hue: 0, saturation: 0, brightness: 0.34, alpha: 1)
            
            //position windows rows
            for row in stride(from: 10, to: Int(size.height - 10), by: 40) {
                //position windows column
                for col in stride(from: 10, to: Int(size.width - 10), by: 40) {
                    if Bool.random() {
                        lightOnColor.setFill()
                    } else {
                        lightOffColor.setFill()
                    }
                    
                    ctx.cgContext.fill(CGRect(x: col, y: row, width: 15, height: 20))
                }
            }
            
            // 4
        }
        
        return img
    }

}
