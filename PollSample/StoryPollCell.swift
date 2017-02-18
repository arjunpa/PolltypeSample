//
//  StoryPollCell.swift
//  PollSample
//
//  Created by Arjun P A on 24/12/16.
//  Copyright © 2016 Arjun P A. All rights reserved.
//

import Foundation
import UIKit

protocol StoryPollCellDelegate:class {
    
    func didClickOnVote(poll:Poll, opinionIndex:Int, cell:StoryPollCell)
    
}



class StoryPollCell: UICollectionViewCell {
    
    enum Constants:Int {
        case container_TAG = 200
        case shareContainer_TAG = 300
        case poweredByText_TAG = 1000
        case activityIndicator_TAG = 2000
    }
    

    var containerView:UIView!
    var poll:Poll!
    private var opinionButtons:[UIButton] = []
    weak var pollDelegate:StoryPollCellDelegate?
    var questionLbl:UILabel = {
        let questionLbl = UILabel.init()
        questionLbl.translatesAutoresizingMaskIntoConstraints = false
        questionLbl.textColor = UIColor.blackColor()
        questionLbl.numberOfLines = 4
        return questionLbl
    }()
    
    var imageView:QSImageView = {
        let imageView = QSImageView.init()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var pollDescription:UITextView = {
        let textView = UITextView.init()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.scrollEnabled = false
        textView.editable = false
        textView.selectable = true
        textView.font = UIFont.systemFontOfSize(16)
        textView.textColor = UIColor.lightGrayColor()
        return textView
    }()
    
    var voteButton:UIButton = {
        let voteButtond = UIButton.init(type: .Custom)
        voteButtond.translatesAutoresizingMaskIntoConstraints = false
        voteButtond.backgroundColor = UIColor.init(hexColor: "#0165a7")
        voteButtond.setTitle("VOTE", forState: .Normal)
        voteButtond.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        return voteButtond
    }()
    
    var shareContainer:UIView = {
    
        let shareView = UIView.init()
        shareView.translatesAutoresizingMaskIntoConstraints = false
        shareView.tag = Constants.shareContainer_TAG.rawValue
        shareView.backgroundColor = UIColor.init(hexColor: "#f6f9fb")
        return shareView
        
    }()
    
    var shareButton:UIButton = {
        let shareBtn = UIButton.init(type: .Custom)
        shareBtn.translatesAutoresizingMaskIntoConstraints = false
        shareBtn.setTitleColor(UIColor.init(hexColor: "#0165a7"), forState: .Normal)
        shareBtn.layer.borderColor = UIColor.init(hexColor: "#0165a7").CGColor
        shareBtn.layer.borderWidth = 3.0
        return shareBtn
    }()
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    }
    
    

    func configure(storyElement:StoryElement){
        
        if let existingActivityIndicator = self.contentView.viewWithTag(2000) as? UIActivityIndicatorView{
         
            existingActivityIndicator.removeFromSuperview()
        }
        
        if let polld = storyElement.poll{
            self.configure(polld)
        }
        else{
            //handle not loaded
            
            self.poll = nil
            let activityIndicatorView = UIActivityIndicatorView.init()
            activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
            activityIndicatorView.tag = 2000
            activityIndicatorView.hidesWhenStopped = true
            activityIndicatorView.startAnimating()
            activityIndicatorView.activityIndicatorViewStyle = .Gray
            self.contentView.addSubview(activityIndicatorView)
            
            let centerX = NSLayoutConstraint.init(item: activityIndicatorView, attribute: .CenterX, relatedBy: .Equal, toItem: self.contentView, attribute: .CenterX, multiplier: 1.0, constant: 0)
             let centerY = NSLayoutConstraint.init(item: activityIndicatorView, attribute: .CenterY, relatedBy: .Equal, toItem: self.contentView, attribute: .CenterY, multiplier: 1.0, constant: 0)
            
            self.contentView.addConstraint(centerX)
            self.contentView.addConstraint(centerY)
        }
    }
    func configure(_ poll:Poll){
        self.poll = poll
      //  self.poll.alwaysShowResult = false
        self.createContainer()
        self.createOpinions()
    }
    
