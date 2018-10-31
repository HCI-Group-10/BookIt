//
//  BookingListTableViewCell.swift
//  BookIt
//
//  Created by Steven Hurtado on 10/10/18.
//  Copyright © 2018 HCIGroup10. All rights reserved.
//

import UIKit
import Cards

protocol BookingListTableViewCellDelegate
{
    func reserveButtonPressed(room: Room?);
}

class BookingListTableViewCell: UITableViewCell {
    static let identifier = "BookingListTableViewCellIdentifier"
    static let CELL_SIZE : CGSize = CGSize(width: 300, height: 400)
    static let CONTENT_SIZE : CGSize = CGSize(width: 280, height: 380)
    
    let DEFAULT_BUTTON_WIDTH : CGFloat = 148.0
    let DEFAULT_BUTTON_HEIGHT : CGFloat = 48.0
    
    var card : CardHighlight!
    var roomReservationViewController : RoomReservationViewController?
    
    var delegate : BookingListTableViewCellDelegate!
    var controller : UIViewController!
    var today : Date = Date.init()
    var todaysDate : String = "" //if presented from RoomSearchViewController, it will be equal
    //to the day of the date picker, not today's actual date
    var startInd : Int = 0
    var endInd : Int = 0
    let calendar : Calendar = Calendar.current
    var room : Room?
    {
        didSet
        {
//            roomLabel.text = room?.room
            if let roomText = room?.room, let location = room?.location, let capacity = room?.capacity
            {
                
//                locationLabel.text = "Location: \(location)"
//                capacityLabel.text = "Capacity: \(capacity)"
//                timeLabel.text = "Until 11:30a"
                let roomNum = room?.roomNumber ?? ""
                card.backgroundImage = UIImage(named: roomText)
                card.title = "\(roomText) \(roomNum)"
                card.itemTitle = "Location: \(location)"
                card.itemSubtitle = "Capacity: \(capacity)"
            }
            
            //assign vc to present
            roomReservationViewController = RoomReservationViewController()
            guard let roomReservationViewController = roomReservationViewController else { return }
            let reservation = Reservation()
            reservation.room = room
            let date = Date()
            let dateFormatter = DateFormatter()
            
            if todaysDate == "" {
                
                dateFormatter.dateFormat = "dd-MMM-YYYY"
                reservation.date = dateFormatter.string(from: date)
            }
            else{
                reservation.date = todaysDate
            }
            
            reservation.startTime = String.getTimeFormattedFrom30MinIntervalValue(val: startInd)
            reservation.endTime = String.getTimeFormattedFrom30MinIntervalValue(val: endInd)
            
            roomReservationViewController.reservation = reservation
            
            card.shouldPresent(roomReservationViewController, from: controller, fullscreen: true)
            
            card.titleLbl.font = Fonts.openSansBold
            card.itemTitleLbl.font = Fonts.openSans
            card.itemSubtitleLbl.font = Fonts.openSansLight
        }
    }
    
    private let container : UIView = { return UIView() }()
    
    private let roomLabel : UILabel = { return UILabel() }()
    
    private let locationLabel : UILabel = { return UILabel() }()
    
    private let capacityLabel : UILabel = { return UILabel() }()
    
    private let timeLabel : UILabel = { return UILabel() }()
    
    private let reserveButton : UIButton = { return UIButton() }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews()
    {
        card = CardHighlight(frame: CGRect(x: contentView.frame.origin.x, y: contentView.frame.origin.y, width: BookingListTableViewCell.CONTENT_SIZE.width, height: BookingListTableViewCell.CONTENT_SIZE.height))
        
        card.backgroundColor = .bookItBlueLight
        card.textColor = UIColor.white
        card.hasParallax = true
        card.delegate = self
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(card)
        
        card.translatesAutoresizingMaskIntoConstraints = false
        card.widthAnchor.constraint(equalToConstant: BookingListTableViewCell.CONTENT_SIZE.width).isActive = true
        card.heightAnchor.constraint(equalToConstant: BookingListTableViewCell.CONTENT_SIZE.height).isActive = true
        
       card.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        card.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(reservationUpdated), name: NSNotification.Name.init("reservation_update"), object: nil)
    }
    
    @objc func reservationUpdated()
    {
        card.detailVC.dismissVC()
    }
    
    
    @objc func reservationButtonPressed()
    {
        self.delegate.reserveButtonPressed(room: room)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension BookingListTableViewCell : CardDelegate
{
//    @objc  func cardWillShowDetailView(card: Card)
    func cardWillShowDetailView(card: Card)
    {
//        card.frame.origin.x = self.contentView.frame.origin.x + self.contentView.frame.width/2.0 - BookingListTableViewCell.CONTENT_SIZE.width/2.0
//        card.frame.origin.y = self.contentView.frame.origin.y
    }
}
