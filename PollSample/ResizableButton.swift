//
//  ResizableExtension.swift
//  PollSample
//
//  Created by Arjun P A on 24/12/16.
//  Copyright © 2016 Arjun P A. All rights reserved.
//

import Foundation
import UIKit

class ResizableButton: UIButton {
    
    
    struct ColorConstants {
        
        static let selectionColor = UIColor.init(hexColor: "#59c2ee")
        static let UnSelectionColor = UIColor.blackColor()
        static let radioButtonColor = UIColor.init(hexColor: "#59c2ef")
    }
    
    var percentageLabel:UILabel?
    var radioButton:UIButton!
    var isSelectedOpinion:Bool = false
    var isVotedOn:Bool = false
    var percentageView:UIView?
        // MARK: - Init
        
    
        
        
        // MARK: - Overrides
        
    /*    override func intrinsicContentSize() -> CGSize
        {
           /* let labelSize = titleLabel?.sizeThatFits(CGSizeMake(self.frame.size.width, CGFloat.max)) ?? CGSizeZero
            let desiredButtonSize = CGSizeMake(labelSize.width + titleEdgeInsets.left + titleEdgeInsets.right, labelSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom)
            
            return desiredButtonSize
 */
         
                let size = titleLabel?.intrinsicContentSize() ?? CGSizeZero
                return CGSizeMake(size.width + titleEdgeInsets.left + titleEdgeInsets.right, size.height + titleEdgeInsets.top + titleEdgeInsets.bottom)
            
        }
 */
    
  /*  override public class var layerClass:AnyClass{
        get{
            return CAGradientLayer.self
        }
    }
 */
    internal override class func layerClass() -> AnyClass{
        return CAGradientLayer.self
    }
    
  
    
    var colors:Array<UIColor>?{
        get{
            if let cgColors = (self.layer as! CAGradientLayer).colors{
                
                var uiColors:Array<UIColor> = []
                for color in cgColors{
                    uiColors.append(UIColor.init(CGColor: color as! CGColor))
                }
                return uiColors
            }
            return nil
        }
        
        set{
            var cgColors:[CGColor] = []
            
            if let colorsd = newValue{
                
                for uiColor in colorsd{
                    
                    cgColors.append(uiColor.CGColor)
                }
                (self.layer as! CAGradientLayer).colors = cgColors
            }
            
        }
    }
    
    var locations:Array<NSNumber>?{
        
        get{
            return (self.layer as! CAGradientLayer).locations
        }
        
        set{
            if let someValue = newValue{
                (self.layer as! CAGradientLayer).locations = someValue
            }
        }
    }
    
    var startPoint:CGPoint{
        get{
            return (self.layer as! CAGradientLayer).startPoint
        }
        
        set{
            (self.layer as! CAGradientLayer).startPoint = newValue
        }
    }
    
    var endPoint:CGPoint{
        
        get{
            return (self.layer as! CAGradientLayer).endPoint
        }
        
        set{
            (self.layer as! CAGradientLayer).endPoint = newValue
        }
    }
    
    var type:String{
        get{
            return (self.layer as! CAGradientLayer).type
        }
        
        set{
            (self.layer as! CAGradientLayer).type = newValue
        }
    }
    
    func makeSelected(){
        self.isSelectedOpinion = true
        self.radioButton.backgroundColor = ColorConstants.radioButtonColor
        
        if self.isVotedOn{
            //do additional things
        
            self.percentageLabel?.textColor = ColorConstants.selectionColor
            self.setTitleColor(ColorConstants.UnSelectionColor, forState: .Normal)
        }
        else{
            self.percentageLabel?.textColor = ColorConstants.UnSelectionColor
            self.setTitleColor(ColorConstants.selectionColor, forState: .Normal)
        }
    }
    
    func makeUnselected(){
        if self.isVotedOn{
            self.radioButton.backgroundColor = ColorConstants.radioButtonColor
            self.percentageLabel?.textColor = ColorConstants.selectionColor
            self.setTitleColor(ColorConstants.UnSelectionColor, forState: .Normal)
            self.isSelectedOpinion = true
            return
        }
    
            self.percentageLabel?.textColor = ColorConstants.UnSelectionColor
        
        self.setTitleColor(ColorConstants.UnSelectionColor, forState: .Normal)
        self.isSelectedOpinion = false
        self.radioButton.backgroundColor = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.radioButton != nil{
            radioButton.layer.cornerRadius = radioButton.bounds.size.width/2
            radioButton.setImage(UIImage.image(ColorConstants.radioButtonColor), forState: .Selected)
    
        }
        
        self.layer.cornerRadius = 10.0
        
        
            
            let mask = CAShapeLayer.init()
            mask.frame = self.bounds
            mask.path = UIBezierPath.init(roundedRect: mask.bounds, byRoundingCorners: [.BottomLeft,.TopLeft], cornerRadii: CGSize.init(width: 10, height: 10)).CGPath
            self.percentageView?.layer.mask = mask
            
           // self.percentageView.layer.cornerRadius = 10
            //self.percentageView.clipsToBounds = true
            self.clipsToBounds = true
            
        
     
    }
        
 }


