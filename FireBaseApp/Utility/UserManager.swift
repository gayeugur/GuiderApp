//
//  UserManager.swift
//  FireBaseApp
//
//  Created by gayeugur on 5.12.2023.
//

import Foundation

class UserManager {
    
    static let shared = UserManager()
    
    let userModel = UserModel()

    private init() {}

    var currentUser: User?

    func setUser(user: User) {
        user.isActive = true
        self.currentUser = user
    }

    func clearUser() {
        DispatchQueue.main.async {
            self.userModel.updateActiveStatus(isActive: false) { result in
                switch result {
                case .success(_):
                    self.currentUser = nil
                case .failure(_):
                    self.currentUser = nil
                }
            }
        }
    }
}
