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
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    init(username: String, password: String, mail: String) {
        self.username = username
        self.password = password
        self.mail = mail
    }
    
    init(password: String, mail: String) {
        self.password = password
        self.mail = mail
    }
}
