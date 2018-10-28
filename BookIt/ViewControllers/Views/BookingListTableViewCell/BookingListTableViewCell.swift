//
//  BookingListTableViewCell.swift
//  BookIt
//
//  Created by Steven Hurtado on 10/10/18.
//  Copyright © 2018 HCIGroup10. All rights reserved.
//

import UIKit

protocol BookingListTableViewCellDelegate
{
    func reserveButtonPressed(room: Room?);
}

class BookingListTableViewCell: UITableViewCell {
    static let identifier = "BookingListTableViewCellIdentifier"
    static let DEFAULT_CELL_HEIGHT : CGFloat = 64.0
    
    let DEFAULT_BUTTON_WIDTH : CGFloat = 148.0
    let DEFAULT_BUTTON_HEIGHT : CGFloat = 48.0
    
    var delegate : BookingListTableViewCellDelegate!
    
    var room : Room?
    {
        didSet
        {
            roomLabel.text = room?.room
            if let location = room?.location, let capacity = room?.capacity
            {
                locationLabel.text = "Location: \(location)"
                capacityLabel.text = "Capacity: \(capacity)"
                timeLabel.text = "Until 11:30a"
            }
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
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(container)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        container.assignUIStyle()
        container.backgroundColor = .bookItBlueLight
        container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        
        roomLabel.font = Fonts.openSans
        roomLabel.textColor = .white
        roomLabel.numberOfLines = 0
        
        locationLabel.font = Fonts.openSansLight.withSize(16)
        locationLabel.textColor = .white
        locationLabel.numberOfLines = 0
        
        capacityLabel.font = Fonts.openSansLight.withSize(16)
        capacityLabel.textColor = .white
        capacityLabel.numberOfLines = 0

        reserveButton.backgroundColor = .clear
        reserveButton.assignUIStyle()
        reserveButton.layer.borderColor = UIColor.white.cgColor
        reserveButton.layer.borderWidth = 1.0
        
        reserveButton.setTitleColor(.white, for: .normal)
        reserveButton.setTitle("Reserve Room", for: .normal)
        reserveButton.titleLabel?.numberOfLines = 0
        reserveButton.addTarget(self, action: #selector(reservationButtonPressed), for: .touchUpInside)
        
        let timeImageView = UIImageView(image: UIImage(named: "clock"))
        timeLabel.font = Fonts.openSansLight.withSize(10)
        timeLabel.textColor = .white
        timeLabel.numberOfLines = 0
        
        container.addSubview(roomLabel)
        container.addSubview(locationLabel)
        container.addSubview(capacityLabel)
        container.addSubview(reserveButton)
        container.addSubview(timeLabel)
        container.addSubview(timeImageView)
        
        roomLabel.translatesAutoresizingMaskIntoConstraints = false
        roomLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: UIView.padding).isActive = true
        roomLabel.trailingAnchor.constraint(equalTo: reserveButton.leadingAnchor, constant: -UIView.padding).isActive = true
        roomLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: UIView.padding).isActive = true
        
        reserveButton.translatesAutoresizingMaskIntoConstraints = false
        reserveButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -UIView.padding).isActive = true
        reserveButton.topAnchor.constraint(equalTo: container.topAnchor, constant: UIView.padding).isActive = true
        reserveButton.heightAnchor.constraint(equalToConstant: DEFAULT_BUTTON_HEIGHT).isActive = true
        reserveButton.widthAnchor.constraint(equalToConstant: DEFAULT_BUTTON_WIDTH).isActive = true
        reserveButton.bottomAnchor.constraint(greaterThanOrEqualTo: timeImageView.topAnchor, constant: 8)
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: UIView.padding).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: reserveButton.leadingAnchor, constant: -UIView.padding).isActive = true
        locationLabel.topAnchor.constraint(equalTo: roomLabel.bottomAnchor).isActive = true
        
        capacityLabel.translatesAutoresizingMaskIntoConstraints = false
        capacityLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: UIView.padding).isActive = true
        capacityLabel.trailingAnchor.constraint(equalTo: reserveButton.leadingAnchor, constant: -UIView.padding).isActive = true
        capacityLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor).isActive = true
        capacityLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -UIView.padding).isActive = true
        
        timeImageView.translatesAutoresizingMaskIntoConstraints = false
        timeImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -UIView.padding).isActive = true
        timeImageView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -UIView.padding).isActive = true
        
        timeImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        timeImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.trailingAnchor.constraint(equalTo: timeImageView.leadingAnchor, constant: -8).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -UIView.padding).isActive = true
        
        container.heightAnchor.constraint(greaterThanOrEqualToConstant: BookingListTableViewCell.DEFAULT_CELL_HEIGHT).isActive = true
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
