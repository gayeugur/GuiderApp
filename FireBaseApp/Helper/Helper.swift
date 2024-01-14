//
//  Helper.swift
//  FireBaseApp
//
//  Created by gayeugur on 12.01.2024.
//

import Foundation
import UIKit

 class Helper {
     
     //MARK: FUNCTIONS
     
     // create alert
    static func makeAlert(on viewController: UIViewController, titleInput: String, messageInput: String, buttonAction: (() -> Void)? = nil) {
          let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { _ in
              buttonAction?()
          }
          alert.addAction(okButton)
          
          viewController.present(alert, animated: true, completion: nil)
      }
     
     // converts date type to string for year
     static func formatDate(date: Date) -> String {
         let formatter = DateFormatter()
         formatter.dateFormat = "MMMM dd yyyy"
         return formatter.string(from: date)
     }
     
     static func createGenericError() -> NSError {
         let unknownError = NSError(domain: "Unknown", code: -1, userInfo: [NSLocalizedDescriptionKey: "An unknown error occurred"])
         return unknownError
     }
}
