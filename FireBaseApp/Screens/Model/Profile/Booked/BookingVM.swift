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

        // Create a reference to the Firestore collection where you want to store the data
        let blogCollection = db.collection("BookedList")

        // Create a dictionary representing the data you want to store
        let data: [String: Any] = [
            "cityName": place.name,
            "date": place.date,
            "guider": place.guider,
            "image": place.image,
            "price": place.price,
            "rate": place.rate
            // Add other fields as needed based on your 'Place' model
        ]

        // Add a new document with a generated ID to the 'BookedList' collection
        blogCollection.addDocument(data: data) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID: \(blogCollection.document().documentID)")
                // You can handle success cases here
            }
        }
    }


}
