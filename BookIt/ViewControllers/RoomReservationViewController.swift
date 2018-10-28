//
//  RoomReservationViewController.swift
//  BookIt
//
//  Created by Steven Hurtado on 10/12/18.
//  Copyright © 2018 HCIGroup10. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class RoomReservationViewController: UIViewController
{
    var reservation : Reservation?
    static let DEFAULT_VIEW_HEIGHT : CGFloat = 64.0
    let DEFAULT_BUTTON_WIDTH : CGFloat = 248.0
    let DEFAULT_BUTTON_HEIGHT : CGFloat = 48.0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setUpViews()
    }
    
    func setUpViews()
    {
        title = "Confirmation"
        edgesForExtendedLayout = []
        let container = UIView()
        view.backgroundColor = .white
        view.addSubview(container)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = 4.0
        container.backgroundColor = .bookItBlueLight
        container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        container.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        
        container.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -8).isActive = true
        
        let user = User.sharedInstance()
        
        let userTemplateLabel = UILabel()
        userTemplateLabel.font = Fonts.openSansLight
        userTemplateLabel.textColor = UIColor.white
        userTemplateLabel.text = "Name"
        
        let userNameLabel = UILabel()
        userNameLabel.font = Fonts.openSans
        userNameLabel.textColor = UIColor.white
        
        if let first = user?.firstName, let last = user?.lastName
        {
            userNameLabel.text = "\(first) \(last)"
        }
        
        container.addSubview(userTemplateLabel)
        container.addSubview(userNameLabel)
    
        let dateTemplateLabel = UILabel()
        dateTemplateLabel.font = Fonts.openSansLight
        dateTemplateLabel.textColor = UIColor.white
        dateTemplateLabel.text = "Date"
        
        let dateLabel = UILabel()
        dateLabel.font = Fonts.openSans
        dateLabel.textColor = UIColor.white
        dateLabel.textAlignment = .right
        
        if let date = reservation?.date
        {
            //format date
            dateLabel.text = date
        }
        
        container.addSubview(dateTemplateLabel)
        container.addSubview(dateLabel)
        
        let startTemplateLabel = UILabel()
        startTemplateLabel.font = Fonts.openSansLight
        startTemplateLabel.textColor = UIColor.white
        startTemplateLabel.text = "Start Time"
        
        let startLabel = UILabel()
        startLabel.font = Fonts.openSans
        startLabel.textColor = UIColor.white
        startLabel.textAlignment = .right
        
        if let startTime = reservation?.startTime
        {
            //format time
            startLabel.text = startTime
        }
        
        container.addSubview(startTemplateLabel)
        container.addSubview(startLabel)
        
        let endTemplateLabel = UILabel()
        endTemplateLabel.font = Fonts.openSansLight
        endTemplateLabel.textColor = UIColor.white
        endTemplateLabel.text = "End Time"
        
        let endLabel = UILabel()
        endLabel.font = Fonts.openSans
        endLabel.textColor = UIColor.white
        endLabel.textAlignment = .right
        
        if let endTime = reservation?.endTime
        {
            //format time
            endLabel.text = endTime
        }
        
        container.addSubview(endTemplateLabel)
        container.addSubview(endLabel)
        
        let roomLabel = UILabel()
        roomLabel.font = Fonts.openSans
        roomLabel.textColor = .white
        roomLabel.numberOfLines = 0
        
        let locationLabel = UILabel()
        locationLabel.font = Fonts.openSansLight.withSize(16)
        locationLabel.textColor = .white
        locationLabel.numberOfLines = 0
        
        let capacityLabel = UILabel()
        capacityLabel.font = Fonts.openSansLight.withSize(16)
        capacityLabel.textColor = .white
        capacityLabel.numberOfLines = 0
        
        if let reservation = reservation, let room = reservation.room, let roomName = room.room, let roomNum = room.roomNumber, let roomLocation = room.location, let roomCapacity = room.capacity
        {
            roomLabel.text = "\(roomName)"
            locationLabel.text = "Location: \(roomLocation) \(roomNum)"
            capacityLabel.text = "Capacity: \(roomCapacity)"
        }
        
        container.addSubview(roomLabel)
        container.addSubview(locationLabel)
        container.addSubview(capacityLabel)
        
        let reserveButton = UIButton()
        reserveButton.backgroundColor = .clear
        reserveButton.layer.cornerRadius = 4.0
        reserveButton.layer.borderColor = UIColor.bookItBlueLight.cgColor
        reserveButton.layer.borderWidth = 1.0
        
        reserveButton.setTitleColor(.bookItBlueLight, for: .normal)
        reserveButton.setTitle("Confirm Reservation", for: .normal)
        reserveButton.titleLabel?.numberOfLines = 0
        
        view.addSubview(reserveButton)
        reserveButton.addTarget(self, action: #selector(reserveButtonPressed), for: .touchUpInside)
        roomLabel.translatesAutoresizingMaskIntoConstraints = false
        roomLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8).isActive = true
        roomLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8).isActive = true
        roomLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16).isActive = true
        
        reserveButton.translatesAutoresizingMaskIntoConstraints = false
        
        reserveButton.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 16).isActive = true
        reserveButton.heightAnchor.constraint(equalToConstant: DEFAULT_BUTTON_HEIGHT).isActive = true
        reserveButton.widthAnchor.constraint(equalToConstant: DEFAULT_BUTTON_WIDTH).isActive = true
        reserveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8).isActive = true
        locationLabel.topAnchor.constraint(equalTo: roomLabel.bottomAnchor).isActive = true
        
        capacityLabel.translatesAutoresizingMaskIntoConstraints = false
        capacityLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8).isActive = true
        capacityLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8).isActive = true
        capacityLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor).isActive = true

        userTemplateLabel.translatesAutoresizingMaskIntoConstraints = false
        userTemplateLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8).isActive = true
        userTemplateLabel.trailingAnchor.constraint(equalTo: userNameLabel.leadingAnchor, constant: -8).isActive = true
        userTemplateLabel.topAnchor.constraint(equalTo: capacityLabel.bottomAnchor, constant: 16).isActive = true
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: capacityLabel.bottomAnchor, constant: 16).isActive = true
        
        dateTemplateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateTemplateLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8).isActive = true
        dateTemplateLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -8).isActive = true
        dateTemplateLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 16).isActive = true
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8).isActive = true
        dateLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 16).isActive = true
        
        startTemplateLabel.translatesAutoresizingMaskIntoConstraints = false
        startTemplateLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8).isActive = true
        startTemplateLabel.trailingAnchor.constraint(equalTo: startLabel.leadingAnchor, constant: -8).isActive = true
        startTemplateLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16).isActive = true

        startLabel.translatesAutoresizingMaskIntoConstraints = false
        startLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8).isActive = true
        startLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16).isActive = true

        endTemplateLabel.translatesAutoresizingMaskIntoConstraints = false
        endTemplateLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8).isActive = true
        endTemplateLabel.trailingAnchor.constraint(equalTo: endLabel.leadingAnchor, constant: -8).isActive = true
        endTemplateLabel.topAnchor.constraint(equalTo: startLabel.bottomAnchor, constant: 16).isActive = true
        endTemplateLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16).isActive
            = true
        
        endLabel.translatesAutoresizingMaskIntoConstraints = false
        endLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8).isActive = true
        endLabel.topAnchor.constraint(equalTo: startLabel.bottomAnchor, constant: 16).isActive = true
        endLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16).isActive
            = true

        container.heightAnchor.constraint(greaterThanOrEqualToConstant: RoomReservationViewController.DEFAULT_VIEW_HEIGHT).isActive = true
    }
    
    @objc func reserveButtonPressed(){
        let db = Firestore.firestore()
        guard let room = reservation?.room else { return }

//        var timesArray = room?.times
        
        let startTimeArr = reservation?.startTime?.split(separator: ":")
        let endTimeArr = reservation?.endTime?.split(separator: ":")
        
        var startTimeIndex = Int(startTimeArr![0])! * 2
        if Int(startTimeArr![1])! >= 30{
            startTimeIndex = startTimeIndex + 1
        }
        
        var endTimeIndex = Int(endTimeArr![0])! * 2
        if Int(endTimeArr![1])! >= 30{
            endTimeIndex = endTimeIndex + 1
        }
        let user = User.sharedInstance()
//        var indexInTimes = 0
        for i in 0..<(room.times?.count ?? 0){
            let dictionary = room.times?[i] as! NSMutableDictionary
            guard var timeSlots = dictionary["timeSlots"] as? [String] else { return }
            
            guard let date: Timestamp = dictionary["date"] as? Timestamp else { return }
            let myDate: Date = date.dateValue()
            let dateString = self.getDate(myDate: myDate)
            if(dateString == reservation?.date)
            {
//                indexInTimes = i
                for j in startTimeIndex..<endTimeIndex
                {
                    print(j)
                    timeSlots[j] =  (user?.email)!
                }
//                dictionary["timeSlots"]![i]["times"] = reservations
                print(timeSlots)
                dictionary["timeSlots"] = timeSlots
                room.times?[i] = dictionary
            }
        }
        
//        print(room?.times)
        db.collection("Rooms").document(room.room!).updateData([ "times": room.times ])
        
        Util.presentAlert(title: "reserve button pressed", message: "hello", viewController: self)
    }
    
    func getDate(myDate: Date) -> String
    {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: Date()) // string purpose I add here
        // convert your string to date
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        let myStringafd = formatter.string(from: myDate)
        
        //        print("converting")
        //        print(myStringafd)
        return myStringafd
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
