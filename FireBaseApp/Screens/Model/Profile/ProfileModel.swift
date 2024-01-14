//
//  ProfileModel.swift
//  FireBaseApp
//
//  Created by gayeugur on 16.10.2023.
//
import Foundation
import FirebaseFirestore

class ProfileModel {
    
    func fetchProfileMenu(completion: @escaping (Constant.ResultCases<[Menu]>) -> Void) {
        
        DatabaseManager.shared.fireStoreDatabase.collection("Profile").order(by: "id") .addSnapshotListener { (snapshot, error) in
            if error != nil {
                completion(.failure(error ?? Helper.createGenericError()))
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    var allMenu: [Menu] = []
                    for document in snapshot!.documents {
                        if let menuName = document.get("name") as? String,
                           let menuIcon = document.get("icon") as? String {
                            let menu = Menu(name: menuName,
                                            icon: menuIcon,
                                            detail: nil)
                            allMenu.append(menu)
                        }
                        
                    }
                    completion(.success(allMenu))
                }
                
            }
        }
    }
    
}
