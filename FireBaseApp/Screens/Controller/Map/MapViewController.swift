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
    
    //MARK: LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        mapKit.delegate = self
        self.title = "Map"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchMapData()
    }
    
    //MARK: FUNCTIONS
    private func fetchMapData() {
        mapVM.fetchBlogData { result in
            switch result {
            case .success(let locations):
                self.locations = locations
                print("data here")
                for location in locations {
                    self.initLocations(latitude: location.latitude ?? 0, longitude: location.longitude ?? 0, name: location.name ?? "", details: location.details ?? "")
                }
            case .failure(let error):
                print("Hata oluştu: \(error.localizedDescription)")
            }
        }
        
        let istanbulLocation = CLLocation(latitude: 41.0082, longitude: 28.9784)
        let regionRadius: CLLocationDistance = 20000
        centerMapOnLocation(location: istanbulLocation, regionRadius: regionRadius)
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
            let alertController = UIAlertController(title: selectedLocation.name, message: selectedLocation.details , preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Add favorite list", style: .default) { action in
                if let selectedLocation = self.selectedLocation {
                    self.mapVM.addToFavorites(place: selectedLocation) { result in
                        switch result {
                        case .success(let message):
                            Constant.makeAlert(on: self, titleInput: message, messageInput: "")
                        case .failure(let error):
                            Constant.makeAlert(on: self, titleInput: error.localizedDescription, messageInput: "")
                        }
                    }
                }
            }
            
            let detailButton = UIAlertAction(title: "Close", style: .default, handler: nil)
            alertController.addAction(okAction)
            alertController.addAction(detailButton)
            present(alertController, animated: true, completion: nil)
        }
    }
    
  
}
