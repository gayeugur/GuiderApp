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
    let chatVM = ChatModel()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        getData()
        initNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initActivityView()
    }
    
    //MARK: PRIVATE FUNCTION
    private func initNavBar() {
        self.title = "Chats"
    }
    
    private func initActivityView() {
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func initTableView() {
        chatsTableView.delegate = self
        chatsTableView.dataSource = self
        chatsTableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "chatCell")
        chatsTableView.separatorStyle = .none
    }
    
    private func getData() {
        chatVM.fetchChatList()
        observeEvent()
    }
    
    //MARK: FUNCTION
    func observeEvent() {
        chatVM.eventHandler = { [weak self] event in
            guard let self else { return }

            switch event {
            case .loading:
                activityIndicator.startAnimating()
            case .stopLoading:
                break
            case .dataLoaded:
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.chatsTableView.reloadData()
                }
            case .error(let error):
                print(error ?? "ERROR")
            }
        }
    }
  
}

//MARK: EXTENSION UITableViewDataSource
extension ChatsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatVM.chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell") as? ChatTableViewCell else {
            return UITableViewCell()
        }
        cell.chat =  chatVM.chatList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

//MARK: EXTENSION UITableViewDelegate
extension ChatsViewController: UITableViewDelegate {}
