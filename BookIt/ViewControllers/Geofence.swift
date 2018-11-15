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

protocol GeofenceDelegate
{
    func enteredRegion()
    func exitedRegion()
}

class Geofence: NSObject, CLLocationManagerDelegate
{
    var delegate : GeofenceDelegate!
    let dateFormatter = DateFormatter()
    let locationManager:CLLocationManager = CLLocationManager()
    let MONITOR_DISTANCE : CLLocationDistance = 40.0
    
    var reservation : Reservation?
    override init()
    {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = MONITOR_DISTANCE
    }
    
    func monitorReservation(reservation: Reservation)
    {
        
        var geofence : CLCircularRegion?
        self.reservation = reservation
        guard let room = reservation.room else { return }
        guard let location = room.location else { return }
        switch(location)
        {
        case "Marston":
            geofence = CLCircularRegion(center: CLLocationCoordinate2DMake(29.647973, -82.343867), radius: 100, identifier: location)
            break
        case "Library West":
            geofence = CLCircularRegion(center: CLLocationCoordinate2DMake(29.651412, -82.342880), radius: 100, identifier: location)
            break
        case "Education Library":
            geofence = CLCircularRegion(center: CLLocationCoordinate2DMake(29.646664, -82.337789), radius: 100, identifier: location)
            break
        default:
            break
        }
        
        if let geofence = geofence {
            if let coor = locationManager.location?.coordinate
            {
                print(geofence.contains(coor))
            }
            delegate.enteredRegion()
            locationManager.startMonitoring(for: geofence)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion)
    {
        //this will monitor for the region
        //use region.identifier to tell what/where
        //actions taken upon entering or exiting a region go here
        
        guard let location = reservation?.room?.location else { return }
        
        switch(region.identifier)
        {
        case "Marston":
            print("I'M IN MARSTON")
            break
        case "Library West":
            print("I'M IN WEST")
            break
        case "Education Library":
            print("I'M IN EduLib")
            break
        default:
            return
        }
        
        if location == region.identifier
        {
            print("WE GOT A MATCH")
            delegate.enteredRegion()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion)
    {
        guard let reservation = reservation else { return }
        guard let room = reservation.room else { return }
        guard let location = room.location else { return }
        
        switch(region.identifier)
        {
        case "Marston":
            print("JUST LEFT MARSTON")
            break
        case "Library West":
            print("JUST LEFT WEST")
            break
        case "Education Library":
            print("JUST LEFT EduLib")
            break
        default:
            return
        }
        
        if location == region.identifier
        {
            print("WE GOT A MATCH")
            
            dateFormatter.dateFormat = "dd-MMM-YYYY"
            
            // verify day
            let currDate = Date()
            if let reservationDateStr = reservation.date
            {
                let currDateString = dateFormatter.string(from: currDate)
                print("DATE: \(currDateString == reservationDateStr)")
             
                if currDateString != reservationDateStr
                {
                    return
                }
                // verify end time
                dateFormatter.dateFormat = "h:mm a"
                if let endTimeStr = reservation.endTime
                {
                    if let endTime = dateFormatter.date(from: endTimeStr), currDate.time < endTime.time
                    {
                        delegate.exitedRegion()
                    }
                }
            }
        }
    }
}
