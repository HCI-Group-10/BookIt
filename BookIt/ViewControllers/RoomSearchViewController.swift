//
//  RoomSearchViewController.swift
//  BookIt
//
//  Created by Steven Hurtado on 10/5/18.
//  Copyright © 2018 HCIGroup10. All rights reserved.
//

import UIKit
import SwiftRangeSlider
import FirebaseFirestore
import Firebase

class TimeRangeSlider : RangeSlider
{
    override func getLabelText(forValue value: Double) -> String
    {
        return String.getTimeFormattedFrom30MinIntervalValue(val: Int(value))
    }
}

class RoomSearchViewController: UIViewController
{
    var roomDateLabel : UILabel?
    let roomDateString = "I want a room on:"
    
    var datePicker : UIDatePicker?
    
    var timeSliderLabel : UILabel?
    let timeSliderString = "From:"
    
    // range slider
    // https://github.com/BrianCorbin/SwiftRangeSlider
    var rangeSlider : TimeRangeSlider?
    let intervals : Double = 48.0 //48 30 minute intervals in a day
    
    var quantityForLabel : UILabel?
    let quantityForString = "For"
    
    var quantityTextField : UITextField?
    
    var quantityPeopleLabel : UILabel?
    let quantityPeopleString = "People"
    
    var searchButton : UIButton?
    let DEFAULT_BUTTON_WIDTH : CGFloat = 248.0
    let DEFAULT_BUTTON_HEIGHT : CGFloat = 48.0
    
