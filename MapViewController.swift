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
    var timer = NSTimer()
    var locationMgr = CLLocationManager()
 
    @IBOutlet weak var mapView: MKMapView!

    @IBAction func centerUserLocationPressed(sender: AnyObject) {
        mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
    }

    func updateAnnotations(annotations: [BusAnnotation]?) {
        if let annotations = annotations {
            dispatch_async(dispatch_get_main_queue()) {
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotations(annotations)
            }
        }
    }

    func updateBusLocation() {
        busLocation.updateBusInformation(updateAnnotations)
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
        
        timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(updateBusLocation), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    // MARK: - Segmented control for map types
    
    enum MapType: Int {
        case Standard = 0
        case Satellite
        case Hybrid
    }
    
    @IBAction func mapTypeChanged(sender: UISegmentedControl) {
        let mapType = MapType(rawValue: sender.selectedSegmentIndex)
        switch (mapType!) {
        case .Standard:
            mapView.mapType = MKMapType.Standard
        case .Satellite:
            mapView.mapType = MKMapType.Satellite
        case .Hybrid:
            mapView.mapType = MKMapType.Hybrid
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Location manager to authorize user location for Maps app
    func checkLocationAuthorizationStatus () {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
            mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
        }
        else {
            locationMgr.requestWhenInUseAuthorization()
        }
    }
}
