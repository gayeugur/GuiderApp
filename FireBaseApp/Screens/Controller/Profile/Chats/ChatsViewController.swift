//
//  ChatsViewController.swift
//  FireBaseApp
//
//  Created by gayeugur on 28.10.2023.
//

import UIKit

class ChatsViewController: UIViewController {
    
    //MARK: @IBOUTLET
    @IBOutlet weak var chatsTableView: UITableView!
    
    //MARK: PROPERTIES
    public var completion: ((Chat) -> (Void))?
    let chatVM = ChatModel()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var chatList: [Chat] = []
    
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        getData()
    }
    
    //MARK: PRIVATE FUNCTION
    private func initUI() {
        self.title = "Chats"
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        initTableView()
    }
    
    private func initTableView() {
        chatsTableView.delegate = self
        chatsTableView.dataSource = self
        chatsTableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "chatCell")
        chatsTableView.separatorStyle = .none
    }
    
    private func getData() {
        self.activityIndicator.startAnimating()
        chatVM.fetchChatList() { result in
            switch result {
            case .success(let chats):
                self.chatList = chats
                self.activityIndicator.stopAnimating()
                self.chatsTableView.reloadData()
            case .failure(let error):
                self.activityIndicator.stopAnimating()
                Helper.makeAlert(on: self,
                                 titleInput: ConstantMessages.errorTitle,
                                 messageInput: error.localizedDescription)
            }
        }
    }
    
    
}

//MARK: EXTENSION UITableViewDataSource
extension ChatsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell") as? ChatTableViewCell else {
            return UITableViewCell()
        }
        cell.chat =  chatList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

//MARK: EXTENSION UITableViewDelegate
extension ChatsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
             cell.contentView.backgroundColor = UIColor(hex: 0xD6EAF8)
         }
         tableView.deselectRow(at: indexPath, animated: true)
        let selectedChat = chatList[indexPath.row]
        dismiss(animated: true, completion: { [weak self] in
            self?.completion?(selectedChat)
        })
    }
}
