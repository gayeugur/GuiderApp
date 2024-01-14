//
//  BookedModel.swift
//  FireBaseApp
//
//  Created by gayeugur on 30.10.2023.
//

import Foundation
import FirebaseFirestore

class BookedModel {
    
    func fetchBookedPlaces(completion: @escaping (Constant.ResultCases<[Place]>) -> Void) {
            
        DatabaseManager.shared.fireStoreDatabase.collection("BookedList").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                completion(.failure(error ?? Helper.createGenericError()))
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    var booked: [Place] = []
                    for document in snapshot!.documents {
                        
                        if let name = document.get("guider") as? String, let image = document.get("image") as? String, let price = document.get("price") as? Int, let date = document.get("date") as? String {
                            
                            let place = Place(image: image, name: "" ,guider: name, price: price, date: date)
                            booked.append(place)
                            
                        }
                      
                    }
                    completion(.success(booked))
                }
                
            }
        }
    }
    
}

