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
    var menu: [Menu] = []
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    //MARK: LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        getData()
        initActivity()
        RouterManager.shared.currentNavigationController = navigationController
    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    
    //MARK: FUNCTIONS
    func configure() {
        self.title = "Profile"
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "profileCell")
        profileTableView.separatorStyle = .none
    }
    
    private func initActivity() {
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func getData() {
        self.activityIndicator.startAnimating()
        profileVM.fetchProfileMenu() { result in
            switch result {
            case .success(let allMenu):
                self.menu = allMenu
                self.activityIndicator.stopAnimating()
                self.profileTableView.reloadData()
            case .failure(let error):
                self.activityIndicator.stopAnimating()
                Helper.makeAlert(on: self,
                                 titleInput: ConstantMessages.errorTitle,
                                 messageInput: error.localizedDescription)
            }
        }
    }

}


//MARK: UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
             cell.contentView.backgroundColor = UIColor(hex: 0xD6EAF8)
         }
         tableView.deselectRow(at: indexPath, animated: true)
        RouterManager.shared.navigateSelectedMenu(item: indexPath.row + 1)
        if (Constant.ProfileOptions.logout.rawValue == indexPath.row + 1) {
            performSegue(withIdentifier: "toSign", sender: nil)
        }
    }
}

//MARK: UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell") as? ProfileTableViewCell else {
            return UITableViewCell()
        }
        cell.profile = menu[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
}
