//
//  RouterManager.swift
//  FireBaseApp
//
//  Created by gayeugur on 19.10.2023.
//

import Foundation
import UIKit
import FirebaseAuth


class RouterManager {

    static let shared = RouterManager()
      
      private init() {}
      
      var currentNavigationController: UINavigationController?
    
    func pushMenu(item: Int) {
        switch item {
        case Constant.ProfileOptions.favorites.rawValue:
            print("favori")
            let vc = FavoritesViewController()
            RouterManager.shared.currentNavigationController?.pushViewController(vc, animated: true)
            
        case Constant.ProfileOptions.chats.rawValue:
            print("chats")
            let vc = ChatsViewController()
            RouterManager.shared.currentNavigationController?.pushViewController(vc, animated: true)
            
        case Constant.ProfileOptions.logout.rawValue:
            print("logout")
            do {
                try Auth.auth().signOut()
                print("Kullanıcı çıkış yaptı")
            } catch let signOutError as NSError {
                print("Kullanıcı çıkış yaparken hata oluştu: \(signOutError.localizedDescription)")
            }
           
            
        case Constant.ProfileOptions.helpCenter.rawValue:
            print("helpCenter")
            let vc = HelpCenterViewController()
            RouterManager.shared.currentNavigationController?.pushViewController(vc, animated: true)
            
        case Constant.ProfileOptions.info.rawValue:
            print("info")
            let vc = SettingsViewController()
            RouterManager.shared.currentNavigationController?.pushViewController(vc, animated: true)
            
        case Constant.ProfileOptions.booked.rawValue:
            print("booked")
            let vc = BookedViewController()
            RouterManager.shared.currentNavigationController?.pushViewController(vc, animated: true)
        default:
            print("here")
        }
    }
}

