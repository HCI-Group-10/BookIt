//
//  BookingListTableViewCell.swift
//  BookIt
//
//  Created by Steven Hurtado on 10/10/18.
//  Copyright © 2018 HCIGroup10. All rights reserved.
//

import UIKit

class BookingListTableViewCell: UITableViewCell {
    static let identifier = "BookingListTableViewCellIdentifier"
    static let DEFAULT_CELL_HEIGHT : CGFloat = 64.0
    let DEFAULT_BUTTON_WIDTH : CGFloat = 164.0
    
    var room : Room? {
        didSet {
            roomLabel.text = room?.room
            locationLabel.text = room?.location
            capacityLabel.text = room?.capacity
        }
    }
    
    private var roomLabel : UILabel = { return UILabel() }()
    
    private var locationLabel : UILabel = { return UILabel() }()
    
    private let capacityLabel : UILabel = { return UILabel() }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews()
    {
        roomLabel.font = roomLabel.font.withSize(20)
        roomLabel.numberOfLines = 0
        
        locationLabel.font = locationLabel.font.withSize(16)
        locationLabel.numberOfLines = 0
        
        capacityLabel.font = capacityLabel.font.withSize(16)
        capacityLabel.numberOfLines = 0

        contentView.backgroundColor = .white
        
        let reserveButton = UIButton(frame: CGRect.zero)
        reserveButton.backgroundColor = .green
        reserveButton.setTitleColor(.white, for: .normal)
        reserveButton.setTitle("Reserve Room", for: .normal)
        reserveButton.titleLabel?.numberOfLines = 0
        
        addSubview(roomLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(capacityLabel)
        contentView.addSubview(reserveButton)
        
        roomLabel.translatesAutoresizingMaskIntoConstraints = false
        roomLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        roomLabel.trailingAnchor.constraint(equalTo: reserveButton.leadingAnchor, constant: -16).isActive = true
        roomLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        
        reserveButton.translatesAutoresizingMaskIntoConstraints = false
        reserveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        reserveButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        reserveButton.widthAnchor.constraint(equalToConstant: DEFAULT_BUTTON_WIDTH).isActive = true
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: reserveButton.leadingAnchor, constant: -16).isActive = true
        locationLabel.topAnchor.constraint(equalTo: roomLabel.bottomAnchor).isActive = true
        
        capacityLabel.translatesAutoresizingMaskIntoConstraints = false
        capacityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        capacityLabel.trailingAnchor.constraint(equalTo: reserveButton.leadingAnchor, constant: -16).isActive = true
        capacityLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor).isActive = true
        capacityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: BookingListTableViewCell.DEFAULT_CELL_HEIGHT).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
