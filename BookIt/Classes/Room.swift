//
//  Room.swift
//  BookIt
//
//  Created by Steven Hurtado on 10/10/18.
//  Copyright © 2018 HCIGroup10. All rights reserved.
//

import Foundation

class Room : NSObject
{
    static let roomKey = "room"
    static let locationKey = "location"
    static let capacityKey = "capacity"
    
    var room : String?
    var location : String?
    var capacity : String?
    
    init(dict: NSDictionary)
    {
        print(dict)
        if let room = dict[Room.roomKey] as? String
        {
            self.room = room
        }
        
        if let location = dict[Room.locationKey] as? String
        {
            self.location = location
        }
        
        if let capacity = dict[Room.capacityKey] as? String
        {
            self.capacity = capacity
        }
    }
    
    
}
