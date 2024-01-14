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
    
    //MARK: @IBOUTLET
    @IBOutlet weak var blogImageView: UIImageView!
    @IBOutlet weak var blogName: UITextField!
    @IBOutlet weak var blogDescription: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    //MARK: PROPERTIES
    var blogModel = BlogModel()
    
    //MARK: LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        addRecognizer()
        addButton.layer.cornerRadius = 12
    }
    
    //MARK: FUNCTIONS
    private func addRecognizer() {
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
    
    //MARK: @IBACTIONS
    @IBAction func addAction(_ sender: Any) {
        
        if let name = blogName.text,
           let description = blogDescription.text,
           let image = blogImageView.image {
            
            blogModel.uploadImageToFirebase(image: image, 
                                            blogName: name,
                                            blogDescription: description) { result in
                switch result {
                case .success(_):
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    Helper.makeAlert(on: self,
                                     titleInput: ConstantMessages.errorTitle,
                                     messageInput: error.localizedDescription)
                }
            }
            
        } else {
            Helper.makeAlert(on: self,
                             titleInput: ConstantMessages.errorTitle,
                             messageInput: ConstantMessages.genericError)
        }
    }
}

//MARK: UIImagePickerControllerDelegate
extension AddBlogViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        blogImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
}

