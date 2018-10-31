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
        }
    }
    
    static func getRoom(named: String, completion: @escaping (Room?) -> Void)
    {
        let db = Firestore.firestore()
        var room : Room? = nil
        db.collection("Rooms").document(named).getDocument { (document, error) in
            if let document = document, document.exists {
                room = Room(dict: document.data() as NSDictionary? ?? NSDictionary())
                completion(room)
            }
            else {
                print("Room doesn't exist")
            }
        }
    }
}
