//
//  Constant.swift
//  FireBaseApp
//
//  Created by gayeugur on 14.10.2023.
//
import Foundation
import UIKit
import FirebaseFirestore

class Constant {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
    
    enum ProfileOptions: Int,Codable {
        case favorites = 1
        case chats = 2
        case logout = 6
        case helpCenter = 5
        case info = 4
        case booked = 3
    }
    
    
    enum ResultCases<T> {
        case success(T)
        case failure(Error)
    }

      
}
