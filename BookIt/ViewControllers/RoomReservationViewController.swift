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
    var userNameLabel : UILabel?
    var dateLabel : UILabel?
    var startLabel : UILabel?
    var endLabel : UILabel?
    
    var reservation : Reservation?
    {
        didSet {
            let user = User.sharedInstance()
            if let first = user?.firstName, let last = user?.lastName
            {
                if userNameLabel == nil {
                    userNameLabel = UILabel()
                }
                userNameLabel?.text = "\(first) \(last)"
            }
            
            if let date = reservation?.date
            {
                if dateLabel == nil {
                    dateLabel = UILabel()
                }
                //format date
                dateLabel?.text = date
            }
            if let startTime = reservation?.startTime
            {
                if startLabel == nil {
                    startLabel = UILabel()
                }
                //format time
                startLabel?.text = startTime
            }
            
            if let endTime = reservation?.endTime
            {
                if endLabel == nil {
                    endLabel = UILabel()
                }
                //format time
                endLabel?.text = endTime
            }
            
        }
    }
    static let DEFAULT_VIEW_HEIGHT : CGFloat = 64.0
    let DEFAULT_BUTTON_WIDTH : CGFloat = 248.0
    let DEFAULT_BUTTON_HEIGHT : CGFloat = 48.0
    
    var cancelReservationButton : UIButton?
    var reservationButton : UIButton?
    var switchReservationButton : UIButton?
    var fromUserPage = false
    {
        didSet {
            cancelReservationButton?.isHidden = !fromUserPage
            reservationButton?.isHidden = fromUserPage
            switchReservationButton?.isHidden = true
        }
    }
    
    var fromScan = false
    {
        didSet
        {
            cancelReservationButton?.isHidden = true
            reservationButton?.isHidden = false
            switchReservationButton?.isHidden = true
        }
    }
    
    var isBooked = false
    {
        didSet
        {
            switchReservationButton?.isHidden = isBooked
            reservationButton?.isHidden = !isBooked
            cancelReservationButton?.isHidden = true
        }
    }
    
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
        container.backgroundColor = .white
        container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        container.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        
        container.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -8).isActive = true
        
        let userTemplateLabel = UILabel()
        userTemplateLabel.font = Fonts.openSansLight
        userTemplateLabel.textColor = UIColor.bookItBlueDark
        userTemplateLabel.text = "Name"
        
        if userNameLabel == nil {
            userNameLabel = UILabel()
        }
        
        guard let userNameLabel = userNameLabel else { return }
        userNameLabel.font = Fonts.openSans
        userNameLabel.textColor = UIColor.bookItBlueDark
        
        container.addSubview(userTemplateLabel)
        container.addSubview(userNameLabel)
    
        let dateTemplateLabel = UILabel()
        dateTemplateLabel.font = Fonts.openSansLight
        dateTemplateLabel.textColor = UIColor.bookItBlueDark
        dateTemplateLabel.text = "Date"
        
        if dateLabel == nil {
            dateLabel = UILabel()
        }
        guard let dateLabel = dateLabel else { return }
        dateLabel.font = Fonts.openSans
        dateLabel.textColor = UIColor.bookItBlueDark
        dateLabel.textAlignment = .right
        
        container.addSubview(dateTemplateLabel)
        container.addSubview(dateLabel)
        
        let startTemplateLabel = UILabel()
        startTemplateLabel.font = Fonts.openSansLight
        startTemplateLabel.textColor = UIColor.bookItBlueDark
        startTemplateLabel.text = "Start Time"
        
        if startLabel == nil {
            startLabel = UILabel()
        }
        guard let startLabel = startLabel else { return }
        startLabel.font = Fonts.openSans
        startLabel.textColor = UIColor.bookItBlueDark
        startLabel.textAlignment = .right
        
        container.addSubview(startTemplateLabel)
        container.addSubview(startLabel)
        
        let endTemplateLabel = UILabel()
        endTemplateLabel.font = Fonts.openSansLight
        endTemplateLabel.textColor = UIColor.bookItBlueDark
        endTemplateLabel.text = "End Time"
        
        if endLabel == nil {
            endLabel = UILabel()
        }
        guard let endLabel = endLabel else { return }
        endLabel.font = Fonts.openSans
        endLabel.textColor = UIColor.bookItBlueDark
        endLabel.textAlignment = .right
        
        container.addSubview(endTemplateLabel)
        container.addSubview(endLabel)
        
        reservationButton = UIButton()
        guard let reserveButton = reservationButton else { return }
        reserveButton.backgroundColor = .clear
        reserveButton.layer.cornerRadius = 4.0
        reserveButton.layer.borderColor = UIColor.bookItBlueLight.cgColor
        reserveButton.layer.borderWidth = 1.0
        
        reserveButton.setTitleColor(.bookItBlueLight, for: .normal)
        reserveButton.setTitle("Confirm Reservation", for: .normal)
        reserveButton.titleLabel?.numberOfLines = 0
        reserveButton.addTarget(self, action: #selector(reserveButtonPressed), for: .touchUpInside)
        view.addSubview(reserveButton)
        
        reserveButton.translatesAutoresizingMaskIntoConstraints = false
        
        reserveButton.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 16).isActive = true
        reserveButton.heightAnchor.constraint(equalToConstant: DEFAULT_BUTTON_HEIGHT).isActive = true
        reserveButton.widthAnchor.constraint(equalToConstant: DEFAULT_BUTTON_WIDTH).isActive = true
        reserveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        switchReservationButton = UIButton()
        guard let switchButton = switchReservationButton else { return }
        switchButton.backgroundColor = .clear
        switchButton.layer.cornerRadius = 4.0
        switchButton.layer.borderColor = UIColor.bookItBlueLight.cgColor
        switchButton.layer.borderWidth = 1.0
        
        switchButton.setTitleColor(.bookItBlueLight, for: .normal)
        switchButton.setTitle("Request To Swap", for: .normal)
        switchButton.titleLabel?.numberOfLines = 0
        switchButton.addTarget(self, action: #selector(reserveButtonPressed), for: .touchUpInside)
        view.addSubview(switchButton)
        
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        
        switchButton.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 16).isActive = true
        switchButton.heightAnchor.constraint(equalToConstant: DEFAULT_BUTTON_HEIGHT).isActive = true
        switchButton.widthAnchor.constraint(equalToConstant: DEFAULT_BUTTON_WIDTH).isActive = true
        switchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        cancelReservationButton = UIButton()
        guard let cancelButton = cancelReservationButton else { return }
        cancelButton.backgroundColor = .clear
        cancelButton.layer.cornerRadius = 4.0
        cancelButton.layer.borderColor = UIColor.red.cgColor
        cancelButton.layer.borderWidth = 1.0

        cancelButton.setTitleColor(.red, for: .normal)
        cancelButton.setTitle("Cancel Reservation", for: .normal)
        cancelButton.titleLabel?.numberOfLines = 0
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        view.addSubview(cancelButton)

        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 16).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: DEFAULT_BUTTON_HEIGHT).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: DEFAULT_BUTTON_WIDTH).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        userTemplateLabel.translatesAutoresizingMaskIntoConstraints = false
        userTemplateLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8).isActive = true
        userTemplateLabel.trailingAnchor.constraint(equalTo: userNameLabel.leadingAnchor, constant: -8).isActive = true
        userTemplateLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16).isActive = true
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16).isActive = true
        
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
        
        cancelButton.isHidden = !fromUserPage
        reserveButton.isHidden = fromUserPage
    }
    
    @objc func cancelButtonPressed()
    {
        // remove from database
        
        // remove reservation from shared instance
        let db = Firestore.firestore()
        let reservation = User.sharedInstance()?.reservation
        let room = reservation?.room
        let startTimeIndex = Int.thirtyMinuteIntervalFromFormattedTime(timeStr: reservation?.startTime)
        let endTimeIndex = Int.thirtyMinuteIntervalFromFormattedTime(timeStr: reservation?.endTime)
        
        for i in 0..<(room!.times?.count ?? 0){
            let dictionary = room!.times?[i] as! NSMutableDictionary
            guard var timeSlots = dictionary["timeSlots"] as? [String] else { return }
            
            guard let date: Timestamp = dictionary["date"] as? Timestamp else { return }
            let myDate: Date = date.dateValue()
            let dateString = self.getDate(myDate: myDate)
            if(dateString == reservation?.date)
            {
                //                indexInTimes = i
                for j in startTimeIndex..<endTimeIndex
                {
//                    print(j)
                    timeSlots[j] = ""
                }
                //                dictionary["timeSlots"]![i]["times"] = reservations
                print(timeSlots)
                dictionary["timeSlots"] = timeSlots
                room!.times?[i] = dictionary
            }
        }
        db.collection("Rooms").document(room!.room!).updateData(["times": room!.times ])
        
        if let email = User.sharedInstance()?.email
        {
            db.collection("Reservation").document(email).setData([:])
        }
        
        User.sharedInstance()?.reservation = nil
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reservation_update"), object: nil)
    }
    
    @objc func reserveButtonPressed()
    {
        if let currReservation = User.sharedInstance()?.reservation{
            let alert = UIAlertController(title: "Error", message: "You already have a reservation!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            
            self.present(alert, animated: true)
        }
        
        let db = Firestore.firestore()
        guard let room = reservation?.room else { return }
    
        let startTimeIndex = Int.thirtyMinuteIntervalFromFormattedTime(timeStr: reservation?.startTime)
        let endTimeIndex = Int.thirtyMinuteIntervalFromFormattedTime(timeStr: reservation?.endTime)
        
        let user = User.sharedInstance()

        for i in 0..<(room.times?.count ?? 0){
            let dictionary = room.times?[i] as! NSMutableDictionary
            guard var timeSlots = dictionary["timeSlots"] as? [String] else { return }
            
            guard let date: Timestamp = dictionary["date"] as? Timestamp else { return }
            let myDate: Date = date.dateValue()
            let dateString = self.getDate(myDate: myDate)
            if(dateString == reservation?.date)
            {
                for j in startTimeIndex..<endTimeIndex
                {
                    print(j)
                    timeSlots[j] =  (user?.email)!
                }

                print(timeSlots)
                dictionary["timeSlots"] = timeSlots
                room.times?[i] = dictionary
            }
        }
        guard let roomName = room.room else { return }
        
//        print(room?.times)
        db.collection("Rooms").document(roomName).updateData(["times": room.times])
        guard let email = user?.email else { return }
        guard let reservationDate = reservation?.date else { return }
        var reservationDict = [String : Any]()
        reservationDict["date"] = reservationDate
        reservationDict["room"] = roomName
        reservationDict["start"] = Int.thirtyMinuteIntervalFromFormattedTime(timeStr: reservation?.startTime)
        reservationDict["end"] = Int.thirtyMinuteIntervalFromFormattedTime(timeStr: reservation?.endTime)
        
        db.collection("Reservation").document(email).updateData(reservationDict)
        
        User.sharedInstance()?.reservation = reservation
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reservation_update"), object: nil)
    }
    
    func getDate(myDate: Date) -> String
    {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"
        
        // again convert your date to string
        let myStringafd = formatter.string(from: myDate)
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
