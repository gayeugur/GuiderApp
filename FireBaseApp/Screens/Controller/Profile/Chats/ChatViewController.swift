//
//  ChatViewController.swift
//  FireBaseApp
//
//  Created by gayeugur on 10.01.2024.
//

import UIKit
import FirebaseDatabase

class ChatViewController: UIViewController {

    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextView!
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    let chatModel = ChatModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        guard let userName = UserManager.shared.currentUser?.username,
              let receiver = self.title else { return }
        fetchMessage(userName: userName, receiver: receiver)
        messageTrigger()
    }
    
    private func messageTrigger() {
        let messagesReferance = DatabaseManager.shared.database.child("messages")
        messagesReferance.observe(.childAdded) { snapshot in
            
            if let messageData = snapshot.value as? [String: Any],
               let sender = messageData["sender"] as? String,
               let messageText = messageData["content"] as? String,
               let receiver = messageData["receiver"] as? String,
               var date = messageData["date"] as? String {
                let messages = Message(sender: sender,
                                       receiver: receiver,
                                       content: messageText,
                                       date: date)
                self.chatModel.messages.append(messages)
                self.chatTableView.reloadData()
                
            }
        }
    }
    
    private func configure() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "messageCell")
        chatTableView.separatorStyle = .none
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }
    
    
    @IBAction func sendMessageClicked(_ sender: Any) {
        guard let messageContent = messageTextField.text else { return }
        guard let userName = UserManager.shared.currentUser?.username,
              let receiver = self.title else { return }
        
        let date = Helper.formatDate(date: Date())
        let message = Message(sender: userName,
                              receiver: receiver,
                              content: messageContent,
                              date: date)

        messageTextField.text = ""
        sendMessage(message: message)

    }
    
    private func fetchMessage(userName: String, receiver: String) {
        chatModel.fetchMessages(sender: userName, receiver: receiver ) { result in
            switch result {
            case .success(_):
                self.activityIndicator.stopAnimating()
                self.chatTableView.reloadData()
            case .failure(let error):
                self.activityIndicator.stopAnimating()
                Helper.makeAlert(on: self,
                                 titleInput: ConstantMessages.errorTitle,
                                 messageInput: error.localizedDescription)
            }
        }
    }
    
    
    private func sendMessage(message: Message) {
        let dict = toDictionary(message: message)
        let messageKey = DatabaseManager.shared.database.child("messages").childByAutoId().key
        guard let messageKey = messageKey else { return }
        DatabaseManager.shared.database.child("messages").child(messageKey).setValue(dict)
    }
    
    private func toDictionary(message: Message) -> [String: String] {
        return [
            "sender": message.sender,
            "receiver": message.receiver,
            "content": message.content,
            "date": message.date
        ]
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as? MessageCell else {
            return UITableViewCell()
        }

        if let currentUser = UserManager.shared.currentUser {
            let index = indexPath.row
            if index < chatModel.messages.count {
                let message = chatModel.messages[index]
                let isMessageFromCurrentUser = currentUser.username == message.sender
                let messageModel = SenderMessageModel(isSendByMe: isMessageFromCurrentUser, content: message.content)
                cell.message = messageModel
            }
        }

        return cell
    }
    
}
