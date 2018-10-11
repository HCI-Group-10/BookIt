//
//  BaseViewController.swift
//  BookIt
//
//  Created by Steven Hurtado on 10/5/18.
//  Copyright © 2018 HCIGroup10. All rights reserved.
//
//  This class will act as our base class for the tab bar view controller
//

import UIKit

class BaseViewController: UITabBarController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setUpTabBarController()
    }
    
    func setUpTabBarController()
    {
        // QUICK BOOK
        let quickBookViewController = BookingListViewController()
        quickBookViewController.isQuickBook = true
        quickBookViewController.view.backgroundColor = .white
        
        let navQuickBookViewController = UINavigationController(rootViewController: quickBookViewController)
        navQuickBookViewController.tabBarItem = UITabBarItem(title: Titles.quickBookViewControllerTitle, image: UIImage(named: Assets.homeIcon), tag: 0)
        
        let roomSearchViewController = RoomSearchViewController()
        roomSearchViewController.view.backgroundColor = .white
        
        let navRoomSearchViewController = UINavigationController(rootViewController: roomSearchViewController)
        navRoomSearchViewController.tabBarItem = UITabBarItem(title: Titles.roomSearchViewControllerTitle, image: UIImage(named: Assets.searchIcon), tag: 1)
        
        let roomScanViewController = RoomScanViewController()
        roomScanViewController.view.backgroundColor = .white
        
        let navRoomScanViewController = UINavigationController(rootViewController: roomScanViewController)
        navRoomScanViewController.tabBarItem = UITabBarItem(title: Titles.roomScanViewControllerTitle, image: UIImage(named: Assets.qrIcon), tag: 2)
        
        let userPageViewController = UserPageViewController()
        userPageViewController.view.backgroundColor = .white
        
        let navUserPageViewController = UINavigationController(rootViewController: userPageViewController)
        navUserPageViewController.tabBarItem = UITabBarItem(title: Titles.userPageViewControllerTitle, image: UIImage(named: Assets.userIcon), tag: 3)
        
        viewControllers = [navQuickBookViewController, navRoomSearchViewController, navRoomScanViewController, navUserPageViewController]
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