    func addImage(){
        
        let imageHeight = self.frame.height
        let imageWidth = imageHeight * 4.0/3.0
        
        self.containerView.addSubview(imageView)
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat( "H:|-(10)-[imageView]-(10)-|", options: [], metrics: nil, views: ["imageView":imageView])
        self.containerView.addConstraints(horizontalConstraints)
        let topConstraint = NSLayoutConstraint.init(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: self.containerView, attribute: .Top, multiplier: 1.0, constant: 8.0)
        self.containerView.addConstraint(topConstraint)
        
        let imageSize = self.calculateImageSize(UIScreen.mainScreen().bounds.size)
        
        let heightConstraint = NSLayoutConstraint.init(item: self.imageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: imageSize.height)
        heightConstraint.priority = 999
        self.imageView.addConstraint(heightConstraint)
        
//        imageView.setContentCompressionResistancePriority(250, for: .vertical)
//        imageView.setContentHuggingPriority(750, for: .vertical)
        
        
        imageView.loadHeroImageAspectFit(poll.heroImageS3Key!, targetSize: CGSize.init(width: imageWidth, height: imageHeight))
        
        self.imageView.contentMode = .ScaleToFill
        self.imageView.backgroundColor = UIColor.whiteColor()
    }
    
    
    func addQuestion(){
  
        
        self.containerView.addSubview(questionLbl)
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(10)-[question]-(10)-|", options: [], metrics: nil, views: ["question":questionLbl])
        self.containerView.addConstraints(horizontalConstraints)
        let topConstraint = NSLayoutConstraint.init(item: self.questionLbl, attribute: .Top, relatedBy: .Equal, toItem: self.imageView, attribute: .Bottom, multiplier: 1.0, constant: 12.0)
        self.containerView.addConstraint(topConstraint)
        questionLbl.text = self.poll.question
        questionLbl.setContentCompressionResistancePriority(998, forAxis: .Vertical)
    }
    
    func calculateImageSize(targetSize:CGSize) -> CGSize{
    
       
            let widthDimension1 = CGFloat(self.poll.heroImageMetadata?.width ?? 4)
            let heightDimension1 = CGFloat(self.poll.heroImageMetadata?.height ?? 3)
            let newSize = CGSize(width:targetSize.width, height:(targetSize.width * heightDimension1) / widthDimension1)
            
            return newSize
        
    }
    
    func addDescription(){
      //  self.poll.pollDescription = "hi"
        self.containerView.addSubview(pollDescription)
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat( "H:|-(10)-[description]-(10)-|", options: [], metrics: nil, views: ["description":pollDescription])
        self.containerView.addConstraints(horizontalConstraints)
        let topConstraint = NSLayoutConstraint.init(item: self.pollDescription, attribute: .Top, relatedBy: .Equal, toItem: questionLbl, attribute: .Bottom, multiplier: 1.0, constant: 12)
        let heightConstraint = NSLayoutConstraint.init(item: pollDescription, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0)
        heightConstraint.priority = 250
        
        pollDescription.addConstraint(heightConstraint)
        
        if self.poll.pollDescription == nil || self.poll.pollDescription == ""{
            heightConstraint.priority = 999
        }
        self.containerView.addConstraint(topConstraint)
        self.pollDescription.text = self.poll.pollDescription ?? ""
        self.pollDescription.layoutIfNeeded()
        
        
    }
    
