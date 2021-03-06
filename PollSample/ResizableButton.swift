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
        static let UnSelectionColor = UIColor.black
        static let radioButtonColor = UIColor.init(hexColor: "#59c2ef")
    }
    
    var percentageLabel:UILabel!
    var radioButton:UIButton!
    var isSelectedOpinion:Bool = false
    var isVotedOn:Bool = false
    var percentageView:UIView!
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
    
    override open class var layerClass:AnyClass{
        get{
            return CAGradientLayer.self
        }
    }
    
    var gradientLayer:CAGradientLayer{
        get{
            return self.layer as! CAGradientLayer
        }
    }
    
    var colors:Array<UIColor>?{
        get{
            if let cgColors = self.gradientLayer.colors{
                
                var uiColors:Array<UIColor> = []
                for color in cgColors{
                    uiColors.append(UIColor.init(cgColor: color as! CGColor))
                }
                return uiColors
            }
            return nil
        }
        
        set{
            var cgColors:[CGColor] = []
            
            if let colorsd = newValue{
                
                for uiColor in colorsd{
                    
                    cgColors.append(uiColor.cgColor)
                }
                self.gradientLayer.colors = cgColors
            }
            
        }
    }
    
    var locations:Array<NSNumber>?{
        
        get{
            return self.gradientLayer.locations
        }
        
        set{
            if let someValue = newValue{
                self.gradientLayer.locations = someValue
            }
        }
    }
    
    var startPoint:CGPoint{
        get{
            return self.gradientLayer.startPoint
        }
        
        set{
            self.gradientLayer.startPoint = newValue
        }
    }
    
    var endPoint:CGPoint{
        
        get{
            return self.gradientLayer.endPoint
        }
        
        set{
            self.gradientLayer.endPoint = newValue
        }
    }
    
    var type:String{
        get{
            return self.gradientLayer.type
        }
        
        set{
            self.gradientLayer.type = newValue
        }
    }
    
    func makeSelected(){
        self.isSelectedOpinion = true
        self.radioButton.backgroundColor = ColorConstants.radioButtonColor
        
        if self.isVotedOn{
            //do additional things
            self.percentageLabel.textColor = ColorConstants.selectionColor
            self.setTitleColor(ColorConstants.UnSelectionColor, for: .normal)
        }
        else{
            self.percentageLabel.textColor = ColorConstants.UnSelectionColor
            self.setTitleColor(ColorConstants.selectionColor, for: .normal)
        }
    }
    
    func makeUnselected(){
        if self.isVotedOn{
            self.radioButton.backgroundColor = ColorConstants.radioButtonColor
            self.percentageLabel.textColor = ColorConstants.selectionColor
            self.setTitleColor(ColorConstants.UnSelectionColor, for: .normal)
            self.isSelectedOpinion = true
            return
        }
        self.percentageLabel.textColor = ColorConstants.UnSelectionColor
        self.setTitleColor(ColorConstants.UnSelectionColor, for: .normal)
        self.isSelectedOpinion = false
        self.radioButton.backgroundColor = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.radioButton != nil{
            radioButton.layer.cornerRadius = radioButton.bounds.size.width/2
            radioButton.setImage(UIImage.image(ColorConstants.radioButtonColor), for: .selected)
    
        }
        
        self.layer.cornerRadius = 10.0
        
        if self.percentageView != nil{
            
            let mask = CAShapeLayer.init()
            mask.frame = self.bounds
            mask.path = UIBezierPath.init(roundedRect: mask.bounds, byRoundingCorners: [.bottomLeft,.topLeft], cornerRadii: CGSize.init(width: 10, height: 10)).cgPath
            self.percentageView.layer.mask = mask
            
           // self.percentageView.layer.cornerRadius = 10
            //self.percentageView.clipsToBounds = true
            self.clipsToBounds = true
            
        }
     
    }
        
 }


