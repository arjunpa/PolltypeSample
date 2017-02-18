//
//  UIImage+ImageWithColor.swift
//  PollSample
//
//  Created by Arjun P A on 14/02/17.
//  Copyright © 2017 Arjun P A. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

extension UIImage{

   class func image(_ with:UIColor) -> UIImage{
        let rect = CGRect.init(x: 0, y: 0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
      //  context?.fill(rect)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
