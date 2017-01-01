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
    var annotations: Dictionary<String, BusStopAnnotation> = [:]
    
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
                self.parseBusStops(data: data)
                let annotationsArray = [BusStopAnnotation](self.annotations.values)
                callBack(annotationsArray)
            }
        }
    }
    
    func parseBusStops(data: [Dictionary<String, AnyObject>]) {
        for dict: Dictionary<String, AnyObject> in data {
            if let code = dict["code"] as? String, let name = dict["name"] as? String, let coords = dict["coords"] as? String {
                let coordinates = coords.components(separatedBy: ",")
                let longitude: Double = Double(coordinates[0])!
                let latitude: Double = Double(coordinates[1])!
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let annotation = BusStopAnnotation(name: name, location: coordinate, code: code)
                annotations[code] = annotation
                //print("Stops: \(annotations.count)")
            }
        }
    }
    
    func updateTimeTables(annotation: BusStopAnnotation, tableview: UITableView) {
        let httpHelper = HttpHelper()
        httpHelper.HTTPGetJSONArray("http://api.publictransport.tampere.fi/prod/?request=stop&code=\(annotation.code!)&user=\(user)&pass=\(pass)") {
            (data: [Dictionary<String, AnyObject>], error: String?) -> Void in
            if error != nil {
                print("Time table HTTP " + error!)
            } else {
                let timeTable = self.parseTimeTables(data: data)
                annotation.timeTable.removeAll()
                for (line, time) in timeTable {
                    annotation.timeTable.append("\(line) - \(time)")
                }
                DispatchQueue.main.async {
                    tableview.reloadData()
                }
            }
        }
    }
    
    func parseTimeTables(data: [Dictionary<String, AnyObject>]) -> [(String, String)] {
        var timeTable = [(String, String)]()
        for dict: Dictionary<String, AnyObject> in data {
            if let departures = dict["departures"] as? [Dictionary<String, AnyObject>] {
                for departure: Dictionary<String, AnyObject> in departures {
                    let line = departure["code"] as! String
                    var time = departure["time"] as! String
                    time.insert(":", at: time.index(time.startIndex, offsetBy: 2))
                    timeTable.append((line, time))
                }
            }
        }
        return timeTable
    }
}
