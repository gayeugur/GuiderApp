//
//  ProfileViewController.swift
//  FireBaseApp
//
//  Created by gayeugur on 16.10.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //MARK: @IBOUTLET
    @IBOutlet weak var profileTableView: UITableView!
    
    //MARK: PROPERTIES
    let profileVM = ProfileModel()
    
    
    //MARK: LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        RouterManager.shared.currentNavigationController = navigationController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        profileVM.allMenu.removeAll()
        getData()
        configure()
        profileTableView.reloadData()
    }
    
    //MARK: FUNCTIONS
    func configure() {
        self.title = "Profile"
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "profileCell")
        
    }
    
    func getData() {
        profileVM.fetchProfileMenu()
        observeEvent()
    }
    
    func observeEvent() {
        profileVM.eventHandler = { [weak self] event in
            guard let self else { return }
            switch event {
            case .loading:
                print("Product loading....")
            case .stopLoading:
                print("Stop loading...")
                
            case .dataLoaded:
                print("Data loaded...")
                DispatchQueue.main.async {
                    self.profileTableView.reloadData()
                }
            case .error(let error):
                print(error ?? "ERROR")
            }
        }
    }
}

//MARK: UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        RouterManager.shared.pushMenu(item: indexPath.row + 1)
        if (Constant.ProfileOptions.logout.rawValue == indexPath.row + 1) {
            performSegue(withIdentifier: "toSign", sender: nil)
        }
    }
}

//MARK: UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileVM.allMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell") as? ProfileTableViewCell else {
            return UITableViewCell()
        }
        cell.profile = profileVM.allMenu[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
}
