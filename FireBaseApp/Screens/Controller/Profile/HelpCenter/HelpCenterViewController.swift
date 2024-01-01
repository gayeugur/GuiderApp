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
    var expandedRows = Set<Int>()
    var deneme = false
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        getData()
        self.title = "Help Center"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initActivityView()
    }
    
    //MARK: PRIVATE FUNCTION
    private func initTableView() {
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
        helpCenterVM.fetchProfileMenu()
        observeEvent()
    }
    
    private func observeEvent() {
        helpCenterVM.eventHandler = { [weak self] event in
            guard let self else { return }

            switch event {
            case .loading:
                activityIndicator.startAnimating()
            case .stopLoading:
                break
            case .dataLoaded:
                DispatchQueue.main.async {
                    self.helpCenterTableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            case .error(let error):
                print(error ?? "ERROR")
            }
        }
    }
    
}
//MARK: EXTENSION UITableViewDataSource
extension HelpCenterViewController: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return helpCenterVM.helpCenterMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "helpCell", for: indexPath) as! HelpCenterTableViewCell
        
        cell.titleLabel.text = helpCenterVM.helpCenterMenu[indexPath.row].name
        cell.labelDetail.text = helpCenterVM.helpCenterMenu[indexPath.row].detail
        
            if self.expandedRows.contains(indexPath.row) {
                cell.viewDetail.isHidden = false
            } else {
                cell.viewDetail.isHidden = true
            }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if expandedRows.contains(indexPath.row) {
            return 150
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if expandedRows.contains(indexPath.row) {
            expandedRows.remove(indexPath.row)
        } else {
            expandedRows.insert(indexPath.row)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
   

    
}
