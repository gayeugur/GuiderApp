//
//  DatabaseManager.swift
//  FireBaseApp
//
//  Created by gayeugur on 12.01.2024.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore
import FirebaseStorage

class DatabaseManager {

    static let shared = DatabaseManager()
    
    private init() {}
    
    
    let database = Database.database().reference()
    let fireStoreDatabase = Firestore.firestore()
    let storageRef = Storage.storage().reference()
}
