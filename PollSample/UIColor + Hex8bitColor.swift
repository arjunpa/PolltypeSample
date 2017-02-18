//
//  UIColor.swift
//  PollSample
//
//  Created by Arjun P A on 14/02/17.
//  Copyright © 2017 Arjun P A. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
          //  let start = hexString.index(hexString.startIndex, offsetBy: 1)
           let hexColor = hexString.substringFromIndex(hexString.startIndex.advancedBy(1))
            
            if hexColor.characters.count == 8 {
                let scanner = NSScanner(string: hexColor)
                var hexNumber: Int32 = 0
                
                if scanner.scanInt(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 24) / 255
                    g = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x0000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
    
    convenience init(hexColor: String) {
       // let hex = hexColor.stringByTrimmingCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)
        var int = UInt32()
    //    let hex = hexColor.trimmingCharacters(in: NSCharacterSet.alphanumericCharacterSet().invertedSet)
        let hex = hexColor.stringByTrimmingCharactersInSet( NSCharacterSet.alphanumericCharacterSet().invertedSet)
        NSScanner(string: hex).scanHexInt(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