    private func createOpinions(){
        
        opinionButtons.removeAll()
       addImage()
       addQuestion()
       addDescription()
        
        for (index, value) in self.poll.opinions.enumerate(){
            
            let opinionButton = ResizableButton.init(type: .Custom)
                    opinionButton.translatesAutoresizingMaskIntoConstraints = false
            
           
            
            opinionButton.tag = index
            opinionButton.titleLabel?.numberOfLines = 5
            opinionButton.titleLabel?.lineBreakMode = .ByWordWrapping
            opinionButton.contentHorizontalAlignment = .Left
            opinionButton.titleEdgeInsets = UIEdgeInsetsMake(10, 40, 10, 50)
            opinionButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            opinionButton.backgroundColor = UIColor.init(hexString: "#FFf9f9f9")
            
            
           
            opinionButton.addTarget(self, action: #selector(StoryPollCell.didSelectOpinion(_:)), forControlEvents: .TouchUpInside)
            
            
            self.containerView.addSubview(opinionButton)
            self.containerView.setNeedsLayout()
            self.containerView.layoutIfNeeded()
            let horizontalConstraintsd = NSLayoutConstraint.constraintsWithVisualFormat( "H:|-(12)-[opinion]-(12)-|", options: [], metrics: nil, views: ["opinion":opinionButton])
            
//            let widthConstraint = NSLayoutConstraint.init(item: opinionButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.size.width - 24)
//            
//            opinionButton.addConstraint(widthConstraint)
            let heightConstraint = NSLayoutConstraint.init(item: opinionButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 30)
            heightConstraint.priority = 990
            opinionButton.addConstraint(heightConstraint)
            self.containerView.addConstraints(horizontalConstraintsd)
            opinionButton.setTitle(value.title, forState: UIControlState())
           // opinionButton.setNeedsLayout()
            opinionButton.layoutIfNeeded()
            let insets = opinionButton.titleEdgeInsets.top + opinionButton.titleEdgeInsets.bottom
            var constant = opinionButton.titleLabel?.frame.size.height ?? 0
            constant += insets
            heightConstraint.constant = constant
            opinionButton.setNeedsLayout()
            opinionButton.layoutIfNeeded()
            
            switch index {
                case 0:
                    let constraint = NSLayoutConstraint.init(item: opinionButton, attribute: .Top, relatedBy: .Equal, toItem: self.pollDescription, attribute: .Bottom, multiplier: 1, constant: 12)
                    self.containerView.addConstraint(constraint)
                break
                
                case self.poll.opinions.count - 1:
                    
               
                    
//                     let constraintBottom = NSLayoutConstraint.init(item: opinionButton, attribute: .Bottom, relatedBy: .equal, toItem: self.containerView, attribute: .Bottom, multiplier: 1, constant: -8)
//                     constraintBottom.priority = 1000
                      //    self.containerView.addConstraint(constraintBottom)
                        voteButton.removeFromSuperview()
                        self.containerView.addSubview(voteButton)
                    
                    
                    let constraintBottom = NSLayoutConstraint.init(item: voteButton, attribute: .Top, relatedBy: .Equal, toItem: opinionButton, attribute: .Bottom, multiplier: 1.0, constant: 12)
                    self.containerView.addConstraint(constraintBottom)
                     let prevButton = self.opinionButtons[index - 1]
                     let constraintTop = NSLayoutConstraint.init(item: opinionButton, attribute: .Top, relatedBy: .Equal, toItem: prevButton, attribute: .Bottom, multiplier: 1, constant: 8)
                     self.containerView.addConstraint(constraintTop)
                
                break
                
                default:
                    let prevButton = self.opinionButtons[index - 1]
                    let constraint = NSLayoutConstraint.init(item: opinionButton, attribute: .Top, relatedBy: .Equal, toItem: prevButton, attribute: .Bottom, multiplier: 1, constant: 8)
                    self.containerView.addConstraint(constraint)
                break
            }
            
            self.containerView.setNeedsUpdateConstraints()
            self.containerView.updateConstraintsIfNeeded()
            self.containerView.setNeedsLayout()
            self.containerView.layoutIfNeeded()
            
            if poll.votedOn != nil || poll.alwaysShowResult{
                self.addGradiant(opinionButton, percentage: value.percentVotes)
                self.addPercentage(opinionButton, percentage: value.percentVotes)
            }
            self.addRadioButton(opinionButton)
           
            self.opinionButtons.append(opinionButton)
            opinionButton.radioButton.layoutIfNeeded()
            opinionButton.bringSubviewToFront(opinionButton.radioButton.superview!)
            opinionButton.setNeedsLayout()
            opinionButton.layoutIfNeeded()
            opinionButton.radioButton.layer.borderColor = UIColor.init(hexColor: "#59c2ef").CGColor
            opinionButton.radioButton.layer.borderWidth = 1.5
            opinionButton.bringSubviewToFront(opinionButton.titleLabel!)
    //        opinionButton.layoutSubviews()
            
            if let votedOnn = self.poll.votedOn{
                if votedOnn == value.id{
                       opinionButton.isVotedOn = true
                    opinionButton.makeSelected()
                    opinionButton.userInteractionEnabled = false
                }
            }
  
        }
        self.addVoteButton()
        self.addShareView()
 
        
    }
    
    func addGradiant(button:UIButton, percentage:Int){
     if let gradientButton =  button as? ResizableButton{
    
        let viewd = UIView.init()
        viewd.translatesAutoresizingMaskIntoConstraints = false
        viewd.userInteractionEnabled = false
        gradientButton.addSubview(viewd)
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat( "H:|-(0)-[view]", options: [], metrics: nil, views: ["view":viewd])
        viewd.widthAnchor.constraintEqualToConstant(getWidthForProgress(gradientButton, percentage: percentage)).active = true
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat( "V:|-(0)-[view]-(0)-|", options: [], metrics: nil, views: ["view":viewd])
        gradientButton.addConstraints(horizontalConstraints)
        gradientButton.addConstraints(verticalConstraints)
      //  viewd.backgroundColor = UIColor.init(red: 234.0/255.0, green: 242.0/155.0, blue: 249/255.0, alpha: 1.0)
        viewd.backgroundColor = UIColor.init(hexString: "#00EAF2F9")
        
        gradientButton.percentageView = viewd
     }
        
 }
    
    func addShareView(){
        
        self.shareContainer.removeFromSuperview()
        
        self.containerView.addSubview(shareContainer)
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat( "H:|-(0)-[shareContainer]-(0)-|", options: [], metrics: nil, views: ["shareContainer":shareContainer])
        self.containerView.addConstraints(horizontalConstraints)
        
        let bottomConstraint = NSLayoutConstraint.init(item: shareContainer, attribute: .Bottom, relatedBy: .Equal, toItem: self.containerView, attribute: .Bottom, multiplier: 1.0, constant: 0)
        self.containerView.addConstraint(bottomConstraint)
        
        let topConstraint = NSLayoutConstraint.init(item: shareContainer, attribute: .Top, relatedBy: .Equal, toItem: voteButton, attribute: .Bottom, multiplier: 1.0, constant: 12)
        topConstraint.priority = 990
        self.containerView.addConstraint(topConstraint)
        
        self.addShareSubviews()
    }
    
    func addShareSubviews(){
  
        shareButton.removeFromSuperview()
        self.shareContainer.addSubview(shareButton)
        
        shareButton.setTitle("SHARE", forState: .Normal)
        
       
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat( "V:|-(20)-[shareButton]", options: [], metrics: nil, views: ["shareButton":shareButton])
        self.shareContainer.addConstraints(verticalConstraints)
        
        let heightConstraint = NSLayoutConstraint.init(item: shareButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 35)
        shareButton.addConstraint(heightConstraint)
        
        let horizontalConstraint = NSLayoutConstraint.init(item: shareButton, attribute: .Leading, relatedBy: .Equal, toItem: shareContainer, attribute: .Leading, multiplier: 1.0, constant: 15)
        horizontalConstraint.priority = 990
        shareContainer.addConstraint(horizontalConstraint)
        
        let widthConstraint = NSLayoutConstraint.init(item: shareButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 134)
        widthConstraint.priority = 900
        shareButton.addConstraint(widthConstraint)
        
        let centerYConstraint = NSLayoutConstraint.init(item: shareButton, attribute: .CenterY, relatedBy: .Equal, toItem: shareContainer, attribute: .CenterY, multiplier: 1, constant: 0)
        self.shareContainer.addConstraint(centerYConstraint)
        
        self.shareContainer.layoutIfNeeded()
//        let bottomConstraint = NSLayoutConstraint.init(item: shareButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.shareContainer, attribute: .Bottom, multiplier: <#T##CGFloat#>, constant: <#T##CGFloat#>)
        
        let poweredByText = UIButton.init(type: .Custom)
        poweredByText.titleLabel?.numberOfLines = 0
        poweredByText.titleLabel?.adjustsFontSizeToFitWidth = true
        poweredByText.titleLabel?.lineBreakMode = .ByClipping
        poweredByText.tag = Constants.poweredByText_TAG.rawValue
        poweredByText.translatesAutoresizingMaskIntoConstraints = false
        
        if let olderView = shareContainer.viewWithTag(Constants.poweredByText_TAG.rawValue){
            olderView.removeFromSuperview()
        }
        
        self.shareContainer.addSubview(poweredByText)
        poweredByText.setTitle("Powered by polltype", forState: .Normal)
        poweredByText.setTitleColor(UIColor.blackColor(), forState: .Normal)
        let poweredCenterY = NSLayoutConstraint.init(item: poweredByText, attribute: .CenterY, relatedBy: .Equal, toItem: shareContainer, attribute: .CenterY, multiplier: 1.0, constant: 0)
        
        self.shareContainer.addConstraint(poweredCenterY)
        
        let poweredTrailingConstraint = NSLayoutConstraint.init(item: poweredByText, attribute: .Trailing, relatedBy: .Equal, toItem: shareContainer, attribute: .Trailing, multiplier: 1.0, constant: -8)
        self.shareContainer.addConstraint(poweredTrailingConstraint)
        
        let horizontalSpacingConstraint = NSLayoutConstraint.init(item: shareButton, attribute: .Right, relatedBy: .Equal, toItem: poweredByText, attribute: .Left, multiplier: 1.0, constant: -10)
        self.shareContainer.addConstraint(horizontalSpacingConstraint)
        
        let powredByHeightConstraint = NSLayoutConstraint.init(item: poweredByText, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 30)
        poweredByText.addConstraint(powredByHeightConstraint)
        
    }
    
    func getWidthForProgress(button:ResizableButton,percentage:Int) -> CGFloat{
        if percentage == 0{
            return 0
        }
        
       // return button.frame.width
        
        let widthForOneVote = CGFloat(button.frame.width/100.0)
        return widthForOneVote * CGFloat(percentage)
        
    }
    
    func didSelectOpinion(_ sender:ResizableButton){
        
    /*    self.opinionButtons = opinionButtons.map { (opinion) -> ResizableButton in
            
            let opinionBt = opinion as! ResizableButton
            if opinionBt.voteButton != nil{
                opinionBt.voteButton.isHidden = true
            }
            return opinionBt
        }
        
        self.addVoteButton(sender)
 */
        
        self.opinionButtons = opinionButtons.map({ (button) -> UIButton in
            
            if let resizableButton = button as? ResizableButton{
                resizableButton.makeUnselected()
                return resizableButton
            }
            return button
        })
        
        sender.makeSelected()
        
        
    }
    
    func didClickOnVote(){
        
     let filteredButtons = self.opinionButtons.filter { (selectedButton) -> Bool in
            if let resizableButton = selectedButton as? ResizableButton{
                
                return resizableButton.isSelectedOpinion && !resizableButton.isVotedOn
            }
            return false
        }
    
        if let selectedOpinionButton = filteredButtons.first{
            self.pollDelegate?.didClickOnVote(self.poll, opinionIndex: selectedOpinionButton.tag, cell: self)
        }
    }
 
    
    
    private func addRadioButton(opinionButton:ResizableButton){
        let radioContainerView = UIView.init()
        radioContainerView.translatesAutoresizingMaskIntoConstraints = false
        radioContainerView.backgroundColor = UIColor.clearColor()
        radioContainerView.userInteractionEnabled = false
        opinionButton.addSubview(radioContainerView)
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat( "V:|-(0)-[radioContainerView]-(0)-|", options: [], metrics: nil, views: ["radioContainerView":radioContainerView])
        opinionButton.addConstraints(verticalConstraints)
        
        let leadingConstraint = NSLayoutConstraint.init(item: radioContainerView, attribute: .Leading, relatedBy: .Equal, toItem: opinionButton, attribute: .Leading, multiplier: 1.0, constant: 0)
        opinionButton.addConstraint(leadingConstraint)
        
        let widthConstraint = NSLayoutConstraint.init(item: radioContainerView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: opinionButton.titleEdgeInsets.left)
        radioContainerView.addConstraint(widthConstraint)
        
        let radioButton = UIButton.init()
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        radioContainerView.addSubview(radioButton)
        let centerXConstraint = NSLayoutConstraint.init(item: radioButton, attribute: .CenterX, relatedBy: .Equal, toItem: radioContainerView, attribute: .CenterX, multiplier: 1.0, constant: 0)
        let centerYConstraint = NSLayoutConstraint.init(item: radioButton, attribute: .CenterY, relatedBy: .Equal, toItem: radioContainerView, attribute: .CenterY, multiplier: 1.0, constant: 0)
        let widthConstraintRadio = NSLayoutConstraint.init(item: radioButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 10)
        let heightCOnstraintRadio = NSLayoutConstraint.init(item: radioButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 10)
        radioContainerView.addConstraint(centerXConstraint)
        radioContainerView.addConstraint(centerYConstraint)
        radioButton.addConstraint(widthConstraintRadio)
        radioButton.addConstraint(heightCOnstraintRadio)
        opinionButton.radioButton = radioButton
    }
    
    
    func addVoteButton(){
        
        if self.voteButton.superview == nil{
            self.containerView.addSubview(voteButton)
        }
        
        
        self.voteButton.addTarget(self, action: #selector(StoryPollCell.didClickOnVote), forControlEvents: .TouchUpInside)
        
        let trailingConstraint = NSLayoutConstraint.init(item: voteButton, attribute: .Trailing, relatedBy: .Equal, toItem: self.containerView, attribute: .Trailing, multiplier: 1.0, constant: -16.0)
        self.containerView.addConstraint(trailingConstraint)
        
        let widthConstraint = NSLayoutConstraint.init(item: voteButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 104)
        self.voteButton.addConstraint(widthConstraint)
        
         let heightConstraint = NSLayoutConstraint.init(item: voteButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 28)
        heightConstraint.priority = 990
        self.voteButton.addConstraint(heightConstraint)
        
//        let bottomConstraint = NSLayoutConstraint.init(item: self.voteButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.containerView, attribute: .Bottom, multiplier: 1.0, constant: -12)
//        self.containerView.addConstraint(bottomConstraint)
//        
  
    }
    
    private func addPercentage(_ opinionButton:ResizableButton, percentage:Int){
       /* let voteButton = UIButton.init(type: .custom)
        opinionButton.voteButton = voteButton
        voteButton.backgroundColor = UIColor.blue
        voteButton.translatesAutoresizingMaskIntoConstraints = false
        opinionButton.addSubview(voteButton)
        let voteVConstraints = NSLayoutConstraint.constraintsWithVisualFormat( "V:|-(0)-[voteButton]-(0)-|", options: [], metrics: nil, views: ["voteButton":voteButton])
        opinionButton.addConstraints(voteVConstraints)
        
        let trailingConstraint = NSLayoutConstraint.init(item: voteButton, attribute: .Trailing, relatedBy: .equal, toItem: opinionButton, attribute: .Trailing, multiplier: 1.0, constant: 0)
        let widthConstraint = NSLayoutConstraint.init(item: voteButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: opinionButton.titleEdgeInsets.right)
        
        opinionButton.addConstraints(voteVConstraints + [trailingConstraint])
        voteButton.addConstraint(widthConstraint)
 */
        let percentageView = UIView.init()
        percentageView.backgroundColor = UIColor.clearColor()
        percentageView.translatesAutoresizingMaskIntoConstraints = false
        opinionButton.addSubview(percentageView)
        let verticialConstraints = NSLayoutConstraint.constraintsWithVisualFormat( "V:|-(0)-[percentageView]-(0)-|", options: [], metrics: nil, views: ["percentageView":percentageView])
        opinionButton.addConstraints(verticialConstraints)
        
        let trailingConstraint = NSLayoutConstraint.init(item: percentageView, attribute: .Trailing, relatedBy: .Equal, toItem: opinionButton, attribute: .Trailing, multiplier: 1.0, constant: 0)
        opinionButton.addConstraint(trailingConstraint)
        let widthConstraint = NSLayoutConstraint.init(item: percentageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: opinionButton.titleEdgeInsets.right)
        percentageView.addConstraint(widthConstraint)
        
        let percentageLabel = UILabel.init()
        
        percentageLabel.textColor = UIColor.blackColor()
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        percentageView.addSubview(percentageLabel)
        
        let centerXConstraint = NSLayoutConstraint.init(item: percentageLabel, attribute: .CenterX, relatedBy: .Equal, toItem: percentageView, attribute: .CenterX, multiplier: 1.0, constant: 0)
        percentageView.addConstraint(centerXConstraint)
        
        let centerYConstraint = NSLayoutConstraint.init(item: percentageLabel, attribute: .CenterY, relatedBy: .Equal, toItem: percentageView, attribute: .CenterY, multiplier: 1.0, constant: 0)
        percentageView.addConstraint(centerYConstraint)
        percentageLabel.text = "\(percentage)%"
        opinionButton.percentageLabel = percentageLabel
    }
    
    
    
    
    
    private func createContainer(){
        
        if let container = self.contentView.viewWithTag(Constants.container_TAG.rawValue){
            
            container.removeFromSuperview()
        }
        
        containerView = UIView.init()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.tag = Constants.container_TAG.rawValue
        self.containerView.backgroundColor = UIColor.whiteColor()
        self.contentView.addSubview(containerView)
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat( "H:|-(10)-[containerView]-(10)-|", options: [], metrics: nil, views: ["containerView":containerView])
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat( "V:|-(10)-[containerView]-(10)-|", options: [], metrics: nil, views: ["containerView":containerView])
        
        self.contentView.addConstraints(verticalConstraints)
        self.contentView.addConstraints(horizontalConstraints)
       
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if voteButton.superview != nil{
            voteButton.layer.cornerRadius = voteButton.frame.size.height/2
        }
        
        if shareButton.superview != nil{
            shareButton.layer.cornerRadius = shareButton.frame.size.height/2
        }
        
//        for button in self.opinionButtons{
//            button.layer.cornerRadius = 15.0
//            if let resizableButton = button as? ResizableButton{
//                if resizableButton.percentageView != nil{
//                    resizableButton.percentageView.layer.cornerRadius = 15.0
//                }
//            }
//        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.poll = nil
    }
    
    func preferredLayoutSizeFittingSize(_ targetSize:CGSize) -> CGSize{
        
        if self.poll == nil{
            return CGSize.init(width: targetSize.width, height: 50)
        }
        
        let widthConstraint = NSLayoutConstraint.init(item: self.contentView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: targetSize.width)
        widthConstraint.priority = 980
        self.contentView.addConstraint(widthConstraint)
        self.contentView.setNeedsUpdateConstraints()
        self.contentView.updateConstraintsIfNeeded()
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
        var changeSize = UILayoutFittingCompressedSize
        changeSize.width = targetSize.width
        let size = self.contentView.systemLayoutSizeFittingSize(changeSize, withHorizontalFittingPriority: 1000, verticalFittingPriority: 250)
        self.contentView.removeConstraint(widthConstraint)
       // let imageSize = self.calculateImageSize(targetSize: CGSize.init(width: targetSize.width - 40, height: targetSize.height))
        return CGSize.init(width: size.width, height: size.height + 0)
    }
}
