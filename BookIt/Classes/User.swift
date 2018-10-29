//
//  User.swift
//  BookIt
//
//  Created by Steven Hurtado on 10/12/18.
//  Copyright © 2018 HCIGroup10. All rights reserved.
//

import Foundation

class User
{
    private static var activeUser : User?
    var reservation : Reservation?
    
    var firstName : String?
    var lastName : String?
    var email : String?
    
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
