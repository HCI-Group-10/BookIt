//
//  RoomScanViewController.swift
//  BookIt
//
//  Created by Steven Hurtado on 10/5/18.
//  Copyright © 2018 HCIGroup10. All rights reserved.
//

import UIKit
import Firebase
import Cards

class ScanOverlayView : UIView
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    func setUpViews()
    {
        let topLeft = getCornerView(corner: 0)
        let topRight = getCornerView(corner: 1)
        let bottomRight = getCornerView(corner: 2)
        let bottomLeft = getCornerView(corner: 3)
        
        addSubview(topLeft)
        addSubview(topRight)
        addSubview(bottomRight)
        addSubview(bottomLeft)
    }
    
    func getCornerView(corner: Int) -> UIView
    {
        let cornerView = UIView()
        cornerView.frame = CGRect(x: 0, y: 0, width: frame.width/4, height: frame.height/4)
        
        let line = CAShapeLayer()
        line.strokeColor = UIColor.white.cgColor
        line.lineWidth = 16.0
        line.opacity = 0.5
        line.fillColor = UIColor.clear.cgColor
        line.lineCap = kCALineCapRound
        
        let linePath = UIBezierPath()
        
        switch(corner)
        {
        case 0:
            // top left corner
            linePath.move(to: CGPoint(x: frame.origin.x, y: frame.origin.y + cornerView.frame.height))
            linePath.addLine(to: CGPoint(x: frame.origin.x, y: frame.origin.y))
            linePath.addLine(to: CGPoint(x: frame.origin.x + cornerView.frame.width, y: frame.origin.y))
            line.path = linePath.cgPath
            break
        case 1:
            // top right corner
            linePath.move(to: CGPoint(x: frame.origin.x + frame.width, y: frame.origin.y + cornerView.frame.height))
            linePath.addLine(to: CGPoint(x: frame.origin.x + frame.width, y: frame.origin.y))
            linePath.addLine(to: CGPoint(x: frame.origin.x + frame.width - cornerView.frame.width, y: frame.origin.y))
            line.path = linePath.cgPath
            break
        case 2:
            // bottom right corner
            linePath.move(to: CGPoint(x: frame.origin.x + frame.width, y: frame.origin.y + frame.height - cornerView.frame.height))
            linePath.addLine(to: CGPoint(x: frame.origin.x + frame.width, y: frame.origin.y + frame.height))
            linePath.addLine(to: CGPoint(x: frame.origin.x + frame.width - cornerView.frame.width, y: frame.origin.y + frame.height))
            line.path = linePath.cgPath
            break
        case 3:
            // bottom left corner
            linePath.move(to: CGPoint(x: frame.origin.x + cornerView.frame.width, y: frame.origin.y + frame.height))
            linePath.addLine(to: CGPoint(x: frame.origin.x, y: frame.origin.y + frame.height))
            linePath.addLine(to: CGPoint(x: frame.origin.x, y: frame.origin.y + frame.height - cornerView.frame.height))
            line.path = linePath.cgPath
            break
        default:
            break
        }
        
        cornerView.layer.addSublayer(line)
        return cornerView
    }
}

class RoomScanViewController: UIViewController
{
    var scannerViewController : ScannerViewController!
    var overlayView : ScanOverlayView?
    var card : CardHighlight?
    var roomReservationViewController : RoomReservationViewController?
    var reservation : Reservation?
    
    var hiddenView : UIVisualEffectView?
    let OFFSET : CGFloat = 32.0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        setUpViews()
    }
    
    func setUpViews()
    {
        //add scan controller
        scannerViewController = ScannerViewController()
        scannerViewController.view.frame = view.frame
        scannerViewController.delegate = self
        
        addChildViewController(scannerViewController)
        view.addSubview(scannerViewController.view)
        
        scannerViewController.didMove(toParentViewController: self)
        
        // add overlay
        overlayView = ScanOverlayView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        if let overlayView = overlayView
        {
            view.addSubview(overlayView)
            
            overlayView.translatesAutoresizingMaskIntoConstraints = false
            overlayView.widthAnchor.constraint(equalToConstant: overlayView.frame.width).isActive = true
            overlayView.heightAnchor.constraint(equalToConstant: overlayView.frame.height).isActive = true
            overlayView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            overlayView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -OFFSET).isActive = true
        }
        
        hiddenView = UIVisualEffectView(frame: view.frame)
        guard let hiddenView = hiddenView else { return }
        hiddenView.effect = UIBlurEffect(style: .regular)
        hiddenView.isHidden = true
        view.addSubview(hiddenView)
        
        card = CardHighlight(frame: CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: BookingListTableViewCell.CONTENT_SIZE.width, height: BookingListTableViewCell.CONTENT_SIZE.height))
        guard let card = card else { return }
        card.backgroundColor = .bookItBlueLight
        card.textColor = UIColor.white
        card.hasParallax = true
        //        card.delegate = self
        
        hiddenView.contentView.addSubview(card)
        hiddenView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideHiddenView)))
        card.translatesAutoresizingMaskIntoConstraints = false
        card.widthAnchor.constraint(equalToConstant: BookingListTableViewCell.CONTENT_SIZE.width).isActive = true
        card.heightAnchor.constraint(equalToConstant: BookingListTableViewCell.CONTENT_SIZE.height).isActive = true
        
        card.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        card.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc func hideHiddenView()
    {
        hiddenView?.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.title =  Titles.roomScanViewControllerTitle
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getDate(myDate: Date) -> String{
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: Date()) // string purpose I add here
        
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        let myStringafd = formatter.string(from: myDate)
        
        
        return myStringafd
    }
    func handleReservation(booked: Bool)
    {
        if let reservation = self.reservation
        {
            guard let card = card else { return }
            if let room = reservation.room
            {
                guard let roomText = room.room else { return }
                let roomNum  = room.roomNumber ?? ""
                guard let location = room.location else { return }
                guard let capacity = room.capacity else { return }
                
                card.backgroundImage = UIImage(named: roomText)
                card.title = "\(roomText) \(roomNum)"
                card.itemTitle = "Location: \(location)"
                card.itemSubtitle = "Capacity: \(capacity)"
            }
            
            //assign vc to present
            if roomReservationViewController == nil {
                roomReservationViewController = RoomReservationViewController()
            }
            
            guard let roomReservationViewController = roomReservationViewController else { return }
            
            roomReservationViewController.reservation = reservation
            roomReservationViewController.fromScan = true
            roomReservationViewController.isBooked = booked
            card.shouldPresent(roomReservationViewController, from: self, fullscreen: true)
        }
    }
}

