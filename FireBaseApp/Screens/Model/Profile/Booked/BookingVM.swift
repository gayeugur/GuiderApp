//
//  BookingVM.swift
//  FireBaseApp
//
//  Created by gayeugur on 24.11.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class BookingVM {
    
    var bookedPlaces: [Place] = []
    
    var eventHandler: ((_ event: Constant.Event) -> Void)?
    
    func fetchAllGuidersInPlace(placeName: String) {
        self.eventHandler?(.loading)
        let fireStoreDatabase = Firestore.firestore()
        
        fireStoreDatabase.collection("BookedList").whereField("cityName", isEqualTo: placeName).getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.eventHandler?(.error(error))
            } else {
                guard let snapshot = snapshot else {
                    self.eventHandler?(.dataLoaded)
                    return
                }
                
                for document in snapshot.documents {
                    if let image = document.get("image") as? String, let date = document.get("date") as? String, let guiderName = document.get("guider") as? String, let price = document.get("price") as? Int, let rate = document.get("rate") as? Int   {
                        let place = Place(image: image, name: placeName, guider: guiderName, price: price, date: date, rate: rate)
                        bookedPlaces.append(place)
                    }
                }
                
                self.eventHandler?(.dataLoaded)
            }
        }
    }
    
    
    func addBlogData(place: Place?) {
        guard let place = place else {
            print("Error: Place object is nil")
            return
        }
        
        let db = Firestore.firestore()
        
        let blogCollection = db.collection("BookedList")
        
        let data: [String: Any] = [
            "cityName": place.name as Any,
            "date": place.date as Any,
            "guider": place.guider as Any,
            "image": place.image as Any,
            "price": place.price as Any,
            "rate": place.rate as Any
            
        ]
        
        blogCollection.addDocument(data: data) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID: \(blogCollection.document().documentID)")
            }
        }
    }
    
    
}
