//
//  ViewController.swift
//  Animation-Project16
//
//  Created by Alex Perucchini on 6/1/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var imageView: UIImageView!
    var currentAnimation = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = view.center
        view.addSubview(imageView)
    }

    @IBAction func tapped(_ sender: UIButton) {
        // don't show the button when the animation executes
        sender.isHidden =  true
        
       // UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            switch self.currentAnimation {
            case 0:
               self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
            case 1:
                self.imageView.transform = .identity
            case 2:
                self.imageView.transform = CGAffineTransform(translationX: -256, y: -256)
            case 3:
                self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            case 4:
                self.imageView.transform = .identity
            case 6:
                self.imageView.alpha = 0.1
                self.imageView.backgroundColor = UIColor.green
                
            case 7:
                self.imageView.alpha = 1
                self.imageView.backgroundColor = UIColor.clear
            default:
                break
            }
        }) { finished in
            // show the button again
            sender.isHidden = false
        }
        
        currentAnimation += 1
        
        // loop the animation from 0-7
        if currentAnimation > 7 {
            currentAnimation = 0
        }
    }
}

