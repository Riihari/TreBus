//
//  CLLocationManagerDelegate.swift
//  TreBus
//
//  Created by Mikko Riihimäki on 3.9.2016.
//  Copyright © 2016 Mikko Riihimäki. All rights reserved.
//

import MapKit

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
            mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
        }
    }
}