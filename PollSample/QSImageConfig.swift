//
//  QSImageConfig.swift
//  QuintypeSDK
//
//  Created by Madhusudhan Sambojhu on 07/08/15.
//  Copyright (c) 2015 Quintype. All rights reserved.
//

import Foundation

import UIKit

open class QSImageConfig {
    static let widthFormat: String = "https://%@/%@?w=%d&q=%d&fm=jpeg";
    static let heightFormat: String = "https://%@/%@?h=%d&q=%d&fm=jpeg";
    static let jsonFormat: String = "https://%@/%@?fm=json";
    static let widthFormatGif: String = "https://%@/%@?w=%d&q=%d";
    static let heightFormatGif: String = "https://%@/%@?h=%d&q=%d";
    static let maxGifSize: Int = 200
    

    fileprivate var _baseUrl: String!
    fileprivate var _quality: CGFloat = 30
    
    open static let imageQualityOptions = ["High", "Medium", "Low"]
    
    open static let highQualityFactor: CGFloat = 0.9
    open static let mediumQualityFactor: CGFloat = 0.8
    open static let lowQualityFactor: CGFloat = 0.7
    
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
    
    open func imageUrlFor(_ heroImageS3Key: String, width: Int?) -> URL {
        
        
        if let widthm = width{
            var pixelWidth = Int(Float(UIScreen.main.scale) * Float(widthm))
            var format = QSImageConfig.widthFormat
            if(heroImageS3Key.hasSuffix(".gif")) {
                format = QSImageConfig.widthFormatGif
                pixelWidth = min(QSImageConfig.maxGifSize, pixelWidth)
            }
            let str = String(format: format, _baseUrl, heroImageS3Key.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!, pixelWidth, Int(round(_quality * currentQualityFactor)))
            let url = URL(string: str)
            return url!
            
        }
        
        let str = "https://" + self._baseUrl + "/" + heroImageS3Key.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        
        return URL(string: str)!
        
        
    }
    
    open func imageUrlFor(_ heroImageS3Key: String, height: Int?) -> URL {
        
        
        if let heightm = height{
            var pixelWidth = Int(Float(UIScreen.main.scale) * Float(heightm))
            var format = QSImageConfig.heightFormat
            if(heroImageS3Key.hasSuffix(".gif")) {
                format = QSImageConfig.heightFormatGif
                pixelWidth = min(QSImageConfig.maxGifSize, pixelWidth)
            }
            let str = String(format: format, _baseUrl, heroImageS3Key.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!, pixelWidth, Int(round(_quality * currentQualityFactor)))
            let url = URL(string: str)
            return url!
            
        }
        
        let str = "https://" + self._baseUrl + "/" + heroImageS3Key.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        
        return URL(string: str)!
        
        
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

    
    open func isQualityHigh() -> Bool {
        return currentQualityFactor == QSImageConfig.highQualityFactor
    }
    
    open func isQualityMedium() -> Bool {
        return currentQualityFactor == QSImageConfig.mediumQualityFactor
    }
    
    open func isQualityLow() -> Bool{
        return currentQualityFactor == QSImageConfig.lowQualityFactor
    }
    
    open func setQuality(_ quality: String) {
        switch quality {
        case "High":
            currentQualityFactor = QSImageConfig.highQualityFactor
        case "Medium":
            currentQualityFactor = QSImageConfig.mediumQualityFactor
        default:
            currentQualityFactor = QSImageConfig.lowQualityFactor
        }
           }
    
    open func isCurrentQuality(_ quality: String) -> Bool {
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
