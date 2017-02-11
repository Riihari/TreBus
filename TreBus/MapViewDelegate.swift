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
            
            let calloutView = UIView()
            
            let calloutTableView = UITableView(frame: CGRect(x: 0, y: 0, width: 200, height: 100), style: .plain)
            calloutTableView.delegate = annotation
            calloutTableView.dataSource = annotation
            
            calloutView.addSubview(calloutTableView)

            let tableWidthConstraint = NSLayoutConstraint(item: calloutTableView, attribute: .width, relatedBy: .lessThanOrEqual, toItem: calloutView, attribute: .width, multiplier: 1, constant: 0)
            calloutView.addConstraint(tableWidthConstraint)
            let tableHeightConstraint = NSLayoutConstraint(item: calloutView, attribute: .height, relatedBy: .lessThanOrEqual, toItem: calloutView, attribute: .width, multiplier: 1, constant: 0)
            calloutView.addConstraint(tableHeightConstraint)

           let widthConstraint = NSLayoutConstraint(item: calloutView, attribute: .width, relatedBy: .equal, toItem: nil,attribute: .notAnAttribute, multiplier: 1, constant: 200)
            calloutView.addConstraint(widthConstraint)
            let heightConstraint = NSLayoutConstraint(item: calloutView, attribute: .height, relatedBy: .equal, toItem: nil,attribute: .notAnAttribute, multiplier: 1, constant: 100)
            calloutView.addConstraint(heightConstraint)

            view.detailCalloutAccessoryView = calloutView
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            view.image = annotation.image
            
            busStops.updateTimeTables(annotation: annotation, tableview: calloutTableView)

            return view
        }
        
        return nil
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let centerPoint = mapView.centerCoordinate;
        busStops.updateBusStops(location: centerPoint, callBack: updateBusStopAnnotations)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation = view.annotation as! BusStopAnnotation
        self.detailedStop = annotation.code!
        performSegue(withIdentifier: "TimetableSegue", sender: self)
    }
}
