//
//  UserPageViewController.swift
//  BookIt
//
//  Created by Steven Hurtado on 10/5/18.
//  Copyright © 2018 HCIGroup10. All rights reserved.
//

import UIKit
import Cards

protocol UserPageDelegate
{
    func requestFocus()
}

class UserPageViewController: UIViewController
{
    //user
    var delegate : UserPageDelegate!
    
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
    
    var roomReservationViewController : RoomReservationViewController?
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
    
    var card : CardHighlight!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        setUpViews()
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(reservationUpdated), name: NSNotification.Name.init("reservation_update"), object: nil)
    }
    
    @objc func reservationUpdated()
    {
        card.detailVC.dismissVC()
        loadData()
    }
    
    func loadData()
    {
        let user = User.sharedInstance()
        user?.delegate = self
        
        self.reservation = user?.getReservation()
        if let user = User.sharedInstance()
        {
            self.userFirstNameTextField?.text = user.firstName
            self.userLastNameTextField?.text = user.lastName
            self.userEmailTextField?.text = user.email
        }
        
        handleReservation()
    }
    
    func handleReservation()
    {
        if let reservation = self.reservation
        {
            card.isHidden = false
            emptyReservationLabel?.isHidden = true
            reservationContainer?.isHidden = false
            cancelReservationButton?.isHidden = false
            
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
            roomReservationViewController.fromUserPage = true
            roomReservationViewController.reservation = reservation
            card.shouldPresent(roomReservationViewController, from: self, fullscreen: true)
            
            card.titleLbl.font = Fonts.openSansBold
            card.itemTitleLbl.font = Fonts.openSans
            card.itemSubtitleLbl.font = Fonts.openSansLight
        }
        else
        {
            card.isHidden = true
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
        
        card = CardHighlight(frame: CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: BookingListTableViewCell.CONTENT_SIZE.width, height: BookingListTableViewCell.CONTENT_SIZE.height))
        
        card.backgroundColor = .bookItBlueLight
        card.textColor = UIColor.white
        card.hasParallax = true
//        card.delegate = self
        
        view.addSubview(card)
        
        card.translatesAutoresizingMaskIntoConstraints = false
        card.widthAnchor.constraint(equalToConstant: BookingListTableViewCell.CONTENT_SIZE.width).isActive = true
        card.heightAnchor.constraint(equalToConstant: BookingListTableViewCell.CONTENT_SIZE.height).isActive = true
        card.topAnchor.constraint(equalTo: reservationInfoLabel.bottomAnchor, constant: 16).isActive = true
        card.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.title =  Titles.userPageViewControllerTitle
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

extension UserPageViewController : UserReservationDelegate
{
    func reservationReceived(reservation: Reservation?)
    {
        self.reservation = reservation
        handleReservation()
    }
    
    func reservationSwapRequested(email: String)
    {
        delegate.requestFocus()
        Util.presentAlert(title: "Hey!", message: "Someone's requesting to book your room. Want to give it to them?", viewController: self , withAction: UIAlertAction(title: "Sure", style: .default, handler: { (alert) in
            // TODO: Andrei, the room swap
            // first copy this user's reservation, except the name info
            // cancel this user's reservation
            // use new info and create new reservation
        }))
    }
}
