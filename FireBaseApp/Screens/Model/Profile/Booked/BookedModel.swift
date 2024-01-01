//
//  BookedModel.swift
//  FireBaseApp
//
//  Created by gayeugur on 30.10.2023.
//

import Foundation
import FirebaseFirestore

class BookedModel {
    var booked: [Place] = []
    
    var eventHandler: ((_ event: Constant.Event) -> Void)?
    
    func fetchBookedPlaces() {
        self.eventHandler?(.loading)
            
        Constant.fireStoreDatabase.collection("BookedList").order(by: "date", descending: true).addSnapshotListener { [self] (snapshot, error) in
            if error != nil {
                self.eventHandler?(.error(error))
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                        
                        if let name = document.get("guider") as? String, let image = document.get("image") as? String, let price = document.get("price") as? Int, let date = document.get("date") as? String {
                            
                            let place = Place(image: image, name: "" ,guider: name, price: price, date: date)
                            booked.append(place)
                            
                        }
                      
                    }
                    self.eventHandler?(.dataLoaded)
                }
                
            }
        }
    }
    
}

