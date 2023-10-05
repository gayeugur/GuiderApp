//
//  BlogViewController.swift
//  FireBaseApp
//
//  Created by gayeugur on 7.10.2023.
//

import UIKit
import FirebaseFirestore

class BlogViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var blogTableView: UITableView!

    let blogViewModel = BlogModel()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blogTableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        blogViewModel.blogs.removeAll()
        getFirebaseData()
        configure()
        blogTableView.reloadData()
    }
    
    func configure() {
        blogTableView.delegate = self
        blogTableView.dataSource = self
        blogTableView.register(UINib(nibName: "BlogTableViewCell", bundle: nil), forCellReuseIdentifier: "blogCell")
        blogTableView.separatorStyle = .none
    }
    
    private func configure() {
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func getFirebaseData() {
        blogViewModel.fetchBlogData()
        observeEvent()
    }
    
    func observeEvent() {
        blogViewModel.eventHandler = { [weak self] event in
            guard let self else { return }

            switch event {
            case .loading:
                print("Product loading....")
                activityIndicator.startAnimating()
            case .stopLoading:
                print("Stop loading...")
                
            case .dataLoaded:
                print("Data loaded...")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.blogTableView.reloadData()
                }
            
            case .error(let error):
                print(error ?? "ERROR")
            }
        }
    }

}


extension BlogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogViewModel.blogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "blogCell") as? BlogTableViewCell else {
            return UITableViewCell()
        }
        cell.blog = blogViewModel.blogs[indexPath.row]
        cell.stackView.isHidden = false
        return cell
    }
    


    
}
