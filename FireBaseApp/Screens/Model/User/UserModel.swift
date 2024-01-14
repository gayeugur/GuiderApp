//
//  UserModel.swift
//  FireBaseApp
//
//  Created by gayeugur on 3.12.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase

final class UserModel {
    
    func fetchUserData(forUsername username: String, completion: @escaping (Constant.ResultCases<User>) -> Void) {
        
        DatabaseManager.shared.fireStoreDatabase.collection("users").whereField("username", isEqualTo: username).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let documents = querySnapshot?.documents, !(documents.isEmpty) else {
                    let noDocumentError = NSError(domain: "No document found", code: 404, userInfo: nil)
                    completion(.failure(noDocumentError))
                    return
                }
                
                for document in documents {
                    let userData = document.data()
                    if let username = userData["username"] as? String,
                       let email = userData["mail"] as? String,
                       let password = userData["password"] as? String {
                        let user = User(username: username, password: password, mail: email)
                        completion(.success(user))
                        return
                    }
                }
                
                
            }
        }
    }
    
    
    func updateUserPassword(newPassword: String, completion: @escaping (Constant.ResultCases<Bool>) -> Void) {
        if let user = Auth.auth().currentUser {
            user.updatePassword(to: newPassword) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success((true)))
                }
            }
        } else {
            let authError = NSError(domain: "Auth", code: -1, userInfo: [NSLocalizedDescriptionKey: "logged in"])
            completion(.failure(authError))
        }
    }
    
    
    func setUserWithAllInformation(email: String, password: String, completion: @escaping (Constant.ResultCases<User>) -> Void) -> Void {
        
        Auth.auth().signIn(withEmail: email, password: password) { (authdata, error) in
            if let error = error {
                completion(.failure(error))
                
            } else {
                
                if (Auth.auth().currentUser?.email) != nil {
                    let usersCollection = DatabaseManager.shared.fireStoreDatabase.collection("users")
                    
                    usersCollection.whereField("mail", isEqualTo: email).getDocuments { (snapshot, error) in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        
                        if let document = snapshot?.documents.first {
                            let username = document["username"] as? String ?? "Undefined"
                            let isActive = document["isActive"] as? Bool ?? false
                            let user = User(username: username,
                                            password: password,
                                            mail: email,
                                            isActive: isActive)
                            completion(.success(user))
                            
                        }
                    }
                }
                
                
            }
        }
        
    }
    
    func addUser(user: User?) {
        guard let user = user else {
            print("Error: Place object is nil")
            return
        }
        
        let db = Firestore.firestore()
        
        let usersCollection = db.collection("users")
        
        let data: [String: Any] = [
            "mail": (user.mail ?? ""),
            "password": user.password ?? "",
            "username": user.username ?? "",
            "isActive": user.isActive ?? false
        ]
        
        usersCollection.addDocument(data: data) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID: \(usersCollection.document().documentID)")
            }
        }
    }
    
    
    func updateActiveStatus(isActive: Bool, completion: @escaping (Result<Bool, Error>) -> Void) -> Void {
        
        let db = Firestore.firestore()
        let usersCollection = db.collection("users")
        
        let updatedData = ["isActive": isActive]
        
        usersCollection.whereField("username", isEqualTo: UserManager.shared.currentUser?.username as Any).getDocuments { (snapshot, error) in
            if let error = error {
                print("Firestore belge arama hatası: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("Belge bulunamadı.")
                completion(.failure(NSError()))
                return
            }
            
            // Kullanıcı adına sahip belgeyi güncelle
            for document in documents {
                let documentID = document.documentID
                usersCollection.document(documentID).updateData(updatedData) { error in
                    if let error = error {
                        print("Firestore güncelleme hatası: \(error.localizedDescription)")
                        completion(.failure(error))
                    } else {
                        print("isActive başarıyla güncellendi.")
                        completion(.success(true))
                    }
                }
            }
        }
        
    }
     
    
}
