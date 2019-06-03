//
//  ViewController.swift
//  InstaFilter-Project13
//
//  Created by Alex Perucchini on 5/27/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//
// see https://www.hackingwithswift.com/read/13/4/applying-filters-cicontext-cifilter

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intesity: UISlider!
    @IBOutlet var radius: UISlider!
    @IBOutlet var scale: UISlider!
    
    @IBOutlet var changeFilterButton: UIButton!
    var currentImage: UIImage!
    // core image context
    var context: CIContext!
    var currentFilter: CIFilter!
    
    override func viewDidAppear(_ animated: Bool) {
    }

    override func viewDidLoad() {
        imageView.alpha = 0
        super.viewDidLoad()
        title = "InstaFilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
        
        // reset slider values
        intesity.value = 0.5
        radius .value = 0.5
        scale.value = 0.5
    }

    @IBAction func changeFilter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        // this code is for the iPad
        if let popoverController = popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        // reset slider values
        intesity.value = 0.5
        radius .value = 0.5
        scale.value = 0.5
        
        present(ac, animated: true)
       
    }

    @IBAction func save(_: Any) {
        
        if currentImage == nil {
            let ac = UIAlertController(title: "No image to save", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            
        } else {
            UIImageWriteToSavedPhotosAlbum(imageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }

    // update the values coming from the slider
    @IBAction func intesityChange(_ sender: Any) {
        applyProcessing()
    }
    
    @IBAction func radiusChange(_ sender: Any) {
        applyProcessing()
    }
    
    @IBAction func scaleChanged(_ sender: Any) {
        applyProcessing()
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        currentImage = image
       
        
        UIView.animate(withDuration: 4.0 ) {
            self.imageView.image = self.currentImage
            self.imageView.alpha = 1
            self.imageView.layoutIfNeeded()
        }
//        let beginImage = CIImage(image: currentImage)
//        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
//        applyProcessing()
    }
    
    func applyProcessing() {
       
        guard let image = currentFilter.outputImage else { return }
        
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intesity.value, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey)    { currentFilter.setValue(radius.value * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey)     { currentFilter.setValue(scale.value * 20, forKey: kCIInputScaleKey) }
        if inputKeys.contains(kCIInputCenterKey)    { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }
        
        if let cgimg = context.createCGImage(image, from: image.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            self.imageView.image = processedImage
        }
    }
    
    func setFilter(action: UIAlertAction) {
        
        // make sure we have a valid image before continuing!
        guard currentImage != nil else { return }
        // reset slider values
        intesity.value = 0.5
        radius .value = 0.5
        scale.value = 0.5
        
        // safely read the alert action's title
        guard let actionTitle = action.title else { return }
        changeFilterButton.setTitle(actionTitle, for: .normal)
        
        currentFilter = CIFilter(name: actionTitle)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
}
