//
//  AddBlogViewController.swift
//  FireBaseApp
//
//  Created by gayeugur on 9.10.2023.
//

import UIKit
import Firebase
import FirebaseStorage

class AddBlogViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var blogImageView: UIImageView!
    @IBOutlet weak var blogName: UITextField!
    @IBOutlet weak var blogDescription: UITextField!
    
    var blogModel = BlogModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blogImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        blogImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func chooseImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func addAction(_ sender: Any) {
        if let image = blogImageView.image, let name = blogName.text, let comment = blogDescription.text {
            blogModel.addBlogData(image: image, blogName: name, blogDescription: comment)
            navigationController?.popToRootViewController(animated: true)
        }
    }
}

extension AddBlogViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        blogImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
}

