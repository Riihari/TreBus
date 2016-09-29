//
//  MapViewDelegate.swift
//  TreBus
//
//  Created by Mikko Riihimäki on 31.8.2016.
//  Copyright © 2016 Mikko Riihimäki. All rights reserved.
//

import MapKit

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? BusAnnotation {
            var view: MKAnnotationView
            let identifier = "location"
            
            if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                dequedView.annotation = annotation
                view = dequedView
            } else {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
            }
            
            view.image = annotation.image
            
            return view
        }
        else if let annotation = annotation as? BusStopAnnotation {
            var view: MKAnnotationView
            let identifier = "stop"
            
            if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
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
    
    func updateBusStopAnnotations(_ annotations: [BusStopAnnotation]?) {
        if let annotations = annotations {
            DispatchQueue.main.async {
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotations(annotations)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let centerPoint = mapView.centerCoordinate;
        busStops.updateBusStops(location: centerPoint, callBack: updateBusStopAnnotations)
    }
}
