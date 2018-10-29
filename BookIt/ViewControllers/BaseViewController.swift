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

class BookItNavigationController : UINavigationController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        updateBackgroundView()
        updateFont()
    }
    
    func updateFont()
    {
        navigationBar.titleTextAttributes = [.font: Fonts.openSansLight, NSAttributedStringKey.foregroundColor:UIColor.bookItBlueLight]
    }
    
    func updateBackgroundView()
    {
//        navigationBar.installBlurEffect()
        navigationBar.barTintColor = .white
        navigationBar.isOpaque = true
        navigationBar.isTranslucent = false
        navigationBar.backgroundColor = .white
    }
}

class BaseViewController: UITabBarController
{
    var userPageViewController : UserPageViewController?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        User.createUser(firstName: "Steven", lastName: "Hurtado", email: "shurt@gmail.com")
        setUpTabBarController()
    }
    
    func setUpTabBarController()
    {
        // QUICK BOOK
        let quickBookViewController = BookingListViewController()
        quickBookViewController.isQuickBook = true
        
        let navQuickBookViewController = BookItNavigationController(rootViewController: quickBookViewController)
        navQuickBookViewController.tabBarItem = UITabBarItem(title: Titles.quickBookViewControllerTitle, image: UIImage(named: Assets.homeIcon), tag: 0)
        
        let roomSearchViewController = RoomSearchViewController()
        roomSearchViewController.view.backgroundColor = .white
        
        let navRoomSearchViewController = BookItNavigationController(rootViewController: roomSearchViewController)
        navRoomSearchViewController.tabBarItem = UITabBarItem(title: Titles.roomSearchViewControllerTitle, image: UIImage(named: Assets.searchIcon), tag: 1)
        
        let roomScanViewController = RoomScanViewController()
        roomScanViewController.view.backgroundColor = .white
        
        let navRoomScanViewController = BookItNavigationController(rootViewController: roomScanViewController)
        navRoomScanViewController.tabBarItem = UITabBarItem(title: Titles.roomScanViewControllerTitle, image: UIImage(named: Assets.qrIcon), tag: 2)
        
        userPageViewController = UserPageViewController()
        guard let userPageViewController = userPageViewController else { return }
        userPageViewController.view.backgroundColor = .white
        
        let navUserPageViewController = BookItNavigationController(rootViewController: userPageViewController)
        navUserPageViewController.tabBarItem = UITabBarItem(title: Titles.userPageViewControllerTitle, image: UIImage(named: Assets.userIcon), tag: 3)
        
        viewControllers = [navQuickBookViewController, navRoomSearchViewController, navRoomScanViewController, navUserPageViewController]
        
        updateUniversalAppearances()
        NotificationCenter.default.addObserver(self, selector: #selector(reservationUpdated), name: NSNotification.Name.init("reservation_update"), object: nil)
    }
    
    @objc func reservationUpdated()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.selectedIndex = (self.viewControllers?.count ?? 1) - 1
            if let viewController = self.viewControllers?[self.selectedIndex]
            {
                if User.sharedInstance()?.reservation != nil
                {
                    Util.presentAlert(title: "Success!", message: "Your reservation has been made.", viewController: viewController)
                }
                else
                {
                    Util.presentAlert(title: "No Issues", message: "Your reservation has succesfully been cancelled.", viewController: viewController)
                }
            }
        }
    }
    
    func updateUniversalAppearances()
    {
        UITabBar.appearance().tintColor = UIColor.bookItBlueLight
        UITabBar.appearance().isOpaque = true
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().backgroundColor = .white
        
        UITabBar.appearance().selectionIndicatorImage = getImageWithColorPosition(color: UIColor.bookItBlueLight, size: CGSize(width:(self.view.frame.size.width)/4, height: 48.2), lineSize: CGSize(width:(self.view.frame.size.width)/5, height: 2))
        
        if let items = tabBar.items
        {
            for item in  items {
                if let selectedImage = item.selectedImage?.with(color: UIColor.bookItBlueDark).withRenderingMode(.alwaysOriginal)
                {
                    item.image = selectedImage
                }
            }
        }
    
        let normalAttributes =
        [
            NSAttributedString.Key.foregroundColor : UIColor.bookItBlueDark,
            NSAttributedString.Key.font : Fonts.openSansLight.withSize(10.0)
        ]
        let selectedAttributes =
        [
            NSAttributedString.Key.foregroundColor : UIColor.bookItBlueLight,
            NSAttributedString.Key.font : Fonts.openSans.withSize(10.0)
        ]
        
        // unselected
        UITabBarItem.appearance().setTitleTextAttributes(normalAttributes, for: .normal)
        
        // selected
        UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes, for: .selected)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
