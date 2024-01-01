//
//  ChatModel.swift
//  FireBaseApp
//
//  Created by gayeugur on 28.10.2023.
//

import Foundation
import FirebaseFirestore

class ChatModel {
    var chatList: [Chat] = []
    
    var eventHandler: ((_ event: Constant.Event) -> Void)?
    
    func fetchChatList() {
        self.eventHandler?(.loading)
            
        Constant.fireStoreDatabase.collection("ChatList").order(by: "date") .addSnapshotListener { [self] (snapshot, error) in
            if error != nil {
                self.eventHandler?(.error(error))
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                        if let name = document.get("name") as? String, let icon = document.get("image") as? String, let color = document.get("color") as? Int, let date = document.get("date") as? String {
                            let chat = Chat(name: name, icon: icon, lastMessage: date, color: color)
                            chatList.append(chat)
                            
                        }
                    }
                    self.eventHandler?(.dataLoaded)
                }
                
            }
        }
    }
}
