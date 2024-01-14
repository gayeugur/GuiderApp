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
    
    //open the selected menu
    func navigateSelectedMenu(item: Int) {
        switch item {
        case Constant.ProfileOptions.favorites.rawValue:
            
            let vc = FavoritesViewController()
            RouterManager.shared.currentNavigationController?.pushViewController(vc, animated: true)
            
        case Constant.ProfileOptions.chats.rawValue:
            let vc = ChatsViewController()
            vc.completion = { [weak self] result in
                print(result)
                self?.createNewConversation(result: result)
            }
            RouterManager.shared.currentNavigationController?.pushViewController(vc, animated: true)
            
        case Constant.ProfileOptions.logout.rawValue:
            do {
                try Auth.auth().signOut()
                UserManager.shared.clearUser()
            } catch _ as NSError {
                let vc = MapViewController()
                RouterManager.shared.currentNavigationController?.pushViewController(vc, animated: true)
                Helper.makeAlert(on: vc, titleInput: ConstantMessages.errorTitle, messageInput: ConstantMessages.signOutError)
            }
            
        case Constant.ProfileOptions.helpCenter.rawValue:
            let vc = HelpCenterViewController()
            RouterManager.shared.currentNavigationController?.pushViewController(vc, animated: true)
            
        case Constant.ProfileOptions.info.rawValue:
            let vc = SettingsViewController()
            RouterManager.shared.currentNavigationController?.pushViewController(vc, animated: true)
            
        case Constant.ProfileOptions.booked.rawValue:
            let vc = BookedViewController()
            RouterManager.shared.currentNavigationController?.pushViewController(vc, animated: true)
        default:
            let vc = MapViewController()
            RouterManager.shared.currentNavigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // chat selected user
    private func createNewConversation(result: Chat) {
        let vc = ChatViewController()
        vc.title = result.name
        vc.navigationItem.largeTitleDisplayMode = .never
        currentNavigationController?.pushViewController(vc, animated: true)
    }
    
}

