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
    
    func fetchBlogData(completion: @escaping (Constant.ResultCases<[Blog]>) -> Void) {
        DatabaseManager.shared.fireStoreDatabase.collection("Blog").order(by: "name", descending: true).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                var fetchedBlogs: [Blog] = []
                
                for document in snapshot.documents {
                    if let postName = document.get("name") as? String,
                       let postComment = document.get("comment") as? String,
                       let postImage = document.get("image") as? String {
                        
                        let blog = Blog(blogName: postName,
                                        blogImage: postImage,
                                        blogDescription: postComment)
                        fetchedBlogs.append(blog)
                    }
                }
                completion(.success(fetchedBlogs))
            } else {
                completion(.failure(Helper.createGenericError()))
            }
        }
    }
    
    func uploadImageToFirebase(image: UIImage, blogName: String, blogDescription: String, completion: @escaping (Constant.ResultCases<Bool>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(.failure(Helper.createGenericError()))
            return
        }

        let imageFileName = "\(UUID().uuidString).jpg"
        let storageRef = DatabaseManager.shared.storageRef.child("blog_images").child(imageFileName)

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        storageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            storageRef.downloadURL { (url, error) in
                if let downloadURL = url {
                    let blog = Blog(blogName: blogName, blogImage: downloadURL.absoluteString, blogDescription: blogDescription)
                    self.addBlog(blog: blog) { result in
                        completion(result)
                    }
                } else if let error = error {
                    completion(.failure(error))
                }
            }
        }
    }

    
    func addBlog(blog: Blog, completion: @escaping (Constant.ResultCases<Bool>) -> Void) {
        let blogRef = DatabaseManager.shared.fireStoreDatabase.collection("Blog").document()
        
        let data: [String: Any] = [
            "name": blog.blogName,
            "comment": blog.blogDescription,
            "image": blog.blogImage
        ]
        
        blogRef.setData(data) { error in
            if error == nil {
                completion(.success(true))
            } else {
                completion(.failure(Helper.createGenericError()))
            }
        }
    }
    
    
}
