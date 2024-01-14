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
    var favoritePlaces: [Place] = []
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFirebaseData()
    }
    
    //MARK: PRIVATE FUNCTION
    private func configure() {
        self.title = "Favorites"
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self
        favoritesTableView.register(UINib(nibName: "FavoritesTableViewCell", bundle: nil), forCellReuseIdentifier: "favoritesCell")
        favoritesTableView.separatorStyle = .none
    }
    
    private func setTableViewConfigure() {
        favoritesTableView.reloadData()
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func getFirebaseData() {
        favoritePlaces.removeAll()
        self.activityIndicator.startAnimating()
        favoritePlacesVM.fetchFavoritePlaces() { result in
            switch result {
            case .success(let places):
                self.favoritePlaces = places
                self.activityIndicator.stopAnimating()
                self.favoritesTableView.reloadData()
                
            case .failure(let error):
                self.activityIndicator.stopAnimating()
                Helper.makeAlert(on: self,
                                 titleInput: ConstantMessages.errorTitle,
                                 messageInput: error.localizedDescription)
            }
        }
        setTableViewConfigure()
    }
    
    
    
    private func createPlace(placeNumber index: Int) -> Place {
        return Place(image: favoritePlaces[index].image ?? "",
                     name: favoritePlaces[index].name ?? "",
                     rate: favoritePlaces[index].rate  ?? 0,
                     price: favoritePlaces[index].price ?? 0)
    }
}

//MARK: EXTENSION UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell") as? FavoritesTableViewCell else {
            return UITableViewCell()
        }
        cell.place = favoritePlaces[indexPath.row]
        
        //when click Show Guiders button
        cell.showGuidersAction = {
            guard let placeName = self.favoritePlaces[indexPath.row].name else { return }
            self.favoritePlacesVM.fetchAllGuidersInPlace(placeName: placeName) { [weak self] success in
                guard let self = self else { return }
                switch success {
                    
                case true:
                   // self.observeEvent()
                    let guidersList = self.favoritePlacesVM.allGuidersInPlace.map { String($0)
                    }.joined(separator: ", ")
                    Helper.makeAlert(on: self,
                                     titleInput: ConstantMessages.guiderTitle,
                                     messageInput: guidersList)
                    activityIndicator.stopAnimating()
                    
                case false:
                    Helper.makeAlert(on: self,
                                     titleInput: ConstantMessages.guiderTitle,
                                     messageInput: ConstantMessages.genericErrorNotFound)
                    activityIndicator.stopAnimating()
                }
            }
            
        }
        //when click Book button
        cell.bookedAction = {
            let selectedPlace = self.createPlace(placeNumber: indexPath.row)
            let vc = BookingVC(place: selectedPlace)
            RouterManager.shared.currentNavigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    
}
//MARK: EXTENSION UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
             cell.contentView.backgroundColor = UIColor(hex: 0xD6EAF8)
         }
         tableView.deselectRow(at: indexPath, animated: true)
    }
}

