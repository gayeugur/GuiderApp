//
//  UserManager.swift
//  FireBaseApp
//
//  Created by gayeugur on 5.12.2023.
//

import Foundation

class UserManager {
    static let shared = UserManager()

    private init() {}

    var currentUser: User?

    func setUser(user: User) {
        self.currentUser = user
    }

    func clearUser() {
        self.currentUser = nil
    }
}