extension RoomScanViewController : ScannerViewControllerDelegate
{
    func outputFromScan(result: String)
    {
        // result should be room, make request for current reservation using that room
        let db = Firestore.firestore()
        let user = User.sharedInstance()
        if user?.reservation != nil
        {
            Util.presentAlert(title: "Sorry", message: "You cannot check the status of a room if you currently have a reservation.", viewController: self)
            return
        }
        
        var bookingEmail : String?
        db.collection("Reservation").getDocuments { (query, error) in
            if error == nil, let query = query
            {
                self.reservation = Reservation()
                
                for document in query.documents
                {
                    let data = document.data()
                    if let room = data[Room.roomKey] as? String, room == result
                    {
                        bookingEmail = document.documentID
                        self.reservation?.date = data["date"] as? String
                        self.reservation?.startTime = String.getTimeFormattedFrom30MinIntervalValue(val: data["start"] as! Int)
                        self.reservation?.endTime = String.getTimeFormattedFrom30MinIntervalValue(val: data["end"] as! Int)
                        
                        self.reservation?.user = User()
                        self.reservation?.user?.firstName = data["firstName"] as? String
                        self.reservation?.user?.lastName = data["lastName"] as? String
                        self.reservation?.user?.email = bookingEmail
                        
                        break
                    }
                }
                
                //self.reservation has no value yet,
                //make request to firebase to assign reservation values
                // get room based on the (result: String) passed to this method
                //the date, start and end strings of reservation should be based on the current reservation, but we can just make it be based off of the current time tbh
                
                //the following code should be in the completion handler from a firebase request for the room info
                
                //make sure room exists in DB
                let roomRef = db.collection("Rooms").document(result)
                roomRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        self.reservation?.room = Room(dict: document.data() as! NSDictionary)
                        
                        
                        if let email = bookingEmail // if taken, show card with request switch
                        {
                            //then after our reservation is set,
                            //                    let today : Date = Date.init()
                            //                    let calendar : Calendar = Calendar.current
                            //                    let hour = calendar.component(.hour, from: today)
                            //                    let minute = calendar.component(.minute, from: today)
                            //                    var timeString = ""
                            //                    if hour < 10{
                            //                        timeString += "0\(hour)"
                            //                    }
                            //                    else{
                            //                        timeString += "\(hour)"
                            //                    }
                            //                    if minute < 30{
                            //                        timeString += ":00"
                            //                    }
                            //                    else{
                            //                        timeString += ":30"
                            //                    }
                            //
                            //                    // set up reservationDict to be uploaded to DB
                            //                    // start and end in reservationDict is equal to indices for the array, not sure if that's what we wanted
                            //                    reservationDict["date"] = self.getDate(myDate: today)
                            //                    reservationDict["room"] = result
                            //                    reservationDict["start"] = Int.thirtyMinuteIntervalFromFormattedTime(timeStr: timeString)
                            //                    reservationDict["end"] = reservationDict["start"] as! Int + 1
                            //
                            //                    db.collection("Reservation").document(email).updateData(reservationDict)
                            //
                            //                    //update reservation for sharedInstance
                            //                    //start and end time are formatted as HH:MM, again not sure if that's what we wanted
                            //                    self.reservation?.date = self.getDate(myDate: today)
                            //                    self.reservation?.startTime = String.getTimeFormattedFrom30MinIntervalValue(val: reservationDict["start"] as! Int)
                            //                    reservation?.endTime = String.getTimeFormattedFrom30MinIntervalValue(val: reservationDict["end"] as! Int)
                            //
                            //                    User.sharedInstance()?.reservation = self.reservation
                            self.handleReservation(booked: true)
                        }
                        else // if open, show card with book now
                        {
                            self.handleReservation(booked: false)
                        }
                        self.hiddenView?.isHidden = false
                    } else {
                        print("Document does not exist")
                        return
                    }
                }
            }
            else
            {
                print(error?.localizedDescription ?? "")
            }
        }
    }
}
