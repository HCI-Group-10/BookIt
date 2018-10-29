//
//  RoomReservationViewController.swift
//  BookIt
//
//  Created by Steven Hurtado on 10/12/18.
//  Copyright © 2018 HCIGroup10. All rights reserved.
//

import UIKit

class RoomReservationViewController: UIViewController
{
    var reservation : Reservation?
    static let DEFAULT_VIEW_HEIGHT : CGFloat = 64.0
    let DEFAULT_BUTTON_WIDTH : CGFloat = 248.0
    let DEFAULT_BUTTON_HEIGHT : CGFloat = 48.0
    
    var cancelReservationButton : UIButton?
    var reservationButton : UIButton?
    var fromUserPage = false
    {
        didSet {
            cancelReservationButton?.isHidden = !fromUserPage
            reservationButton?.isHidden = fromUserPage
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
        
        let user = User.sharedInstance()
        
        let userTemplateLabel = UILabel()
        userTemplateLabel.font = Fonts.openSansLight
        userTemplateLabel.textColor = UIColor.bookItBlueDark
        userTemplateLabel.text = "Name"
        
        let userNameLabel = UILabel()
        userNameLabel.font = Fonts.openSans
        userNameLabel.textColor = UIColor.bookItBlueDark
        
        if let first = user?.firstName, let last = user?.lastName
        {
            userNameLabel.text = "\(first) \(last)"
        }
        
        container.addSubview(userTemplateLabel)
        container.addSubview(userNameLabel)
    
        let dateTemplateLabel = UILabel()
        dateTemplateLabel.font = Fonts.openSansLight
        dateTemplateLabel.textColor = UIColor.bookItBlueDark
        dateTemplateLabel.text = "Date"
        
        let dateLabel = UILabel()
        dateLabel.font = Fonts.openSans
        dateLabel.textColor = UIColor.bookItBlueDark
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
        startTemplateLabel.textColor = UIColor.bookItBlueDark
        startTemplateLabel.text = "Start Time"
        
        let startLabel = UILabel()
        startLabel.font = Fonts.openSans
        startLabel.textColor = UIColor.bookItBlueDark
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
        endTemplateLabel.textColor = UIColor.bookItBlueDark
        endTemplateLabel.text = "End Time"
        
        let endLabel = UILabel()
        endLabel.font = Fonts.openSans
        endLabel.textColor = UIColor.bookItBlueDark
        endLabel.textAlignment = .right
        
        if let endTime = reservation?.endTime
        {
            //format time
            endLabel.text = endTime
        }
        
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
        
        view.addSubview(reserveButton)
        
        reserveButton.translatesAutoresizingMaskIntoConstraints = false
        
        reserveButton.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 16).isActive = true
        reserveButton.heightAnchor.constraint(equalToConstant: DEFAULT_BUTTON_HEIGHT).isActive = true
        reserveButton.widthAnchor.constraint(equalToConstant: DEFAULT_BUTTON_WIDTH).isActive = true
        reserveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
