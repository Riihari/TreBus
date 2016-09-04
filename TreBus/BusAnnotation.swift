//
//  BusAnnotation.swift
//  TreBus
//
//  Created by Mikko Riihimäki on 31.8.2016.
//  Copyright © 2016 Mikko Riihimäki. All rights reserved.
//

import MapKit

class BusAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    var coordinate: CLLocationCoordinate2D
    let image: UIImage?
    let vehicleRef: String?
    
    init(lineRef: String, vehicleRef: String, location: CLLocationCoordinate2D, origin: String, destination: String) {
        self.title = lineRef
        self.subtitle = origin + " \u{279D} " + destination
        self.coordinate = location
        if let img = UIImage(named: "Bus_\(lineRef).png") {
            self.image = img
        } else {
            print(lineRef)
            self.image = UIImage(named: "bus.png")
        }
        self.vehicleRef = vehicleRef
        
        super.init()
    }
}   