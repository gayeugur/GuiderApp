//
//  User.swift
//  FireBaseApp
//
//  Created by gayeugur on 3.12.2023.
//
import Foundation

class User {
    var username: String? = nil
    let password: String
    var mail: String? = nil
    var isActive: Bool? = false
    
    init(username: String, password: String, mail: String, isActive: Bool? = false) {
        self.username = username
        self.password = password
        self.mail = mail
        self.isActive = isActive
    }
    
}
