//
//  ViewController.swift
//  NameToFaces-Project10
//
//  Created by Alex Perucchini on 5/15/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Image Picker"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("You have failed me for the last time, Admiral")
        }
        
        // pull out the person from the people array at the correct position.
        // Set the name label to the person's name.
        // Create a UIImage from the person's image filename, adding it to the value from getDocumentsDirectory() so that we have a full path for the image.
        let person = people[indexPath.item]
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.cornerRadius = 3
        cell.imageView.layer.borderWidth = 1
        cell.imageView.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.cornerRadius = 7
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        // reload the data from disk
        let defaults = UserDefaults.standard
        
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                people = try jsonDecoder.decode([Person].self, from: savedPeople)
            } catch {
                print("Failed to load people")
            }
        }
    
        return cell
    }
    
    /*
     First, the delegate method we're going to implement is the collection view’s didSelectItemAt method, which is triggered when the user taps a cell. This method needs to pull out the Person object at the array index that was tapped, then show a UIAlertController asking users to rename the person.
     
     Adding a text field to an alert controller is done with the addTextField() method. We'll also need to add two actions: one to cancel the alert, and one to save the change. To save the changes, we need to add a closure that pulls out the text field value and assigns it to the person's name property, then we'll also need to reload the collection view to reflect the change
    */
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ac = UIAlertController(title: "Rename image", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            person.name = newName
            self?.save()
            self?.collectionView.reloadData()
        })
        
        present(ac, animated: true)
        
    }
    // We set the allowsEditing property to be true, which allows the user to crop the picture they select.
    // When you set self as the delegate, you'll need to conform not only to the UIImagePickerControllerDelegate protocol,
    // but also the UINavigationControllerDelegate protocol.
    @objc func addNewPerson() {
        
        let ac = UIAlertController(title: "Select Image...", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Camera",
                                   style: .default, handler: cameraPicker))
        ac.addAction(UIAlertAction(title: "Photo Library",
                                   style: .default, handler: libraryPicker))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        //required for the iPad
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        
        present(ac, animated: true)
    }
    
    // Extract the image from the dictionary that is passed as a parameter.
    // Generate a unique filename for it.
    // Convert it to a JPEG, then write that JPEG to disk.
    // Dismiss the view controller.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {// 80% compression quality
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "unknown", image: imageName)
        people.append(person)
        
        save()
        
        collectionView.reloadData()
        
        dismiss(animated: true)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func cameraPicker(_: UIAlertAction) {
        let picker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = (self as UIImagePickerControllerDelegate as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
            
            present(picker, animated: true)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func libraryPicker(_: UIAlertAction) {
        let picker = UIImagePickerController()
        
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.allowsEditing = true
        picker.delegate = (self as UIImagePickerControllerDelegate as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        
        present(picker, animated: true)
        picker.allowsEditing = true
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(people) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        } else {
            print("Failed to save people.")
        }
    }
}

