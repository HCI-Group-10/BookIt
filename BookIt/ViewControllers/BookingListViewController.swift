//
//  BookingListViewController.swift
//  BookIt
//
//  Created by Steven Hurtado on 10/5/18.
//  Copyright © 2018 HCIGroup10. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
class BookingListViewController: UITableViewController {
    var roomData : [Room] = []
    var isQuickBook : Bool = false
    var today : Date = Date.init()
    let calendar : Calendar = Calendar.current // or e.g. Calendar(identifier: .persian)
    var todaysDate : String = ""
    var startTime : String = ""
    var endTime : String = ""
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print(isQuickBook)
        
        setUpViews()
        loadData()
    }

    func setUpViews()
    {
        view.backgroundColor = .white
        
        tableView.estimatedRowHeight = BookingListTableViewCell.DEFAULT_CELL_HEIGHT
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.register(BookingListTableViewCell.self, forCellReuseIdentifier: BookingListTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.title = isQuickBook ?  Titles.quickBookViewControllerTitle : Titles.searchResultsViewControllerTitle
    }
    
    func getDate(myDate: Date) -> String{
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: Date()) // string purpose I add here
        // convert your string to date
//        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        let myStringafd = formatter.string(from: myDate)
        
//        print("converting")
//        print(myStringafd)
        return myStringafd
    }
    
    func doQuickBookSearch()
    {
        let hour = self.calendar.component(.hour, from: self.today)
        let minute = self.calendar.component(.minute, from: self.today)
        let currTimeIndex = (hour * 2) + (minute / 30)
        
        let db = Firestore.firestore()
        db.collection("Rooms").getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let querySnapshot = querySnapshot else { return }
                for document in querySnapshot.documents {
                    
                    let room = Room(dict: document.data() as NSDictionary)
                    //                    print("printing")
                    
                    for i in 0..<(room.times?.count ?? 0){
                        guard let dictionary = room.times?[i] as? NSDictionary else { return }
                        guard let reservations = dictionary["timeSlots"] as? [String]
                            else { return }
                        guard let timestamp: Timestamp = dictionary["date"] as? Timestamp else { return }
                        let myDate: Date = timestamp.dateValue()
                        let dateString = self.getDate(myDate: myDate)
                        if(dateString == self.todaysDate && reservations[currTimeIndex] == "")
                        {
                            self.roomData.append(room)
                        }
                    }
                    
                    //                    print(self.roomData.count)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func loadData()
    {
        self.todaysDate = getDate(myDate: today)
        
        // make a request to server
        if isQuickBook
        {
            doQuickBookSearch()
        }
        else
        {
            print(roomData)
            self.tableView.reloadData()
        }
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return roomData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingListTableViewCell.identifier) as? BookingListTableViewCell else
        {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        cell.delegate = self
        let roomInfo = roomData[indexPath.row]
        cell.room = roomInfo
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BookingListViewController: BookingListTableViewCellDelegate
{
    
    func reserveButtonPressed(room: Room?)
    {
        if let room = room, let nav = navigationController
        {
            let reservation = Reservation()
            
            reservation.room = room
            let date = Date()
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "dd-MMM-YYYY"
            reservation.date = dateFormatter.string(from: date)
            if startTime != "" && endTime != ""{
                reservation.startTime = startTime
                reservation.endTime = endTime
            }
            else{
            var hour = self.calendar.component(.hour, from: self.today)
            var minute = self.calendar.component(.minute, from: self.today)
            var endTimeString : String = ""
            if minute < 30{
                minute = 30
                endTimeString = "\(hour):\(minute)"
            }
            else{
                
                hour = hour + 1
                endTimeString = "\(hour):00"
            }
            
            dateFormatter.dateFormat = "HH:mm"
            reservation.startTime = dateFormatter.string(from: date)
            reservation.endTime = endTimeString
            
            }
            print(reservation.startTime)
            print(reservation.endTime)
            let roomReservationVC = RoomReservationViewController()
            roomReservationVC.reservation = reservation
            
            nav.pushViewController(roomReservationVC, animated: true)
        }
    }
}
