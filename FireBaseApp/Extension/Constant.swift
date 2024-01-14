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
    
    enum AddResultCases {
        case success(String)
        case failure(Error)
    }
    
    static let fireStoreDatabase = Firestore.firestore()
    
    static func makeAlert(on viewController: UIViewController, titleInput: String, messageInput: String, buttonAction: (() -> Void)? = nil) {
          let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { _ in
              buttonAction?()
          }
          alert.addAction(okButton)
          
          viewController.present(alert, animated: true, completion: nil)
      }
    
    static func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd yyyy"
        return formatter.string(from: date)
    }

}
