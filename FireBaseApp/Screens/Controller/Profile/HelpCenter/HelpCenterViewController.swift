//
//  HelpCenterViewController.swift
//  FireBaseApp
//
//  Created by gayeugur on 26.10.2023.
//

import UIKit

class HelpCenterViewController: UIViewController {

    @IBOutlet weak var helpCenterTableView: UITableView!
    
    let helpCenterVM = HelpCenterModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        helpCenterTableView.dataSource = self
        helpCenterTableView.delegate = self
        helpCenterTableView.register(UINib(nibName: "HelpCenterTableViewCell", bundle: nil), forCellReuseIdentifier: "helpCell")
        getData()
        helpCenterTableView.separatorStyle = .none
    }
    
    func getData() {
        helpCenterVM.fetchProfileMenu()
        observeEvent()
    }
    
    func observeEvent() {
        helpCenterVM.eventHandler = { [weak self] event in
            guard let self else { return }

            switch event {
            case .loading:
                print("Product loading....")
            case .stopLoading:
                print("Stop loading...")
                
            case .dataLoaded:
                print("Data loaded...")
                DispatchQueue.main.async {
                    self.helpCenterTableView.reloadData()
                }
            
            case .error(let error):
                print(error ?? "ERROR")
            }
        }
    }
    
}

extension HelpCenterViewController: UITableViewDelegate {
    
}

extension HelpCenterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return helpCenterVM.helpCenterMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "helpCell") as? HelpCenterTableViewCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = helpCenterVM.helpCenterMenu[indexPath.row].name
        let image = UIImage(systemName: helpCenterVM.helpCenterMenu[indexPath.row].icon)
        cell.imageViewHelpCenter.image = image
        return cell
    }
   
    
    
}
