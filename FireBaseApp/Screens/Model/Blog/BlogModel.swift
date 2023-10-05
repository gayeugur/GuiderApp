//
//  BlogModel.swift
//  FireBaseApp
//
//  Created by gayeugur on 14.10.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

final class BlogModel {
    
    var blogs: [Blog] = []
    
    var eventHandler: ((_ event: Constant.Event) -> Void)?
    
    func fetchBlogData() {
        self.eventHandler?(.loading)
        let fireStoreDatabase = Firestore.firestore()
            
        fireStoreDatabase.collection("Blog").order(by: "name", descending: true).addSnapshotListener { [self] (snapshot, error) in
            if error != nil {
                self.eventHandler?(.error(error))
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                        
                        if let postName = document.get("name") as? String, let postComment = document.get("comment") as? String, let postImage = document.get("image") as? String {
                            
                            let blog = Blog(blogName: postName, blogImage: postImage, blogDescription: postComment)
                            blogs.append(blog)
                            
                        }
                        self.eventHandler?(.dataLoaded)
                    }
                   
                }
                
            }
        }
    }
    
    func addBlogData(image: UIImage, blogName: String, blogDescription: String) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
                
        let mediaFolder = storageReference.child("blog")
        
               if let data = image.jpegData(compressionQuality: 0.5) {
                   
                   let uuid = UUID().uuidString
                              
                   let imageReference = mediaFolder.child("\(uuid).jpg")
                   imageReference.putData(data, metadata: nil) { (metadata, error) in
                       if error != nil {
                           print(error?.localizedDescription)
                       } else {
                           
                           imageReference.downloadURL { (url, error) in
                               
                               if error == nil {
                                   
                                   let imageUrl = url?.absoluteString
                                   print(imageUrl)
                                   let firestoreDatabase = Firestore.firestore()
                                   
                                   var firestoreReference : DocumentReference? = nil
                                   
                                   let firestorePost = ["image" : imageUrl!, "name" : blogName , "comment" : blogDescription] as [String : Any]

                                   firestoreReference = firestoreDatabase.collection("Blog").addDocument(data: firestorePost, completion: { (error) in
                                       if error != nil {
                                           
                                        
                                           
                                       } else {
                                           
                                          
                                          
                                          print("erorr")
                                           
                                       }
                                   })
                                   
                                   
                                   
                               }
                               
                               
                           }
                           
                       }
                   }
                   
                   
               }
               
        
        
        
    }

    }
    

