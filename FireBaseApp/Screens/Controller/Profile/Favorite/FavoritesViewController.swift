//
//  FavoritesViewController.swift
//  FireBaseApp
//
//  Created by gayeugur on 18.10.2023.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    //MARK: @IBOUTLET
    @IBOutlet weak var favoritesTableView: UITableView!
    
    //MARK: PROPERTIES
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var favoritePlacesVM = PlaceModel()
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favoritePlacesVM.favoriPlaces.removeAll()
        getFirebaseData()
        setTableViewConfigure()
        self.title = "Favorites"
    }
    
    //MARK: PRIVATE FUNCTION
    private func initTableView() {
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self
        favoritesTableView.register(UINib(nibName: "FavoritesTableViewCell", bundle: nil), forCellReuseIdentifier: "favoritesCell")
    }

    private func setTableViewConfigure() {
        favoritesTableView.reloadData()
        favoritesTableView.separatorStyle = .none
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func getFirebaseData() {
        favoritePlacesVM.fetchFavoritePlaces()
        observeEvent()
    }
    
    private func observeEvent() {
        favoritePlacesVM.eventHandler = { [weak self] event in
            guard let self else { return }
            switch event {
            case .loading:
                activityIndicator.startAnimating()
            case .stopLoading:
                break
            case .dataLoaded:
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

//MARK: EXTENSION UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePlacesVM.favoriPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell") as? FavoritesTableViewCell else {
            return UITableViewCell()
        }
        cell.place = favoritePlacesVM.favoriPlaces[indexPath.row]
        DispatchQueue.main.async {
            cell.guidersButton.isHidden = false
            cell.bookButton.isHidden = false
        }
        cell.showGuidersAction = {
            
            self.favoritePlacesVM.fetchAllGuidersInPlace(placeName: self.favoritePlacesVM.favoriPlaces[indexPath.row].name ?? "") { [weak self] success in
                guard let self = self else { return }
                   if success {
                       self.observeEvent()
                       print(self.favoritePlacesVM.allGuidersInPlace)
                       let arrayText = self.favoritePlacesVM.allGuidersInPlace.map { String($0) }.joined(separator: ", ")
                       Constant.makeAlert(on: self, titleInput: "Rehberler", messageInput: arrayText)
                       activityIndicator.stopAnimating()
                   } else {
                       Constant.makeAlert(on: self, titleInput: "Rehberler", messageInput: "Guider bulunamadı")
                       activityIndicator.stopAnimating()
                   }
            }

        }
        cell.bookedAction = {
            let place = Place(image: self.favoritePlacesVM.favoriPlaces[indexPath.row].image ?? "", name: self.favoritePlacesVM.favoriPlaces[indexPath.row].name ?? "", rate: self.favoritePlacesVM.favoriPlaces[indexPath.row].rate  ?? 0, price: self.favoritePlacesVM.favoriPlaces[indexPath.row].price ?? 0)
            let vc = BookingVC(place: place)
            RouterManager.shared.currentNavigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
  
    
}
//MARK: EXTENSION UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate { }

