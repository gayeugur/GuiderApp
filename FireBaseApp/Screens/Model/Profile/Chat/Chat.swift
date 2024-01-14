//
//  Chat.swift
//  FireBaseApp
//
//  Created by gayeugur on 28.10.2023.
//

import Foundation
import FirebaseDatabase

struct Chat {
    let name: String
    let icon:String
    let lastMessage: String
    let color: Int
}

struct Message {
    let sender: String
    let receiver: String
    let content: String
    let date: String
    
    init(sender: String, receiver: String, content: String, date: String) {
           self.sender = sender
           self.receiver = receiver
           self.content = content
           self.date = date
       }

       init(snapshot: DataSnapshot) {
           let snapshotValue = snapshot.value as! [String: String]
           sender = snapshotValue["sender"] ?? ""
           receiver = snapshotValue["receiver"] ?? ""
           content = snapshotValue["content"] ?? ""
           date = snapshotValue["date"] ?? ""
       }
}

struct SenderMessageModel {
    let isSendByMe: Bool
    let content: String
}
