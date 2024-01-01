//
//  PlaceModel.swift
//  FireBaseApp
//
//  Created by gayeugur on 18.10.2023.
//
import Foundation
import FirebaseFirestore

class PlaceModel {
    
    var favoriPlaces: [Place] = []
    var allGuidersInPlace: [String] = []
    
    var eventHandler: ((_ event: Constant.Event) -> Void)?
    
    func fetchFavoritePlaces() {
        self.eventHandler?(.loading)
        let fireStoreDatabase = Firestore.firestore()
        
        fireStoreDatabase.collection("favoritePlaces").order(by: "name", descending: true).addSnapshotListener { [self] (snapshot, error) in
            if error != nil {
                self.eventHandler?(.error(error))
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                        
                        if let menuName = document.get("name") as? String, let menuIcon = document.get("image") as? String, let price = document.get("price") as? Int, let rate = document.get("rate") as? Int {
                            
                            let place = Place(image: menuIcon, name: menuName, rate: rate, price: price)
                            favoriPlaces.append(place)
                            
                        }
                    }
                    self.eventHandler?(.dataLoaded)
                }
                
            }
        }
    }
    
    func fetchAllGuidersInPlace(placeName: String, completion: @escaping (Bool) -> Void) {
        
        Constant.fireStoreDatabase.collection("guiders").whereField("placeName", isEqualTo: placeName).addSnapshotListener { [self] (snapshot, error) in
            if error != nil || snapshot?.isEmpty == true {
                completion(false)
            } else {
                for document in snapshot!.documents {
                    if let guiders = document.get("guiders") as? Array<String> {
                        allGuidersInPlace = guiders
                        completion(true)
                    }
                }
            }
            
        }
    }
    
}

