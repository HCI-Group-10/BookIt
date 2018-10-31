//
//  User.swift
//  BookIt
//
//  Created by Steven Hurtado on 10/12/18.
//  Copyright © 2018 HCIGroup10. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol UserReservationDelegate
{
    func reservationReceived(reservation: Reservation?)
}

class User
{
    private static var activeUser : User?
    var reservation : Reservation?
    var delegate : UserReservationDelegate!
    
    var firstName : String?
    var lastName : String?
    var email : String?
    
    func getReservation() -> Reservation?
    {
        guard let email = email else { return self.reservation }
        let db = Firestore.firestore()
        db.collection("Reservation").document(email).getDocument { (document, error) in
            if let document = document, document.exists {
                guard let dict = document.data() else { return }
                self.reservation = Reservation()
                self.reservation?.date = dict["date"] as? String ?? ""
                
                if let start = dict["start"] as? Int, let end = dict["end"] as? Int
                {
                    self.reservation?.startTime = String.getTimeFormattedFrom30MinIntervalValue(val: start)
                    
                    self.reservation?.endTime = String.getTimeFormattedFrom30MinIntervalValue(val: end)
                }
                
                if let roomName = dict["room"] as? String
                {
                    Room.getRoom(named: roomName, completion: { (room) in
                        self.reservation?.room = room
                        self.delegate.reservationReceived(reservation: self.reservation)
                    })
                }
                else
                {
                    print("No valid reservation")
                    self.reservation = nil
                    self.delegate.reservationReceived(reservation: self.reservation)
                }
            }
            else {
                print("User doesn't exist")
            }
        }
        
        return reservation
    }
    
    static func createUser(firstName: String, lastName: String, email: String = "")
    {
        activeUser = User()
        assignName(firstName: firstName, lastName: lastName)
        assignEmail(email: email)
    }
    
    static func assignName(firstName: String, lastName: String)
    {
        activeUser?.firstName = firstName
        activeUser?.lastName = lastName
    }
    
    static func assignEmail(email: String)
    {
        activeUser?.email = email
    }
    
    static func sharedInstance() -> User?
    {
        return activeUser
    }
}
