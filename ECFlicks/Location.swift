
//
//  Location.swift
//  WeatherApp
//
//  Created by EricDev on 5/18/17.
//  Copyright © 2017 EricDev. All rights reserved.
//
import CoreLocation

class Location {
    static var sharedInstance = Location()
    private init() {}
    var latitude: Double!
    var longitude: Double!
}
