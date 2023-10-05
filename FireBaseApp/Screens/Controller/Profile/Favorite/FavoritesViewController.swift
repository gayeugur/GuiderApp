//
//  FavoritesViewController.swift
//  FireBaseApp
//
//  Created by gayeugur on 18.10.2023.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var favoritesTableView: UITableView!
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var favoritePlacesVM = PlaceModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RouterManager.shared.currentNavigationController = navigationController
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favoritePlacesVM.favoriPlaces.removeAll()
        getFirebaseData()
        setTableViewConfigure()
        favoritesTableView.reloadData()
        self.title = "Favorites"
        
    }

    private func setTableViewConfigure() {
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self
        favoritesTableView.register(UINib(nibName: "FavoritesTableViewCell", bundle: nil), forCellReuseIdentifier: "favoritesCell")
        favoritesTableView.separatorStyle = .none
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func getFirebaseData() {
        favoritePlacesVM.fetchFavoritePlaces()
        observeEvent()
    }
    func observeEvent() {
        favoritePlacesVM.eventHandler = { [weak self] event in
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
                    self.favoritesTableView.reloadData()
                }
            
            case .error(let error):
                print(error ?? "ERROR")
            }
        }
    }

}
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePlacesVM.favoriPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell") as? FavoritesTableViewCell else {
            return UITableViewCell()
        }
        cell.place = favoritePlacesVM.favoriPlaces[indexPath.row]
        return cell
    }
  
    
}
extension FavoritesViewController: UITableViewDelegate {
    
}

