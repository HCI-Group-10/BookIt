//
//  Util.swift
//  BookIt
//
//  Created by Steven Hurtado on 10/6/18.
//  Copyright © 2018 HCIGroup10. All rights reserved.
//

import Foundation
import UIKit

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
    func updateToStandardFont()
    {
        font = UIFont(name: "OpenSans-Bold", size: 24)
    }
}
