//
//  HelpCenter.swift
//  FireBaseApp
//
//  Created by gayeugur on 28.10.2023.
//
import Foundation
import FirebaseFirestore

class HelpCenterModel {
    
    var expandedRows = Set<Int>()
    
    func fetchProfileMenu(completion: @escaping (Constant.ResultCases<[Menu]>) -> Void) {
            
        DatabaseManager.shared.fireStoreDatabase.collection("HelpCenterMenu").order(by: "id") .addSnapshotListener { (snapshot, error) in
            if error != nil {
                completion(.failure(error ?? Helper.createGenericError()))
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    var helpCenterMenu: [Menu] = []
                    for document in snapshot!.documents {
                        if let menuName = document.get("name") as? String, let menuIcon = document.get("icon") as? String, let detail = document.get("detail") as? String {
                            let menu = Menu(name: menuName, icon: menuIcon, detail: detail)
                            helpCenterMenu.append(menu)
                        }
                    }
                    completion(.success(helpCenterMenu))
                }
                
            }
        }
    }
}
