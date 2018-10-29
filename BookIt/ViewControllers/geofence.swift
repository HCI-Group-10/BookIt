//
//  geofence.swift
//  BookIt
//
//  Created by Chris Komarov on 10/29/18.
//  Followed tutorial: https://www.youtube.com/watch?v=r90Q-MHiBoI and https://blog.usejournal.com/geofencing-in-ios-swift-for-noobs-29a1c6d15dcc
//  needs key entered into info.p list

import Foundation
import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{
    let locationManger:CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManger.delegate = self
        locationManger.requestAlwaysAuthorization()
        locationManger.startUpdatingLocation()
        locationManger.distanceFilter = 100
        
        let geoFenceMarston:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(29.647973, -82.343867), radius: 100, identifier: "Marston")
        
        let geoFenceWest:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(29.651412, -82.342880), radius: 100, identifier: "West")
        
        let geoFenceEduLib:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(29.646664, -82.337789), radius: 100, identifier: "EduLib")
        
        
//        locationManager.startMonitoring(for: geoFenceMarston)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        //this will monitor for the region
        //use region.identifier to tell what/where
        //actions taken upon entering or exiting a region go here
    }
}