    var roomData : [Room] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        setUpViews()
    }
    
    func setUpViews()
    {
        edgesForExtendedLayout = []
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        roomDateLabel = UILabel()
        guard let roomDateLabel = roomDateLabel else { return }
        roomDateLabel.font = Fonts.openSansLight
        roomDateLabel.textColor = UIColor.bookItBlueLight
        roomDateLabel.numberOfLines = 0
        roomDateLabel.text = roomDateString
        view.addSubview(roomDateLabel)

        roomDateLabel.translatesAutoresizingMaskIntoConstraints = false
        roomDateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        roomDateLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 32).isActive = true
        
        datePicker = UIDatePicker()
        datePicker?.minimumDate = Date()
        datePicker?.datePickerMode = .date
        
        guard let datePicker = datePicker else { return }
        view.addSubview(datePicker)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        datePicker.topAnchor.constraint(equalTo: roomDateLabel.bottomAnchor).isActive = true
        
        timeSliderLabel = UILabel()
        guard let timeSliderLabel = timeSliderLabel else { return }
        timeSliderLabel.font = Fonts.openSansLight
        timeSliderLabel.textColor = UIColor.bookItBlueLight
        timeSliderLabel.numberOfLines = 0
        timeSliderLabel.text = timeSliderString
        view.addSubview(timeSliderLabel)
        
        timeSliderLabel.translatesAutoresizingMaskIntoConstraints = false
        timeSliderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timeSliderLabel.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 16).isActive = true
        
        rangeSlider = TimeRangeSlider(frame: CGRect(x: 0, y: 0, width: view.frame.width - 64, height: DEFAULT_BUTTON_HEIGHT))
        guard let rangeSlider = rangeSlider else { return }
        
        rangeSlider.labelColor = UIColor.bookItBlueDark
        rangeSlider.trackTintColor = UIColor.lightGray
        rangeSlider.trackThickness = 0.24
        
        rangeSlider.knobTintColor = UIColor.white
        rangeSlider.knobBorderThickness = 1.0
        rangeSlider.knobBorderTintColor = UIColor.bookItBlueLight
        rangeSlider.knobHasShadow = true
        rangeSlider.trackHighlightTintColor = UIColor.bookItBlueLight
        
        rangeSlider.lowerValue = 4
        rangeSlider.minimumValue = 0
        rangeSlider.upperValue = 24
        rangeSlider.maximumValue = intervals
        rangeSlider.minimumDistance = 1
        rangeSlider.hideLabels = false
        
        view.addSubview(rangeSlider)
        
        rangeSlider.translatesAutoresizingMaskIntoConstraints = false
        rangeSlider.topAnchor.constraint(equalTo: timeSliderLabel.bottomAnchor, constant: 8).isActive = true
        rangeSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        rangeSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
        rangeSlider.heightAnchor.constraint(equalToConstant: DEFAULT_BUTTON_HEIGHT).isActive = true
        
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 0
        
        quantityForLabel = UILabel()
        guard let quantityForLabel = quantityForLabel else { return }
        quantityForLabel.font = Fonts.openSansLight
        quantityForLabel.textColor = UIColor.bookItBlueLight
        quantityForLabel.numberOfLines = 0
        quantityForLabel.text = quantityForString
        stackView.addArrangedSubview(quantityForLabel)
        
        quantityTextField = UITextField()
        guard let quantityTextField = quantityTextField else { return }
        quantityTextField.font = Fonts.openSans
        quantityTextField.textColor = UIColor.bookItBlueDark
        quantityTextField.placeholder = "0"
        quantityTextField.keyboardType = .numberPad
        stackView.addArrangedSubview(quantityTextField)
        
        quantityPeopleLabel = UILabel()
        guard let quantityPeopleLabel = quantityPeopleLabel else { return }
        quantityPeopleLabel.font = Fonts.openSansLight
        quantityPeopleLabel.textColor = UIColor.bookItBlueLight
        quantityPeopleLabel.numberOfLines = 0
        quantityPeopleLabel.text = quantityPeopleString
        stackView.addArrangedSubview(quantityPeopleLabel)
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: rangeSlider.bottomAnchor, constant: 16).isActive = true
        
        searchButton = UIButton()
        guard let searchButton = searchButton else { return }
        searchButton.backgroundColor = .clear
        searchButton.layer.cornerRadius = 4.0
        searchButton.layer.borderColor = UIColor.bookItBlueLight.cgColor
        searchButton.layer.borderWidth = 1.0
        
        searchButton.setTitleColor(.bookItBlueLight, for: .normal)
        searchButton.setTitle("Find Available Rooms", for: .normal)
        searchButton.titleLabel?.numberOfLines = 0
        searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        view.addSubview(searchButton)
        
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: DEFAULT_BUTTON_HEIGHT).isActive = true
        searchButton.widthAnchor.constraint(equalToConstant: DEFAULT_BUTTON_WIDTH).isActive = true
        searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
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
    
    
    @objc func searchButtonPressed()
    {
        self.roomData.removeAll()
        
        guard let dateRaw = datePicker?.date else { return }
        let pickedDate = getDate(myDate: dateRaw)
        
        guard let lowerValue = rangeSlider?.lowerValue else { return }
        let lowerBound = Int(lowerValue)
        guard let upperValue = rangeSlider?.upperValue else { return }
        let upperBound = Int(upperValue)
        
        print(pickedDate)
        print(lowerBound)
        print(upperBound)
        let db = Firestore.firestore()
        
        db.collection("Rooms").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let querySnapshot = querySnapshot else { return }
                for document in querySnapshot.documents {
                    
                    let room = Room(dict: document.data() as NSDictionary)
                    
                    for i in 0..<(room.times?.count ?? 0){
                        let dictionary = room.times?[i] as! NSDictionary
                        guard let reservations = dictionary["timeSlots"] as? [String] else { return }
                        guard let timestamp: Timestamp = dictionary["date"] as? Timestamp else { return }
                        let myDate: Date = timestamp.dateValue()
                        let dateString = self.getDate(myDate: myDate)
                        if(dateString == pickedDate)
                        {
                            var add = true
                            for j in lowerBound..<upperBound
                            {
                                if reservations[j] != ""
                                {
                                    add = false
                                }
                            }
                            
                            if add
                            {
                                //add
                                self.roomData.append(room)
                            }
                            
                            
                        }
                    }
                    
                    print(self.roomData.count)
                }
                
                if self.roomData.count == 0
                {
                    Util.presentAlert(title: "Sorry!", message: "We couldn't find a room for those settings.", viewController: self)
                    return
                }
                // reload tableview in BookingListViewController
                let bookListViewController = BookingListViewController()
                bookListViewController.roomData = self.roomData
                
                self.navigationController?.pushViewController(bookListViewController, animated: true)
            }
            
        }
    }
    
    @objc func dismissKeyboard()
    {
        quantityTextField?.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.title =  Titles.roomSearchViewControllerTitle
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
