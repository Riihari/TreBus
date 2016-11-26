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
    var user = ""
    var pass = ""
    
    func readCredentials() {
        guard let path = Bundle.main.path(forResource: "credentials", ofType: "txt") else {
            print("No password file!")
            return
        }
        do {
            let content = try String(contentsOfFile: path)
            let credentials = content.components(separatedBy: "\n")
            user = credentials[0]
            pass = credentials[1]
        }
        catch {
            print("Error reading password file")
        }
    }
    
    func updateBusStops(location: CLLocationCoordinate2D, callBack: @escaping ([BusStopAnnotation]?) -> Void) {
        let httpHelper = HttpHelper()
        
        httpHelper.HTTPGetJSONArray("http://api.publictransport.tampere.fi/prod/?request=stops_area&epsg_in=wgs84&epsg_out=wgs84&user=\(user)&pass=\(pass)&center_coordinate=\(location.longitude),\(location.latitude)&diameter=5000") {
            (data: [Dictionary<String, AnyObject>], error: String?) -> Void in
            if error != nil {
                print("BusStop HTTP " + error!)
            } else {
                let annotations = self.parseBusStops(data: data)
                callBack(annotations)
            }
        }
    }
    
    func parseBusStops(data: [Dictionary<String, AnyObject>]) -> [BusStopAnnotation] {
        var annotations = [BusStopAnnotation]()
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
        return annotations
    }
}
