//
//  Place.swift
//  FireBaseApp
//
//  Created by gayeugur on 18.10.2023.
//
import Foundation

struct Place {
    
    var image: String? = nil
    var name: String? = nil
    var guider: String? = nil
    var price: Int? = nil
    var date: String? = nil
    var rate: Int? = nil
    var latitude: Double? = nil
    var longitude: Double? = nil
    var details: String? = nil
    
    
    
    init(name: String, latitude: Double, longitude: Double, details: String) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.details = details
    }
    
    init(image: String, name: String, guider: String, price: Int, date: String) {
        self.image = image
        self.name = name
        self.guider = guider
        self.price = price
        self.date = date
    }
    
    init(image: String, name: String, rate: Int, price: Int) {
        self.image = image
        self.name = name
        self.rate = rate
        self.price = price
    }
    
    init(image: String, name: String, guider: String, price: Int, date: String, rate: Int) {
        self.image = image
        self.name = name
        self.guider = guider
        self.price = price
        self.date = date
        self.rate = rate
    }
    
    init(image: String, name: String,  price: Int, rate: Int,latitude: Double, longitude: Double, details: String) {
        self.image = image
        self.name = name
        self.price = price
        self.rate = rate
        self.latitude = latitude
        self.longitude = longitude
        self.details = details
    }
    
    init(image: String, name: String) {
        self.image = image
        self.name = name
        self.guider = nil
        self.price = nil
        self.date = nil
    }
    
    
}
