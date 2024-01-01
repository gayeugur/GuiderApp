//
//  BlogViewController.swift
//  FireBaseApp
//
//  Created by gayeugur on 7.10.2023.
//

import UIKit
import FirebaseFirestore

class BlogViewController: UIViewController {
    
    //MARK: @IBOUTLET
    @IBOutlet weak var blogTableView: UITableView!
    
    //MARK: PROPERTIES
    let blogViewModel = BlogModel()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var blogs: [Blog] = []
    
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        blogTableView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configure()
    }
    
    //MARK: PRIVATE FUNCTION
    private func initTableView() {
        blogTableView.delegate = self
        blogTableView.dataSource = self
        blogTableView.register(UINib(nibName: "BlogTableViewCell", bundle: nil), forCellReuseIdentifier: "blogCell")
        blogTableView.separatorStyle = .none
    }
    
    private func configure() {
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        getFirebaseData()
    }
    
    
    private func getFirebaseData() {
        blogViewModel.fetchBlogData { result in
            switch result {
            case .success(let blogs):
                self.blogs = blogs
                self.activityIndicator.stopAnimating()
                self.blogTableView.reloadData()
                self.blogTableView.isHidden = false
            case .failure(let error):
                Constant.makeAlert(on: self, titleInput: "Error", messageInput: error.localizedDescription)
            }
        }
    }
    
}

//MARK: EXTENSION UITableViewDataSource
extension BlogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "blogCell") as? BlogTableViewCell else {
            return UITableViewCell()
        }
        cell.blog = blogs[indexPath.row]
        DispatchQueue.main.async {
            cell.stackView.isHidden = false
        }
        return cell
    }
    
}

//MARK: EXTENSION UITableViewDelegate
extension BlogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BlogDetailVC()
        vc.blog = blogs[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
