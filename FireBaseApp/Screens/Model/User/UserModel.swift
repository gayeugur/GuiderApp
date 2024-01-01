//
//  UserModel.swift
//  FireBaseApp
//
//  Created by gayeugur on 3.12.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class UserModel {
    
    var eventHandler: ((_ event: Constant.Event) -> Void)?
    
    func fetchUserData(forUsername username: String, completion: @escaping (Result<User, Error>) -> Void) {

        Constant.fireStoreDatabase.collection("users").whereField("username", isEqualTo: username).getDocuments { (querySnapshot, error) in
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
    func updateUserPassword(newPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if let user = Auth.auth().currentUser {
            user.updatePassword(to: newPassword) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } else {
            let authError = NSError(domain: "Auth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Oturum açılmamış"])
            completion(.failure(authError))
        }
    }

    
}
