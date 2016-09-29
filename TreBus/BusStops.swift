//
//  BusStops.swift
//  TreBus
//
//  Created by Mikko Riihimäki on 29.9.2016.
//  Copyright © 2016 Mikko Riihimäki. All rights reserved.
//

import Foundation
import MapKit

class BusStops: NSObject {
    var annotations = [BusStopAnnotation]()
    
    func updateBusStops(location: CLLocationCoordinate2D, callBack: @escaping ([BusStopAnnotation]?) -> Void) {
//    func updateBusStops(location: CLLocationCoordinate2D) -> Void {
        print("Get HTTP Get API data \(location.latitude), \(location.longitude)")
        
        let httpHelper = HttpHelper()
        
        httpHelper.HTTPGetJSONArray("http://api.publictransport.tampere.fi/prod/?request=stops_area&epsg_in=wgs84&epsg_out=wgs84&user=riihari&pass=bus2Track&center_coordinate=\(location.longitude),\(location.latitude)&diameter=5000") {
            (data: [Dictionary<String, AnyObject>], error: String?) -> Void in
            if error != nil {
                print(error)
            } else {
                self.parseBusStops(data: data)
                callBack(self.annotations)
            }
        }
    }
    
    func parseBusStops(data: [Dictionary<String, AnyObject>]) {
        for dict: Dictionary<String, AnyObject> in data {
            if let code = dict["code"] as? String, let name = dict["name"] as? String, let coords = dict["coords"] as? String {
                print("Code: \(code), Name: \(name), Coords: \(coords)")
                let coordinates = coords.components(separatedBy: ",")
                let longitude: Double = Double(coordinates[0])!
                let latitude: Double = Double(coordinates[1])!
                print("longitude: \(longitude), latitude: \(latitude)")
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let annotation = BusStopAnnotation(name: name, location: coordinate)
                annotations.append(annotation)
            }
        }
    }
}
