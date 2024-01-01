//
//  ProfileModel.swift
//  FireBaseApp
//
//  Created by gayeugur on 16.10.2023.
//
import Foundation
import FirebaseFirestore

class ProfileModel {
    
    var allMenu: [Menu] = []
    
    var eventHandler: ((_ event: Constant.Event) -> Void)?
    
    func fetchProfileMenu() {
        self.eventHandler?(.loading)
        
        Constant.fireStoreDatabase.collection("Profile").order(by: "id") .addSnapshotListener { [self] (snapshot, error) in
            if error != nil {
                self.eventHandler?(.error(error))
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                        
                        if let menuName = document.get("name") as? String, let menuIcon = document.get("icon") as? String {
                            let menu = Menu(name: menuName, icon: menuIcon, detail: nil)
                            allMenu.append(menu)
                        }
                        
                    }
                    self.eventHandler?(.dataLoaded)
                }
                
            }
        }
    }
    
}
