//
//  RoomScanViewController.swift
//  BookIt
//
//  Created by Steven Hurtado on 10/5/18.
//  Copyright © 2018 HCIGroup10. All rights reserved.
//

import UIKit

class ScanOverlayView : UIView
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    func setUpViews()
    {
        let topLeft = getCornerView(corner: 0)
        let topRight = getCornerView(corner: 1)
        let bottomRight = getCornerView(corner: 2)
        let bottomLeft = getCornerView(corner: 3)
        
        addSubview(topLeft)
        addSubview(topRight)
        addSubview(bottomRight)
        addSubview(bottomLeft)
    }
    
    func getCornerView(corner: Int) -> UIView
    {
        let cornerView = UIView()
        cornerView.frame = CGRect(x: 0, y: 0, width: frame.width/4, height: frame.height/4)
        
        let line = CAShapeLayer()
        line.strokeColor = UIColor.white.cgColor
        line.lineWidth = 16.0
        line.opacity = 0.5
        line.fillColor = UIColor.clear.cgColor
        line.lineCap = kCALineCapRound
        
        let linePath = UIBezierPath()
        
        switch(corner)
        {
        case 0:
            // top left corner
            linePath.move(to: CGPoint(x: frame.origin.x, y: frame.origin.y + cornerView.frame.height))
            linePath.addLine(to: CGPoint(x: frame.origin.x, y: frame.origin.y))
            linePath.addLine(to: CGPoint(x: frame.origin.x + cornerView.frame.width, y: frame.origin.y))
            line.path = linePath.cgPath
            break
        case 1:
            // top right corner
            linePath.move(to: CGPoint(x: frame.origin.x + frame.width, y: frame.origin.y + cornerView.frame.height))
            linePath.addLine(to: CGPoint(x: frame.origin.x + frame.width, y: frame.origin.y))
            linePath.addLine(to: CGPoint(x: frame.origin.x + frame.width - cornerView.frame.width, y: frame.origin.y))
            line.path = linePath.cgPath
            break
        case 2:
            // bottom right corner
            linePath.move(to: CGPoint(x: frame.origin.x + frame.width, y: frame.origin.y + frame.height - cornerView.frame.height))
            linePath.addLine(to: CGPoint(x: frame.origin.x + frame.width, y: frame.origin.y + frame.height))
            linePath.addLine(to: CGPoint(x: frame.origin.x + frame.width - cornerView.frame.width, y: frame.origin.y + frame.height))
            line.path = linePath.cgPath
            break
        case 3:
            // bottom left corner
            linePath.move(to: CGPoint(x: frame.origin.x + cornerView.frame.width, y: frame.origin.y + frame.height))
            linePath.addLine(to: CGPoint(x: frame.origin.x, y: frame.origin.y + frame.height))
            linePath.addLine(to: CGPoint(x: frame.origin.x, y: frame.origin.y + frame.height - cornerView.frame.height))
            line.path = linePath.cgPath
            break
        default:
            break
        }
        
        cornerView.layer.addSublayer(line)
        return cornerView
    }
}

class RoomScanViewController: UIViewController
{
    var scannerViewController : ScannerViewController!
    var overlayView : ScanOverlayView?
    let OFFSET : CGFloat = 32.0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        setUpViews()
    }
    
    func setUpViews()
    {
        //add scan controller
        scannerViewController = ScannerViewController()
        scannerViewController.view.frame = view.frame
        scannerViewController.delegate = self
        
        addChildViewController(scannerViewController)
        view.addSubview(scannerViewController.view)
        
        scannerViewController.didMove(toParentViewController: self)
        
        // add overlay
        overlayView = ScanOverlayView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        if let overlayView = overlayView
        {
            view.addSubview(overlayView)
            
            overlayView.translatesAutoresizingMaskIntoConstraints = false
            overlayView.widthAnchor.constraint(equalToConstant: overlayView.frame.width).isActive = true
            overlayView.heightAnchor.constraint(equalToConstant: overlayView.frame.height).isActive = true
            overlayView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            overlayView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -OFFSET).isActive = true
        }
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
        // result should be room, make request for current reservation using that room
        
        // if open, show card with book now
        
        // if taken, show card with request switch
    }
}
