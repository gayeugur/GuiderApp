//
//  ChatModel.swift
//  FireBaseApp
//
//  Created by gayeugur on 28.10.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseDatabase

class ChatModel {
    
    var messages: [Message] = []
    
    func fetchChatList(completion: @escaping (Constant.ResultCases<[Chat]>) -> Void) {
        
        DatabaseManager.shared.fireStoreDatabase.collection("ChatList").order(by: "date") .addSnapshotListener { (snapshot, error) in
            if error != nil {
                completion(.failure(error ?? Helper.createGenericError()))
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    var chatList: [Chat] = []
                    for document in snapshot!.documents {
                        if let name = document.get("name") as? String,
                           let icon = document.get("image") as? String,
                           let color = document.get("color") as? Int,
                           let date = document.get("date") as? String {
                            let chat = Chat(name: name, icon: icon, lastMessage: date, color: color)
                            chatList.append(chat)
                            
                        }
                    }
                    completion(.success(chatList))
                }
                
            }
        }
    }
    
    func fetchMessages(sender: String, receiver: String, completion: @escaping (Constant.ResultCases<[Message]>) -> Void) {
        
        DatabaseManager.shared.database.child("messages").observeSingleEvent(of: .value, with: { snapshot in
            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else {
                completion(.failure(Error.self as! Error))
                return
            }
            for snap in snapshots {
                let message = Message(snapshot: snap)
                if message.sender == sender &&
                    message.receiver == receiver ||
                    message.sender == receiver &&
                    message.receiver == sender {
                    self.messages.append(message)
                }
            }
            
            completion(.success(self.messages))
        })
    }
    
    
    
}
