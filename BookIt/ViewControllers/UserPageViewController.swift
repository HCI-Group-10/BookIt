//
//  UserPageViewController.swift
//  BookIt
//
//  Created by Steven Hurtado on 10/5/18.
//  Copyright © 2018 HCIGroup10. All rights reserved.
//

import UIKit

class UserPageViewController: UIViewController
{
    //user
    var userInfoLabel : UILabel?
    var userFirstNameLabel : UILabel?
    var userFirstNameTextField : UITextField?
    
    var userLastNameLabel : UILabel?
    var userLastNameTextField : UITextField?
    
    var userEmailLabel : UILabel?
    var userEmailTextField : UITextField?
    var textFields : [UITextField] = []
    
    //reservation views
    var reservationInfoLabel : UILabel?
    var reservation : Reservation?
    var reservationContainer : UIView?
    var emptyReservationLabel : UILabel?
    var cancelReservationButton : UIButton?
    var roomLabel : UILabel?
    var roomLocationLabel : UILabel?
    var roomCapacityLabel : UILabel?
    var startTimeLabel : UILabel?
    var endTimeLabel : UILabel?
    var dateLabel : UILabel?
    
    //local constants
    static let DEFAULT_VIEW_HEIGHT : CGFloat = 64.0
    let DEFAULT_BUTTON_WIDTH : CGFloat = 248.0
    let DEFAULT_BUTTON_HEIGHT : CGFloat = 48.0
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        setUpViews()
        loadData()
    }
    
    func loadData()
    {
        let room = Room(dict: [
            "room" : "Babbage",
            "roomNumber" : "L113",
            "location" : "Marston",
            "capacity" : "4"
            ])
        let reservation = Reservation()
        reservation.room = room
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM d, yyyy"
        reservation.date = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "HH:mm"
        reservation.startTime = dateFormatter.string(from: date)
        reservation.endTime = dateFormatter.string(from: date)
        
        self.reservation = reservation
        
        if let user = User.sharedInstance()
        {
            self.userFirstNameTextField?.text = user.firstName
            self.userLastNameTextField?.text = user.lastName
            self.userEmailTextField?.text = user.email
        }
        
        if let reservation = self.reservation
        {
            emptyReservationLabel?.isHidden = true
            reservationContainer?.isHidden = false
            cancelReservationButton?.isHidden = false
            
            if let date = reservation.date
            {
                //format date
                dateLabel?.text = date
            }
            
            if let startTime = reservation.startTime
            {
                //format time
                startTimeLabel?.text = startTime
            }
            
            
            if let endTime = reservation.endTime
            {
                //format time
                endTimeLabel?.text = endTime
            }
            
            if let room = reservation.room, let roomName = room.room, let roomNum = room.roomNumber, let roomLocation = room.location, let roomCapacity = room.capacity
            {
                roomLabel?.text = "\(roomName)"
                roomLocationLabel?.text = "Location: \(roomLocation) \(roomNum)"
                roomCapacityLabel?.text = "Capacity: \(roomCapacity)"
            }
        }
        else
        {
            emptyReservationLabel?.isHidden = false
            reservationContainer?.isHidden = true
            cancelReservationButton?.isHidden = true
            
        }
    }
    
    @objc func dismissViews()
    {
        for field in textFields
        {
            field.resignFirstResponder()
        }
    }
    
    func setUpViews()
    {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissViews)))
        
        userInfoLabel = UILabel()
        userInfoLabel?.font = Fonts.openSansBold
        userInfoLabel?.numberOfLines = 0
        userInfoLabel?.textColor = UIColor.bookItBlueDark
        userInfoLabel?.text = "User Information"
        
        guard let userInfoLabel = userInfoLabel else { return }
        view.addSubview(userInfoLabel)
        userInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        userInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        userInfoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        userInfoLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        
        userFirstNameLabel = UILabel()
        userFirstNameLabel?.font = Fonts.openSansLight
        userFirstNameLabel?.numberOfLines = 0
        userFirstNameLabel?.textColor = UIColor.gray
        userFirstNameLabel?.text = "First Name"
        
        guard let userFirstNameLabel = userFirstNameLabel else { return }
        view.addSubview(userFirstNameLabel)
        userFirstNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userFirstNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        userFirstNameLabel.topAnchor.constraint(equalTo: userInfoLabel.bottomAnchor, constant: 16).isActive = true
        
        userFirstNameTextField = UITextField()
        userFirstNameTextField?.font = Fonts.openSans
        userFirstNameTextField?.textColor = UIColor.bookItBlueLight
        userFirstNameTextField?.placeholder = "Steven"
        
        guard let userFirstNameTextField = userFirstNameTextField else { return }
        view.addSubview(userFirstNameTextField)
        textFields.append(userFirstNameTextField)
        userFirstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        userFirstNameTextField.leadingAnchor.constraint(equalTo: userFirstNameLabel.trailingAnchor, constant: 16).isActive = true
        userFirstNameTextField.topAnchor.constraint(equalTo: userInfoLabel.bottomAnchor, constant: 16).isActive = true
        userFirstNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        
        userLastNameLabel = UILabel()
        userLastNameLabel?.font = Fonts.openSansLight
        userLastNameLabel?.numberOfLines = 0
        userLastNameLabel?.textColor = UIColor.gray
        userLastNameLabel?.text = "Last Name"
        
        guard let userLastNameLabel = userLastNameLabel else { return }
        view.addSubview(userLastNameLabel)
        userLastNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userLastNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        userLastNameLabel.topAnchor.constraint(equalTo: userFirstNameTextField.bottomAnchor, constant: 16).isActive = true
        
        userLastNameTextField = UITextField()
        userLastNameTextField?.font = Fonts.openSans
        userLastNameTextField?.textColor = UIColor.bookItBlueLight
        userLastNameTextField?.placeholder = "Hurtado"
        
        guard let userLastNameTextField = userLastNameTextField else { return }
        view.addSubview(userLastNameTextField)
        textFields.append(userLastNameTextField)
        userLastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        userLastNameTextField.leadingAnchor.constraint(equalTo: userLastNameLabel.trailingAnchor, constant: 16).isActive = true
        userLastNameTextField.topAnchor.constraint(equalTo: userFirstNameTextField.bottomAnchor, constant: 16).isActive = true
        userLastNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        userEmailLabel = UILabel()
        userEmailLabel?.font = Fonts.openSansLight
        userEmailLabel?.numberOfLines = 0
        userEmailLabel?.textColor = UIColor.gray
        userEmailLabel?.text = "Email"
        
        guard let userEmailLabel = userEmailLabel else { return }
        view.addSubview(userEmailLabel)
        userEmailLabel.translatesAutoresizingMaskIntoConstraints = false
        userEmailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        userEmailLabel.topAnchor.constraint(equalTo: userLastNameTextField.bottomAnchor, constant: 16).isActive = true
        
        userEmailTextField = UITextField()
        userEmailTextField?.font = Fonts.openSans
        userEmailTextField?.textColor = UIColor.bookItBlueLight
        userEmailTextField?.placeholder = "sh@gmail.com"
        
        guard let userEmailTextField = userEmailTextField else { return }
        view.addSubview(userEmailTextField)
        textFields.append(userEmailTextField)
        userEmailTextField.translatesAutoresizingMaskIntoConstraints = false
        userEmailTextField.leadingAnchor.constraint(equalTo: userEmailLabel.trailingAnchor, constant: 16).isActive = true
        userEmailTextField.topAnchor.constraint(equalTo: userLastNameTextField.bottomAnchor, constant: 16).isActive = true
        userEmailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        reservationInfoLabel = UILabel()
        reservationInfoLabel?.font = Fonts.openSansBold
        reservationInfoLabel?.numberOfLines = 0
        reservationInfoLabel?.textColor = UIColor.bookItBlueDark
        reservationInfoLabel?.text = "Reservation Information"
        
        guard let reservationInfoLabel = reservationInfoLabel else { return }
        view.addSubview(reservationInfoLabel)
        reservationInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        reservationInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        reservationInfoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        reservationInfoLabel.topAnchor.constraint(equalTo: userEmailTextField.bottomAnchor, constant: 16).isActive = true
        
        emptyReservationLabel = UILabel()
        emptyReservationLabel?.font = Fonts.openSansLight
        emptyReservationLabel?.numberOfLines = 0
        emptyReservationLabel?.textColor = UIColor.lightGray
        emptyReservationLabel?.text = "You currently have no pending reservation."
        emptyReservationLabel?.isHidden = true
        emptyReservationLabel?.textAlignment = .center
        guard let emptyReservationLabel = emptyReservationLabel else { return }
        view.addSubview(emptyReservationLabel)
        emptyReservationLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyReservationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        emptyReservationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        emptyReservationLabel.topAnchor.constraint(equalTo:reservationInfoLabel.bottomAnchor, constant: 16).isActive = true
        
        reservationContainer = UIView()
        guard let container = reservationContainer else { return }
        view.addSubview(container)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = 4.0
        container.backgroundColor = .bookItBlueLight
        container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        container.topAnchor.constraint(equalTo: reservationInfoLabel.bottomAnchor, constant: 16).isActive = true
        
        container.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -8).isActive = true
        
        let dateTemplateLabel = UILabel()
        dateTemplateLabel.font = Fonts.openSansLight
        dateTemplateLabel.textColor = UIColor.white
        dateTemplateLabel.text = "Date"
        
        dateLabel = UILabel()
        guard let dateLabel = dateLabel else { return }
        dateLabel.font = Fonts.openSans
        dateLabel.textColor = UIColor.white
        dateLabel.textAlignment = .right
        
        container.addSubview(dateTemplateLabel)
        container.addSubview(dateLabel)
        
        let startTemplateLabel = UILabel()
        startTemplateLabel.font = Fonts.openSansLight
        startTemplateLabel.textColor = UIColor.white
        startTemplateLabel.text = "Start Time"
        
        startTimeLabel = UILabel()
        guard let startLabel = startTimeLabel else { return }
        startLabel.font = Fonts.openSans
        startLabel.textColor = UIColor.white
        startLabel.textAlignment = .right
        
        container.addSubview(startTemplateLabel)
        container.addSubview(startLabel)
        
        let endTemplateLabel = UILabel()
        endTemplateLabel.font = Fonts.openSansLight
        endTemplateLabel.textColor = UIColor.white
        endTemplateLabel.text = "End Time"
        
        endTimeLabel = UILabel()
        guard let endLabel = endTimeLabel else { return }
        endLabel.font = Fonts.openSans
        endLabel.textColor = UIColor.white
        endLabel.textAlignment = .right
        
        container.addSubview(endTemplateLabel)
        container.addSubview(endLabel)
        
        roomLabel = UILabel()
        guard let roomLabel = roomLabel else { return }
        roomLabel.font = Fonts.openSans
        roomLabel.textColor = .white
        roomLabel.numberOfLines = 0
        
        roomLocationLabel = UILabel()
        guard let locationLabel = roomLocationLabel else { return }
        locationLabel.font = Fonts.openSansLight.withSize(16)
        locationLabel.textColor = .white
        locationLabel.numberOfLines = 0
        
        roomCapacityLabel = UILabel()
        guard let capacityLabel = roomCapacityLabel else { return }
        capacityLabel.font = Fonts.openSansLight.withSize(16)
        capacityLabel.textColor = .white
        capacityLabel.numberOfLines = 0
        
        container.addSubview(roomLabel)
        container.addSubview(locationLabel)
        container.addSubview(capacityLabel)
        
        cancelReservationButton = UIButton()
        guard let cancelButton = cancelReservationButton else { return }
        cancelButton.backgroundColor = .clear
        cancelButton.layer.cornerRadius = 4.0
        cancelButton.layer.borderColor = UIColor.red.cgColor
        cancelButton.layer.borderWidth = 1.0
        
        cancelButton.setTitleColor(.red, for: .normal)
        cancelButton.setTitle("Cancel Reservation", for: .normal)
        cancelButton.titleLabel?.numberOfLines = 0
        
        view.addSubview(cancelButton)
        
        roomLabel.translatesAutoresizingMaskIntoConstraints = false
        roomLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8).isActive = true
        roomLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8).isActive = true
        roomLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16).isActive = true
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 16).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: DEFAULT_BUTTON_HEIGHT).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: DEFAULT_BUTTON_WIDTH).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8).isActive = true
        locationLabel.topAnchor.constraint(equalTo: roomLabel.bottomAnchor).isActive = true
        
        capacityLabel.translatesAutoresizingMaskIntoConstraints = false
        capacityLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8).isActive = true
        capacityLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8).isActive = true
        capacityLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor).isActive = true
        
        dateTemplateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateTemplateLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8).isActive = true
        dateTemplateLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -8).isActive = true
        dateTemplateLabel.topAnchor.constraint(equalTo: capacityLabel.bottomAnchor, constant: 16).isActive = true
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8).isActive = true
        dateLabel.topAnchor.constraint(equalTo: capacityLabel.bottomAnchor, constant: 16).isActive = true
        
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
        
        container.heightAnchor.constraint(greaterThanOrEqualToConstant: UserPageViewController.DEFAULT_VIEW_HEIGHT).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.title =  Titles.userPageViewControllerTitle
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
