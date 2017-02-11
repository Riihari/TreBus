//
//  MapViewController.swift
//  TreBus
//
//  Created by Mikko Riihimäki on 1.5.2016.
//  Copyright © 2016 Mikko Riihimäki. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    var busLocation = BusLocation()
    var busStops = BusStops()
    var timer = Timer()
    var locationMgr = CLLocationManager()
    var detailedStop = String()
 
    @IBOutlet weak var mapView: MKMapView!

    @IBAction func centerUserLocationPressed(_ sender: AnyObject) {
        mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
    }

    func updateAnnotations(_ annotations: [BusAnnotation]?) {
        if let updatedAnnotations = annotations {
            DispatchQueue.main.async {
                var obsoleteAnnotations = self.busLocation.locationAnnotations

                var newAnnotations: [BusAnnotation] = []

                for updatedAnnotation in updatedAnnotations {

                    // Find matching annotation reference in MapView
                    let annotationIndex = self.mapView.annotations.index(where: { (match: MKAnnotation) -> Bool in
                        guard let existingBusAnnotation = match as? BusAnnotation else {
                            return false
                        }
                        return updatedAnnotation.vehicleRef!.compare(existingBusAnnotation.vehicleRef!) == ComparisonResult.orderedSame
                    })

                    // Update coordinate only
                    if (annotationIndex != nil) {
                        let existingAnnotation: BusAnnotation? = self.mapView.annotations[annotationIndex!] as? BusAnnotation

                        UIView.animate(withDuration: 1, delay: 0.0, options: [.curveLinear], animations: {
                            existingAnnotation!.coordinate.longitude = updatedAnnotation.coordinate.longitude
                            existingAnnotation!.coordinate.latitude = updatedAnnotation.coordinate.latitude
                        }, completion: nil)

                        // Remove from the to-be-removed annotations list
                        let obsoleteIndex = obsoleteAnnotations.index(where: { (match) -> Bool in
                            return match.vehicleRef!.compare(updatedAnnotation.vehicleRef!) == ComparisonResult.orderedSame
                        })
                        if (obsoleteIndex != nil) {
                            obsoleteAnnotations.remove(at: obsoleteIndex!)
                        }
                    }
                    // Add new annotation
                    else {
                        newAnnotations.append(updatedAnnotation)
                    }
                }

                self.mapView.removeAnnotations(obsoleteAnnotations)
                self.mapView.addAnnotations(newAnnotations)

                self.busLocation.setLocationAnnotation(annotations: updatedAnnotations)
            }
        }
    }

    func updateBusLocation() {
        busLocation.updateBusInformation(updateAnnotations)
    }
    
    func updateBusStopAnnotations(_ annotations: [BusStopAnnotation]?) {
        if let annotations = annotations {
            DispatchQueue.main.async {
                self.mapView.addAnnotations(annotations)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationMgr.delegate = self

        // Do any additional setup after loading the view.
        // 23.845548451994,61.484973207634 (Somewhere in Tampere)
        let location = CLLocationCoordinate2D(latitude: 61.484973207634, longitude: 23.845548451994)
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
        
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateBusLocation), userInfo: nil, repeats: true)
        
        busStops.readCredentials()
        
        checkLocationAuthorizationStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Bussikartta"
    }

    // MARK: - Segmented control for map types
    enum MapType: Int {
        case standard = 0
        case satellite
        case hybrid
    }
    
    @IBAction func mapTypeChanged(_ sender: UISegmentedControl) {
        let mapType = MapType(rawValue: sender.selectedSegmentIndex)
        switch (mapType!) {
        case .standard:
            mapView.mapType = MKMapType.standard
        case .satellite:
            mapView.mapType = MKMapType.satellite
        case .hybrid:
            mapView.mapType = MKMapType.hybrid
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TimetableViewController
        destination.stop = detailedStop
    }
    
    // MARK: - Location manager to authorize user location for Maps app
    func checkLocationAuthorizationStatus () {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        }
        else {
            locationMgr.requestWhenInUseAuthorization()
        }
    }
    
    @IBAction func fromTimetable(segue: UIStoryboardSegue) {
    }
}
