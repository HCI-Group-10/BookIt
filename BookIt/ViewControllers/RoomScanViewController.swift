//
//  RoomScanViewController.swift
//  BookIt
//
//  Created by Steven Hurtado on 10/5/18.
//  Copyright © 2018 HCIGroup10. All rights reserved.
//

import UIKit

class RoomScanViewController: UIViewController
{
    var scannerViewController : ScannerViewController!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        setUpViews()
    }
    
    func setUpViews()
    {
        scannerViewController = ScannerViewController()
        scannerViewController.view.frame = view.frame
        scannerViewController.delegate = self
        
        addChildViewController(scannerViewController)
        view.addSubview(scannerViewController.view)
        
        scannerViewController.didMove(toParentViewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.title =  Titles.roomScanViewControllerTitle
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension RoomScanViewController : ScannerViewControllerDelegate
{
    func outputFromScan(result: String)
    {
        let label = UILabel(frame: CGRect(x: 100, y: 200, width: 300, height: 200))
        label.font = label.font.withSize(34)
        label.text = result
        label.textColor = .red
        view.addSubview(label)
    }
}
