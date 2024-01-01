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
    
    enum BlogResult {
        case success([Blog])
        case failure(Error)
    }
    
    func fetchBlogData(completion: @escaping (BlogResult) -> Void) {
        
        Constant.fireStoreDatabase.collection("Blog").order(by: "name", descending: true).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                var fetchedBlogs: [Blog] = []
                
                for document in snapshot.documents {
                    if let postName = document.get("name") as? String,
                       let postComment = document.get("comment") as? String,
                       let postImage = document.get("image") as? String {
                        
                        let blog = Blog(blogName: postName, blogImage: postImage, blogDescription: postComment)
                        fetchedBlogs.append(blog)
                    }
                }
                
                completion(.success(fetchedBlogs))
            } else {
                let unknownError = NSError(domain: "Unknown", code: -1, userInfo: [NSLocalizedDescriptionKey: "Bilinmeyen bir hata oluştu"])
                completion(.failure(unknownError))
            }
        }
    }
    
    func uploadImageToFirebase(image: UIImage, blogName: String, blogDescription: String, completion: @escaping (Constant.AddResultCases) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Cannot convert image to data.")
            return
        }
        
        let storageRef = Storage.storage().reference().child("blog_images").child("\(UUID().uuidString).jpg")
        
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { (url, error) in
                if let downloadURL = url {
                    print("Download URL: \(downloadURL)")
                    
                    let blog = Blog(blogName: blogName, blogImage: downloadURL.absoluteString, blogDescription: blogDescription)
                    self.addBlog(blog: blog) { result in
                        completion(.success("success"))
                    }
                } else if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
    }
    
    func addBlog(blog: Blog, completion: @escaping (Constant.AddResultCases) -> Void) {
        let blogRef = Constant.fireStoreDatabase.collection("Blog").document()
        
        let data: [String: Any] = [
            "name": blog.blogName,
            "comment": blog.blogDescription,
            "image": blog.blogImage
        ]
        
        blogRef.setData(data) { error in
            if error == nil {
                completion(.success("Adding Success"))
            } else {
                let unknownError = NSError(domain: "Unknown", code: -1, userInfo: [NSLocalizedDescriptionKey: "Bilinmeyen bir hata oluştu"])
                completion(.failure(unknownError))
            }
        }
    }
    
    
}
