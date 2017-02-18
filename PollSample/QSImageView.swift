//
//  QSImageView.swift
//  QuintypeSDK
//
//  Created by Madhusudhan Sambojhu on 25/09/15.
//  Copyright (c) 2015 Quintype. All rights reserved.
//

import Foundation
import DFImageManager
//// A custom version of image view for the sdk
public class QSImageView : DFAnimatedImageView {
    
    let cdn_image = "qt-staging-01.imgix.net"
    
    public func loadHeroImageAspectFit(_ urlStr: String, targetSize: CGSize) {
   
        //hero images need focus point transformations
        self.image = nil
        self.backgroundColor = UIColor.blackColor()
        self.allowsAnimations = false
        self.allowsGIFPlayback = true
        self.managesRequestPriorities = true
        self.prepareForReuse()
        let options = DFMutableImageRequestOptions()
        options.allowsClipping = true
        var url = QSImageConfig.init(baseURL: cdn_image).imageUrlFor(urlStr, width: Int(targetSize.width))
        
        if(targetSize.width > targetSize.height) {
            //landscape
            url = QSImageConfig.init(baseURL: cdn_image).imageUrlFor(urlStr, width: Int(targetSize.width))
        } else {
            //portrait
            url = QSImageConfig.init(baseURL: cdn_image).imageUrlFor(urlStr, height: Int(targetSize.height))
        }
        
        let scale = UIScreen.mainScreen().scale
        let scaledTargetSize = CGSize(width: targetSize.width * scale, height: targetSize.height * scale)
        
        let request = DFImageRequest(resource: url, targetSize: scaledTargetSize, contentMode: DFImageContentMode.AspectFit, options: options.options)
        /*if(story.heroImageMetadata != nil && story.heroImageMetadata.focusPoints != nil) {
            request.focusPoint = CGPoint(x: story.heroImageMetadata.focusPoints[0], y: story.heroImageMetadata.focusPoints[1])
            request.originalImageSize = CGSize(width: story.heroImageMetadata.width, height: story.heroImageMetadata.height)
        }
 */
       // setImageWith(request)
        self.setImageWithRequest(request)
    }

  
    
    public func loadImage(resource: NSURL?, targetSize: CGSize, contentMode: DFImageContentMode, options: DFImageRequestOptions?) {
        //expects target size to be non scaled, so scale target size
        self.managesRequestPriorities = true
        self.allowsAnimations = true
        self.allowsGIFPlayback = true
        let scale = UIScreen.mainScreen().scale
        let scaledTargetSize = CGSize(width: targetSize.width * scale, height: targetSize.height * scale)
        let optionsd = DFMutableImageRequestOptions()
        //optionsd.allowsClipping = true
        setImageWithResource(resource, targetSize: scaledTargetSize, contentMode: contentMode, options: optionsd.options)
    }
}
