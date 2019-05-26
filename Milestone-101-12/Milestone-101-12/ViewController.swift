//
//  ViewController.swift
//  Milestone-101-12
//
//  Created by Alex Perucchini on 5/24/19.
//  Copyright © 2019 Alex Perucchini. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // create an array to hold our pictures
    var pictures = [Picture]()
    let picker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        picker.delegate = self
        
        title = "PiXiE"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))
        
        loadSavedData()
        
    }
    
    // override means the function is changing the parent view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int {
        return pictures.count
    }
    
    // cellForRowAt contains one row and one section
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // recycle unused cells
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "picture", for: indexPath) as? TableViewCell else {
            fatalError("Failed to load picture")
        }
        // find the index path of the pictures array and set the picture text
        let picture = pictures[indexPath.row]
        cell.caption.text = picture.caption
        
        let path = getDocumentsDirectory().appendingPathComponent(picture.image)
        cell.imageView?.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView?.layer.cornerRadius = 3
        cell.imageView?.layer.borderWidth = 1
        cell.imageView?.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.cornerRadius = 7
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.05 * Double(indexPath.row),
            animations: {
                cell.alpha = 1
        })
    }
    
    // 1) load the detail view controller layout from our storyboard.
    // 2) set its selectedImage property to be the correct item from the pictures array.
    // 3) show the new view controller.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // save the renamed images name
        let picture = pictures[indexPath.item]
    
        // try loading the detail view controller and typecast as DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            
            if picture.caption == "unknown" {
                let ac = UIAlertController(title: "Rename image", message: nil, preferredStyle: .alert)
                ac.addTextField()
                ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                ac.addAction(UIAlertAction(title: "OK", style: .default) {
                    [weak self, weak ac] _ in
                    guard let newCaption = ac?.textFields?[0].text else { return }
                    picture.caption = newCaption
                    // save to disk
                    self?.save()
                    //reload tableView
                    self?.tableView.reloadData()
                })
            
                present(ac, animated: true)
            }
            
            // great, set it's selectedImage property
            vc.selectedImage = pictures[indexPath.row]
            vc.caption = picture.caption
            // now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)

        }
    
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            pictures.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Extract the image from the dictionary that is passed as a parameter.
    // Generate a unique filename for it.
    // Convert it to a JPEG, then write that JPEG to disk.
    // Dismiss the view controller.
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {// 80% compression quality
            try? jpegData.write(to: imagePath)
        }
        
        let picture = Picture(caption: "unknown", image: imageName)
        print(picture)
        pictures.append(picture)
        //save to disk
        save()
        
        tableView.reloadData()
        
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @objc func addImage() {
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
    
    func cameraPicker(_: UIAlertAction) {
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
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.allowsEditing = true
        picker.delegate = (self as UIImagePickerControllerDelegate as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        
        present(picker, animated: true)
        picker.allowsEditing = true
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictures")
        } else {
            print("Failed to save people.")
        }
    }
    
    func loadSavedData() {
        // reload the data from disk
        let defaults = UserDefaults.standard
        
        if let savedPictures = defaults.object(forKey: "pictures") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                pictures = try jsonDecoder.decode([Picture].self, from: savedPictures)
            } catch {
                print("Failed to load pictures")
            }
        }
    }
}

