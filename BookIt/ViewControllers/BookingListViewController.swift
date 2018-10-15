//
//  BookingListViewController.swift
//  BookIt
//
//  Created by Steven Hurtado on 10/5/18.
//  Copyright © 2018 HCIGroup10. All rights reserved.
//

import UIKit

class BookingListViewController: UITableViewController {
    var roomData : [Room] = []
    var isQuickBook : Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setUpViews()
        loadData()
//
//        btn.addTarget(self, action: #selector(BookingListViewController.goToNextView), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }

    func setUpViews()
    {
        tableView.backgroundColor = UIColor.bookItBlueLight
        
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
    
    func loadData()
    {
        // make a request to server
        let dictArr : [NSDictionary] = [[
            "room" : "Babbage",
            "roomNumber" : "L113",
            "location" : "Marston",
            "capacity" : "4"
        ],
        [
        "room" : "Carson",
        "roomNumber" : "L114",
        "location" : "Marston",
        "capacity" : "4"
        ],
        [
        "room" : "Wu",
        "roomNumber" : "L115",
        "location" : "Marston",
        "capacity" : "4"
        ],
        [
        "room" : "The Long Titled Room",
        "roomNumber" : "L116",
        "location" : "The library that is far away",
        "capacity" : "245"
        ]]
        
        for dict in dictArr
        {
            roomData.append(Room(dict: dict))
        }
        
        tableView.reloadData()
    }
    
    @objc func goToNextView()
    {
        let vc = BookingListViewController()
        navigationController?.pushViewController(vc, animated: true)
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
            
            dateFormatter.dateFormat = "MMM d, yyyy"
            reservation.date = dateFormatter.string(from: date)
            
            dateFormatter.dateFormat = "HH:mm"
            reservation.startTime = dateFormatter.string(from: date)
            reservation.endTime = dateFormatter.string(from: date)
            
            let roomReservationVC = RoomReservationViewController()
            roomReservationVC.reservation = reservation
            
            nav.pushViewController(roomReservationVC, animated: true)
        }
    }
}
