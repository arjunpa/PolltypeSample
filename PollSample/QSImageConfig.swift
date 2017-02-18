//
//  QSImageConfig.swift
//  QuintypeSDK
//
//  Created by Madhusudhan Sambojhu on 07/08/15.
//  Copyright (c) 2015 Quintype. All rights reserved.
//

import Foundation

import UIKit

public class QSImageConfig {
    static let widthFormat: String = "https://%@/%@?w=%d&q=%d&fm=jpeg";
    static let heightFormat: String = "https://%@/%@?h=%d&q=%d&fm=jpeg";
    static let jsonFormat: String = "https://%@/%@?fm=json";
    static let widthFormatGif: String = "https://%@/%@?w=%d&q=%d";
    static let heightFormatGif: String = "https://%@/%@?h=%d&q=%d";
    static let maxGifSize: Int = 200
    

    private var _baseUrl: String!
    private var _quality: CGFloat = 30
    
    public static let imageQualityOptions = ["High", "Medium", "Low"]
    
    public static let highQualityFactor: CGFloat = 0.9
    public static let mediumQualityFactor: CGFloat = 0.8
    public static let lowQualityFactor: CGFloat = 0.7
    
    var currentQualityFactor = QSImageConfig.lowQualityFactor

    
    
    

    /**
    Build url for a story hero image to fit width

    - parameter story: story
    - parameter width: width in points

    - returns: url for image
    */
    
    public init(baseURL:String){
        _baseUrl = baseURL
    }
    
    public func imageUrlFor(heroImageS3Key: String, width: Int?) -> NSURL {
        
        
        if let widthm = width{
            var pixelWidth = Int(Float(UIScreen.mainScreen().scale) * Float(widthm))
            var format = QSImageConfig.widthFormat
            if(heroImageS3Key.hasSuffix(".gif")) {
                format = QSImageConfig.widthFormatGif
                pixelWidth = min(QSImageConfig.maxGifSize, pixelWidth)
            }
            let str = String(format: format, _baseUrl, heroImageS3Key.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!, pixelWidth, Int(round(_quality * currentQualityFactor)))
            let url = NSURL(string: str)
            return url!
            
        }
        
        let str = "https://" + self._baseUrl + "/" + heroImageS3Key.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!
        
        return NSURL(string: str)!
        
        
    }
    
    public func imageUrlFor(heroImageS3Key: String, height: Int?) -> NSURL {
        
        
        if let heightm = height{
            var pixelWidth = Int(Float(UIScreen.mainScreen().scale) * Float(heightm))
            var format = QSImageConfig.heightFormat
            if(heroImageS3Key.hasSuffix(".gif")) {
                format = QSImageConfig.heightFormatGif
                pixelWidth = min(QSImageConfig.maxGifSize, pixelWidth)
            }
            let str = String(format: format, _baseUrl, heroImageS3Key.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!, pixelWidth, Int(round(_quality * currentQualityFactor)))
            let url = NSURL(string: str)
            return url!
            
        }
        
        let str = "https://" + self._baseUrl + "/" + heroImageS3Key.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!
        
        return NSURL(string: str)!
        
        
    }
    
    

    
    
   
    
   

    /**
    Build url for a story hero image to fit default width
    
    - parameter story: story
    
    - returns: url for image
    */

    
    /**
    Build url for story element image to fit width
    
    - parameter elem:  story element
    - parameter width: width to fit in points
    
    - returns: url for image
    */
  
    
    /**
    Build url for story element image to fit height
    
    - parameter elem:   story element
    - parameter height: height to fit in points
    
    - returns: url for image
    */
  
    
    /**
    Build url for story element image to fit height
    
    - parameter elem:  story element
    - parameter height: height to fit in points
    
    - returns: url for image
    */

    
    public func isQualityHigh() -> Bool {
        return currentQualityFactor == QSImageConfig.highQualityFactor
    }
    
    public func isQualityMedium() -> Bool {
        return currentQualityFactor == QSImageConfig.mediumQualityFactor
    }
    
    public func isQualityLow() -> Bool{
        return currentQualityFactor == QSImageConfig.lowQualityFactor
    }
    
    public func setQuality(_ quality: String) {
        switch quality {
        case "High":
            currentQualityFactor = QSImageConfig.highQualityFactor
        case "Medium":
            currentQualityFactor = QSImageConfig.mediumQualityFactor
        default:
            currentQualityFactor = QSImageConfig.lowQualityFactor
        }
           }
    
    public func isCurrentQuality(_ quality: String) -> Bool {
        switch quality {
        case "High":
            return currentQualityFactor == QSImageConfig.highQualityFactor
        case "Medium":
            return currentQualityFactor == QSImageConfig.mediumQualityFactor
        case "Low":
            return currentQualityFactor == QSImageConfig.lowQualityFactor
        default:
            return false
        }
    }
}
