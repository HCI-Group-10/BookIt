//
//  Util.swift
//  BookIt
//
//  Created by Steven Hurtado on 10/6/18.
//  Copyright © 2018 HCIGroup10. All rights reserved.
//

import Foundation
import UIKit

class Util
{
    static func presentAlert(title: String, message: String, viewController: UIViewController)
    {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(ac, animated: true)
    }   
}

class Titles
{
    static let quickBookViewControllerTitle = "Quick Book"
    static let roomSearchViewControllerTitle = "Reserve A Room"
    static let roomScanViewControllerTitle = "Check Room Status"
    static let userPageViewControllerTitle = "My Reservations"
    static let searchResultsViewControllerTitle = "Available Rooms"
}

class Fonts
{
    static var openSans : UIFont
    {
        guard let font = UIFont(name: "OpenSans", size: 20) else { return UIFont() }
        return font
    }
    
    static var openSansLight : UIFont
    {
        guard let font = UIFont(name: "OpenSans-Light", size: 20) else { return UIFont() }
        return font
    }
    
    static var openSansBold : UIFont
    {
        guard let font = UIFont(name: "OpenSans-Bold", size: 20) else { return UIFont() }
        return font
    }
}

extension UIView
{
    static let padding : CGFloat = 16.0
    
    func assignUIStyle()
    {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 20.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 10)
        self.layer.shadowRadius = 1
        
        self.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
}

class Assets
{
    static let homeIcon = "home"
    static let searchIcon = "search"
    static let qrIcon = "qrcode"
    static let userIcon = "user"
}

extension UIColor
{
    convenience init(red: Int, green: Int, blue: Int)
    {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(hex: Int)
    {
        self.init(red: (hex >> 16) & 0xFF, green: (hex >> 8) & 0xFF, blue: hex & 0xFF)
    }
    
    static var bookItBlueDark : UIColor
    {
        return UIColor(hex: 0x001C55)
    }
    
    static var bookItBlueLight : UIColor
    {
        return UIColor(hex: 0x3066BE)
    }
    
    static var bookItBlueAccent : UIColor
    {
        return UIColor(hex: 0x0A2472)
    }
    
    static var barLightTranslucent : UIColor
    {
        return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.84)
    }
}

extension UIImage
{
    func with(color: UIColor) -> UIImage
    {
        guard let cgImage = self.cgImage else
        {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)
        let imageRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.clip(to: imageRect, mask: cgImage)
        color.setFill()
        context.fill(imageRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return newImage
    }
}

extension UINavigationBar
{
    func installBlurEffect()
    {
        isTranslucent = true
        setBackgroundImage(UIImage(), for: .default)
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        var blurFrame = bounds
        blurFrame.size.height += statusBarHeight
        blurFrame.origin.y -= statusBarHeight
        let blurView  = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.isUserInteractionEnabled = false
        blurView.frame = blurFrame
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
        blurView.layer.zPosition = -1
    }
}

extension UITabBar
{
    func installBlurEffect()
    {
        isTranslucent = true
        backgroundImage = UIImage()

        let blurView  = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.isUserInteractionEnabled = false
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
        blurView.layer.zPosition = -1
    }
}

extension UILabel
{
    var defaultFont: UIFont?
    {
        get { return self.font }
        set { self.font = newValue }
    }
    
    func updateToStandardFont()
    {
        font = UIFont(name: "OpenSans-Bold", size: 24)
    }
}

extension String
{
    static func getTimeFrom30MinIntervalValue(val: Int) -> Date?
    {
        //max of 48 30 minute intervals in a day
        var minutes = val * 30
        let hours = minutes / 60
        minutes = val.remainderReportingOverflow(dividingBy: 2).partialValue * 30//Int(val.truncatingRemainder(dividingBy: 2) * 30)
        
        let dateAsString = "\(hours):\(minutes)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        
        return dateFormatter.date(from: dateAsString)
    }
    
    static func getTimeFormattedFrom30MinIntervalValue(val: Int) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        if let date = getTimeFrom30MinIntervalValue(val: val)
        {
            return dateFormatter.string(from: date)
        }
        
        return ""
    }
}

func getImageWithColorPosition(color: UIColor, size: CGSize, lineSize: CGSize) -> UIImage
{
    let rect = CGRect(x:2, y: 0, width: size.width, height: size.height)
    let rectLine = CGRect(x: 9, y: size.height-lineSize.height - 8, width: lineSize.width, height: lineSize.height)
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    UIColor.clear.setFill()
    UIRectFill(rect)
    color.setFill()
    UIRectFill(rectLine)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
}
