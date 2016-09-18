//
//  BusLocation.swift
//  TreBus
//
//  Created by Mikko Riihimäki on 30.8.2016.
//  Copyright © 2016 Mikko Riihimäki. All rights reserved.
//

import Foundation
import MapKit

class BusLocation: NSObject {
    
    var annotations = [BusAnnotation]()
    
    // MARK: HTTP and JSON to get traffic data
    func updateBusInformation(_ callBack: @escaping ([BusAnnotation]?) -> Void) {
        let httpHelper = HttpHelper()
    
        httpHelper.HTTPGetJSON("http://data.itsfactory.fi/siriaccess/vm/json") {
            (data: Dictionary<String, AnyObject>, error: String?) -> Void in
            if error != nil {
                print(error)
                callBack(nil)
            } else {
                self.annotations.removeAll()
                self.parseBusLocations(data)
                callBack(self.annotations)
            }
        }
    }

    func parseBusLocations(_ data: [String: Any]) -> Void {
        guard let feed = data["Siri"] as? [String: Any] else {
            return
        }
        
        guard let service = feed["ServiceDelivery"] as? [String: Any] else {
            return
        }
        
        guard let entries = service["VehicleMonitoringDelivery"] as? [[String: Any]] else {
            return
        }
        
        for entry in entries {
            guard let activities = entry["VehicleActivity"] as? [[String: Any]] else {
                return
            }
            
            for activity in activities {
                guard let journey = activity["MonitoredVehicleJourney"] as? NSDictionary else {
                    return
                }
                
                guard let vehicleLoc = journey["VehicleLocation"] as? NSDictionary, let lineRef = journey["LineRef"] as? NSDictionary, let vehicleRef = journey["VehicleRef"] as? NSDictionary, let destinationRef = journey["DestinationName"] as? NSDictionary, let originRef = journey["OriginName"] as? NSDictionary else {
                    return
                }
                
                guard let line = lineRef["value"] as? String, let latitude = vehicleLoc["Latitude"] as? Double, let longitude = vehicleLoc["Longitude"] as? Double, let vehicle = vehicleRef["value"] as? String, let destination = destinationRef["value"] as? String, let origin = originRef["value"] as? String else {
                    return
                }

                let annotationLoc = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let annotation = BusAnnotation(lineRef: line, vehicleRef: vehicle, location: annotationLoc, origin: origin, destination: destination)

                self.annotations.append(annotation)
            }
        }
    }
}
