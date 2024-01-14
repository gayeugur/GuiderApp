//
//  HelpCenterViewController.swift
//  FireBaseApp
//
//  Created by gayeugur on 26.10.2023.
//

import UIKit

class HelpCenterViewController: UIViewController {
    
    //MARK: @IBOUTLET
    @IBOutlet weak var helpCenterTableView: UITableView!
    
    //MARK: PROPERTIES
    let helpCenterVM = HelpCenterModel()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var helpCenterMenu: [Menu] = []
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initActivityView()
    }
    
    //MARK: PRIVATE FUNCTION
    private func initTableView() {
        self.title = "Help Center"
        helpCenterTableView.dataSource = self
        helpCenterTableView.delegate = self
        helpCenterTableView.register(UINib(nibName: "HelpCenterTableViewCell", bundle: nil), forCellReuseIdentifier: "helpCell")
        helpCenterTableView.separatorStyle = .none
    }
    
    private func initActivityView() {
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func getData() {
        self.activityIndicator.startAnimating()
        helpCenterVM.fetchProfileMenu() { result in
            switch result {
            case .success(let menu):
                self.helpCenterMenu = menu
                self.helpCenterTableView.reloadData()
                self.activityIndicator.stopAnimating()
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
extension HelpCenterViewController:  UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return helpCenterMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "helpCell", for: indexPath) as! HelpCenterTableViewCell
        cell.menu =  helpCenterMenu[indexPath.row]
        cell.viewDetail.isHidden = !helpCenterVM.expandedRows.contains(indexPath.row)
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return helpCenterVM.expandedRows.contains(indexPath.row) ? 150 : 60
    }
    

}

extension HelpCenterViewController: UITableViewDelegate, expandedProtocol {
    func expandedClicked(index: Int) {
        if helpCenterVM.expandedRows.contains(index) {
            helpCenterVM.expandedRows.remove(index)
        } else {
            helpCenterVM.expandedRows.insert(index)
        }
        helpCenterTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}
