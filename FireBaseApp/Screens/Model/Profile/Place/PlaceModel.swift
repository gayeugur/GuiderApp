//
//  PlaceModel.swift
//  FireBaseApp
//
//  Created by gayeugur on 18.10.2023.
//
import Foundation
import FirebaseFirestore

class PlaceModel {
    
    var allGuidersInPlace: [String] = []
       
    func fetchFavoritePlaces(completion: @escaping (Constant.ResultCases<[Place]>) -> Void) {

        DatabaseManager.shared.fireStoreDatabase.collection("favoritePlaces").order(by: "name", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                completion(.failure(error ?? Helper.createGenericError()))
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    var favoriPlaces: [Place] = []
                    for document in snapshot!.documents {
                        
                        if let menuName = document.get("name") as? String, let menuIcon = document.get("image") as? String, let price = document.get("price") as? Int, let rate = document.get("rate") as? Int {
                            
                            let place = Place(image: menuIcon, name: menuName, rate: rate, price: price)
                            favoriPlaces.append(place)
                            
                        }
                    }
                    completion(.success(favoriPlaces))
                }
                
            }
        }
    }
    
    func fetchAllGuidersInPlace(placeName: String, completion: @escaping (Bool) -> Void) {
        
        DatabaseManager.shared.fireStoreDatabase.collection("guiders").whereField("placeName", isEqualTo: placeName).addSnapshotListener { [self] (snapshot, error) in
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

