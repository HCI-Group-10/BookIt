//
//  Room.swift
//  BookIt
//
//  Created by Steven Hurtado on 10/10/18.
//  Copyright © 2018 HCIGroup10. All rights reserved.
//

import Foundation
import FirebaseFirestore

class Room : NSObject
{
    static let roomKey = "room"
    static let roomNumberKey = "roomNumber"
    static let locationKey = "location"
    static let capacityKey = "capacity"
    static let timeKey = "times"
    
    var room : String?
    var roomNumber : String?
    var location : String?
    var capacity : Int?
    var times : NSMutableArray?
    
    init(dict: NSDictionary)
    {
//        print(dict)
        if let room = dict[Room.roomKey] as? String
        {
            self.room = room
//            print("assigning")
//            print(self.room)
        }
        
        if let roomNumber = dict[Room.roomNumberKey] as? String
        {
            self.roomNumber = roomNumber
        }
        
        if let location = dict[Room.locationKey] as? String
        {
            self.location = location
        }
        
        if let capacity = dict[Room.capacityKey] as? Int
        {
            self.capacity = capacity
        }
        if let times = dict[Room.timeKey] as? NSMutableArray
        {
            self.times = times
//            print("assigned times")
//            print((self.times?[0] as! NSDictionary)["date"])
//            let timestamp: Timestamp = (self.times?[0] as! NSDictionary)["date"] as! Timestamp
//            let myDate: Date = timestamp.dateValue()
            
            
//            let formatter = DateFormatter()
//            // initially set the format based on your datepicker date / server String
//            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            
//            let myString = formatter.string(from: Date()) // string purpose I add here
//            // convert your string to date
//            let yourDate = formatter.date(from: myString)
//            //then again set the date format whhich type of output you need
//            formatter.dateFormat = "dd-MMM-yyyy"
//            // again convert your date to string
//            let myStringafd = formatter.string(from: myDate)
//            
//            print(myStringafd)
        }
    }
    
    
}
