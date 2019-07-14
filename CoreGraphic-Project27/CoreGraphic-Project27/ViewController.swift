//
//  ViewController.swift
//  CoreGraphic-Project27
//
//  Created by Alex Perucchini on 7/14/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawRectangle()
    }

    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        
        if currentDrawType > 5 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
        case 1:
            drawCircle()
        case 2:
            drawCheckerboard()
        case 3:
            drawRotatedSquares()
        case 4:
            drawLines()
        case 5:
            drawImagesAndText()
        default:
            break
        }
    }
    
    func drawRectangle() {
        // creates a sandbox the UIGraphicsImageRenderer is a bridge from UIKit to Core Graphics
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            // awesome drawing code
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 10.0, dy: 10.0)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = img
    
    }
    
    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 10.0, dy: 10.0)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.gray.cgColor)
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = img
    }
    
    func drawCheckerboard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col) % 2 == 0 {
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                        ctx.cgContext.setLineWidth(2)
                    }
                }
            }
        }
        imageView.image = img
    }
    
    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            //center of the renderer
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0 ..< rotations {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            
            ctx.cgContext.setStrokeColor(UIColor.orange.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = img
    }
    
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0 ..< 256 {
                ctx.cgContext.rotate(by: .pi / 2)
                
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                
                length *= 0.99
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = img
    }
    // 1. Create a renderer at the correct size.
    // 2. Define a paragraph style that aligns text to the center.
    // 3. Create an attributes dictionary containing that paragraph style, and also a font.
    // 4. Wrap that attributes dictionary and a string into an instance of NSAttributedString.
    // 5. Load an image from the project and draw it to the context.
    // 6. Update the image view with the finished result.
    func drawImagesAndText() {
        // 1
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            // 2
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            // 3
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            // 4
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            // 5
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            // 5
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        // 6
        imageView.image = img
    }
}

