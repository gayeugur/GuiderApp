//
//  MapViewController.swift
//  FireBaseApp
//
//  Created by gayeugur on 15.10.2023.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    //MARK: @IBOUTLET
    @IBOutlet weak var mapKit: MKMapView!
    
    //MARK: PROPERTIES
    let mapVM = MapModel()
    var locations: [Place] = []
    var selectedLocation: Place?
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    //MARK: LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        mapKit.delegate = self
        self.title = "Map"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configure()
        fetchMapData()
    }
    
    //MARK: FUNCTIONS
    private func configure() {
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func fetchMapData() {
        self.activityIndicator.startAnimating()
        mapVM.fetchBlogData { result in
            switch result {
            case .success(let locations):
                self.locations = locations
                for location in locations {
                    self.initLocations(latitude: location.latitude ?? 0,
                                       longitude: location.longitude ?? 0,
                                       name: location.name ?? "",
                                       details: location.details ?? "")
                }
                self.activityIndicator.stopAnimating()
            case .failure(let error):
                self.activityIndicator.stopAnimating()
                Helper.makeAlert(on: self,
                                 titleInput: ConstantMessages.errorTitle,
                                 messageInput: error.localizedDescription)
            }
        }
        
        let location = CLLocation(latitude: 41.0082, longitude: 28.9784)
        let regionRadius: CLLocationDistance = 20000
        centerMapOnLocation(location: location, regionRadius: regionRadius)
    }
    
    private func initLocations(latitude: Double, longitude: Double, name: String, details: String) {
        let locationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        annotation.title = name
        mapKit.addAnnotation(annotation)
    }
    
    private func centerMapOnLocation(location: CLLocation, regionRadius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        mapKit.setRegion(coordinateRegion, animated: true)
    }
    
}

//MARK: MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if let annotation = view.annotation as? MKPointAnnotation {
            if let selectedPlace = locations.first(where: { $0.latitude == annotation.coordinate.latitude && $0.longitude == annotation.coordinate.longitude }) {
                selectedLocation = selectedPlace
            }
        }
        
        if let selectedLocation = selectedLocation {
            Helper.makeAlert(on: self,
                             titleInput: ConstantMessages.successTitle,
                             messageInput: ConstantMessages.addFavorite,
                             buttonAction: { [weak self] in
                self?.actionButtonAction(selectedLocation: selectedLocation)
            })
        }
    }
    
    func actionButtonAction(selectedLocation: Place) {
        self.mapVM.addToFavorites(place: selectedLocation) { result in
            switch result {
            case .success(_):
                Helper.makeAlert(on: self,
                                 titleInput: ConstantMessages.successTitle,
                                 messageInput: ConstantMessages.successDetail)
            case .failure(let error):
                Helper.makeAlert(on: self,
                                 titleInput: ConstantMessages.errorTitle,
                                 messageInput: error.localizedDescription)
            }
        }
    }
    
}
