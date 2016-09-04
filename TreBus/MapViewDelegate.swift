//
//  MapViewDelegate.swift
//  TreBus
//
//  Created by Mikko Riihimäki on 31.8.2016.
//  Copyright © 2016 Mikko Riihimäki. All rights reserved.
//

import MapKit

extension MapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? BusAnnotation {
            var view: MKAnnotationView
            let identifier = "pin"
            
            if let dequedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) {
                dequedView.annotation = annotation
                view = dequedView
            } else {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
            }
            
            view.image = annotation.image
            
            return view
        }
        
        return nil
    }
}
