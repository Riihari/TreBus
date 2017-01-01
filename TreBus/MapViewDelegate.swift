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
            var view: BusStopAnnotationView
            let identifier = "stop"
            
            if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                dequedView.annotation = annotation
                view = dequedView as! BusStopAnnotationView
            } else {
                view = BusStopAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = false
            }
            
            view.image = annotation.image
            return view
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let centerPoint = mapView.centerCoordinate;
        busStops.updateBusStops(location: centerPoint, callBack: updateBusStopAnnotations)
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        if(view.annotation is MKUserLocation) {
            // Don't proceed with custom callout
            return
        }

        if(view.annotation is BusAnnotation) {
            return
        }
        
        let annotation = view.annotation as! BusStopAnnotation
        let views = Bundle.main.loadNibNamed("TimeTableCallout", owner: nil, options: nil)
        let calloutView = views?[0] as! TimeTableCallout
        
        calloutView.busStopAnnotation = annotation
        
        calloutView.titleLabel.text = annotation.title
        calloutView.timeTable.delegate = calloutView
        calloutView.timeTable.dataSource = calloutView

        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
        view.addSubview(calloutView)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
        
        busStops.updateTimeTables(annotation: annotation, tableview: calloutView.timeTable)
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if(view.isKind(of: BusStopAnnotationView.self)) {
            for subview in view.subviews {
                subview.removeFromSuperview()
            }
        }
    }
}
