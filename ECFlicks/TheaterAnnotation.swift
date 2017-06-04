//
//  TheaterAnnotation.swift
//  ECFlicks
//
//  Created by EricDev on 6/2/17.
//  Copyright © 2017 EricDev. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class TheaterAnnotation: NSObject, MKAnnotation {
    
    let name: String
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let address: String?
    
    init(item: MKMapItem) {
        
        name = item.name!
        coordinate = item.placemark.coordinate
        title = name
        address = item.placemark.title
        
    }
    
    var subtitle: String? {
        
        return address!.replacingOccurrences(of: ", United States", with: "")
        
    }
    
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(CNPostalAddressStreetKey): subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
}
