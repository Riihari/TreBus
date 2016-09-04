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
    func updateBusInformation(callBack: ([BusAnnotation]?) -> Void) {
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

    func parseBusLocations(data: Dictionary<String, AnyObject>) -> Void {
        guard let feed = data["Siri"] as? NSDictionary else {
            return
        }
        
        guard let service = feed["ServiceDelivery"] as? NSDictionary else {
            return
        }
        
        guard let entries = service["VehicleMonitoringDelivery"] as? NSArray else {
            return
        }
        
        for elem: AnyObject in entries {
            guard let activities = elem["VehicleActivity"] as? NSArray else {
                return
            }
            
            for activity: AnyObject in activities {
                guard let journey = activity["MonitoredVehicleJourney"] as? NSDictionary else {
                    return
                }
                
                guard let vehicleLoc = journey["VehicleLocation"] as? NSDictionary, let lineRef = journey["LineRef"] as? NSDictionary, let vehicleRef = journey["VehicleRef"], let destinationRef = journey["DestinationName"] as? NSDictionary, let originRef = journey["OriginName"] as? NSDictionary else {
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