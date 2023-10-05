//
//  ProfileViewController.swift
//  FireBaseApp
//
//  Created by gayeugur on 16.10.2023.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileTableView: UITableView!
    let profileVM = ProfileModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    func configure() {
        profileTableView.delegate = self
        profileTableView.dataSource = self
    }

  

}
