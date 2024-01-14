//
//  MapModel.swift
//  FireBaseApp
//
//  Created by gayeugur on 9.12.2023.
//
import Foundation
import FirebaseFirestore

final class MapModel {
    
    func fetchBlogData(completion: @escaping (Constant.ResultCases<[Place]>) -> Void) {
        
        DatabaseManager.shared.fireStoreDatabase.collection("Place").getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                var fetchedLocations: [Place] = []
                
                for document in snapshot.documents {
                    if let lat = document.get("latitude") as? Double,
                       let long = document.get("longitude") as? Double,
                       let locName = document.get("name") as? String,
                       let detail = document.get("details") as? String,
                       let image = document.get("image") as? String,
                       let price = document.get("price") as? Int,
                       let rate = document.get("rate") as? Int{
                        
                        let loc = Place(image: image,
                                        name: locName,
                                        price: price,
                                        rate: rate,
                                        latitude: lat,
                                        longitude: long,
                                        details: detail)
                        fetchedLocations.append(loc)
                    }
                }
                completion(.success(fetchedLocations))
            } else {
                completion(.failure(Helper.createGenericError()))
            }
        }
    }
    
    
    func addToFavorites(place: Place, completion: @escaping (Constant.ResultCases<Bool>) -> Void) {
        
        let favoriteRef = DatabaseManager.shared.fireStoreDatabase.collection("favoritePlaces").document()
        
        let data: [String: Any] = [
            "image": (place.image ?? "") as String,
            "name": (place.name ?? "") as String,
            "price": (place.price ?? 0) as Int,
            "rate": (place.rate ?? 0) as Int,
            "latitude": (place.latitude ?? 0) as Double,
            "longitude": (place.longitude ?? 0) as Double
        ]
        
        favoriteRef.setData(data) { error in
            if error != nil {
                completion(.success(true))
            } else {
                completion(.failure(Helper.createGenericError()))
            }
        }
    }
}
