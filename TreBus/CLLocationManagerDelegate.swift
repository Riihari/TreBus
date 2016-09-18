//
//  CLLocationManagerDelegate.swift
//  TreBus
//
//  Created by Mikko Riihimäki on 3.9.2016.
//  Copyright © 2016 Mikko Riihimäki. All rights reserved.
//

import MapKit

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        }
    }
}
