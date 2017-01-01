//
//  BusStopAnnotation.swift
//  TreBus
//
//  Created by Mikko Riihimäki on 29.9.2016.
//  Copyright © 2016 Mikko Riihimäki. All rights reserved.
//

import MapKit

class BusStopAnnotation: NSObject, MKAnnotation {
    let title: String?
    var coordinate: CLLocationCoordinate2D
    let image: UIImage?
    var timeTable: [String] = []
    let code: String?
    
    init(name: String, location: CLLocationCoordinate2D, code: String) {
        self.title = name
        self.coordinate = location
        self.image = UIImage(named: "busstop.png")
        self.code = code
        
        super.init()
    }
}
