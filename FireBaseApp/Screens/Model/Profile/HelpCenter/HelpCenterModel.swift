//
//  HelpCenter.swift
//  FireBaseApp
//
//  Created by gayeugur on 28.10.2023.
//
import Foundation
import FirebaseFirestore

class HelpCenterModel {
    var helpCenterMenu: [Menu] = []
    
    var eventHandler: ((_ event: Constant.Event) -> Void)?
    
    func fetchProfileMenu() {
        self.eventHandler?(.loading)
            
        DatabaseManager.shared.fireStoreDatabase.collection("HelpCenterMenu").order(by: "id") .addSnapshotListener { [self] (snapshot, error) in
            if error != nil {
                self.eventHandler?(.error(error))
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                        if let menuName = document.get("name") as? String, let menuIcon = document.get("icon") as? String, let detail = document.get("detail") as? String {
                            let menu = Menu(name: menuName, icon: menuIcon, detail: detail)
                            helpCenterMenu.append(menu)
                        }
                    }
                    self.eventHandler?(.dataLoaded)
                }
                
            }
        }
    }
}
