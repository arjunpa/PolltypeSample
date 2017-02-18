//
//  ViewController.swift
//  PollSample
//
//  Created by Arjun P A on 24/12/16.
//  Copyright © 2016 Arjun P A. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var models:Array<StoryElement> = []
    var sizingCell:Dictionary<String,UICollectionViewCell> = [:]
    
    var pollIndexPathMapping:[Int:NSIndexPath] = [:]
    typealias LOGIN_COMPLETION = () -> ()
    var loginCompletion:LOGIN_COMPLETION?
    
    var _api:APIManager?
    
    var api:APIManager{
        get{
            if _api == nil{
                _api = APIManager.init()
            }
            return _api!
        }
        set{
            _api = newValue
        }
    }
    
    /*var loginWebView:UIWebView = {
        let webView = UIWebView.init()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
 */
    var _loginWebView:UIWebView?
    
    var loginWebView:UIWebView?{
        get{
            if _loginWebView == nil{
                _loginWebView = UIWebView.init()
                _loginWebView?.translatesAutoresizingMaskIntoConstraints = false
            }
            return _loginWebView!
        }
        set{
            _loginWebView = nil
        }
    }
    @IBOutlet weak var collection_view:UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collection_view.delegate = self
        self.collection_view.dataSource = self
        self.doRegistrations()
     //   self.createModel()
      //  self.getPoll()
        self.prepateModel()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepateModel(){
        let pollIDs:[Int] = [560, 427, 454]
        for i in 0..<3{
            
            let elem = StoryElement.init()
            elem.pollTypeID = pollIDs[i]
            self.models.append(elem)
        }
        
    }
    
    func getPoll(pollID:Int){
        
        
   //     api.fetchPoll { (poll, error) in
        api.fetchPoll(pollID) {[weak self] (poll, error) in
            
            if let _ = error{
              
            }
            else{
              //  self.models.append(poll!)
                
                guard let weakSelf = self else {return}
                
               weakSelf.models =  weakSelf.models.map({ (storyElement) -> StoryElement in
                    
                    if storyElement.pollTypeID == poll?.id{
                        storyElement.poll = poll
                    }
                    return storyElement
                })
                
             /*   DispatchQueue.main.async(execute: {
                    if let indexPath = weakSelf.pollIndexPathMapping[poll!.id]{
                    
                        if weakSelf.collection_view.cellIsVisible(forIndexPath: indexPath){
                            self?.collection_view.reloadItems(at: [indexPath])
                        }
                    }
                    
                })
 */
                dispatch_async(dispatch_get_main_queue(), { 
                    if let indexPath = weakSelf.pollIndexPathMapping[poll!.id]{
                        
                        print(poll!.id)
                        print(indexPath)
                        if weakSelf.collection_view.cellIsVisible(indexPath){
                            self?.collection_view.layoutIfNeeded()
//                            dispatch_async(dispatch_get_main_queue(), {
//                                self?.collection_view.reloadItemsAtIndexPaths([indexPath])
//                            })
                            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
                            dispatch_after(delayTime, dispatch_get_main_queue(), { 
                                 self?.collection_view.reloadItemsAtIndexPaths([indexPath])
                            })
                            
                        }
                    }
                })
                
//                DispatchQueue.main.async(execute: { 
//          
//                    self.collection_view.reloadData()
//                })
                
            }
        }
    }

    func createModel(){
        
   /*     var opinions:[Opinion] = []
        var strings = ["hhgfhffhhhfgfhghfgfhghggh", "ghghchghgghghhghgghcgchghcvhgggvggggghfggfhhfghfghfghffghghfgfffgghghffgffghghfgfghfgfgfgfghfgfghghgfhghfgfh", "bhhhbbhhbhhbhbhbbhh", "duiyiuiuughhhgjhjhjhhjhghhgjhghghhhj", "mlmmmllljnvjnnjjnjnjnjfdvnjjnvfjnfjnvfdjnnvjfnjvdjvnjnvjnjnvfjnvfvnfndfnjfnjrfnjrnrnnrfnrfjrnjfjrnjfrjfrnjrfnjfjnrnjrjnrfnjfrnmnmnmnmnmnmngjjhhhgghhgm,nmnnnnnnhuuuuhuhuhuhuuhuutfgffgfggfffgffttuhuuhhuuhuhuhuhhuhuhuhhuhuhuhuhu"]
        for i in 0..<5{
            let opinion = Opinion.init()
            opinion.title = strings[i]
            opinions.append(opinion)
        }
        let model = Poll.init()
        model.opinions = opinions
        model.question = "What is some of the greatest questions ever answered on the eve of christmas?"
        models.append(model)
 */
    }
    
    func doRegistrations(){
        let nib1 = UINib.init(nibName: "StoryPollCell", bundle: nil)
        self.sizingCell["StoryPollCell"] = nib1.instantiateWithOwner(self, options: nil)[0] as! StoryPollCell
        self.collection_view.registerNib(nib1, forCellWithReuseIdentifier: "StoryPollCell")
       
    }

}
extension ViewController:UICollectionViewDelegateFlowLayout{
    internal func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let sizingCell = self.sizingCell["StoryPollCell"] as! StoryPollCell
      //  sizingCell.configure(models[indexPath.item])
        sizingCell.configure(models[indexPath.item])
        let targetSize = CGSize.init(width: UIScreen.mainScreen().bounds.size.width, height: 0.5 * UIScreen.mainScreen().bounds.size.width)
        let size =  sizingCell.preferredLayoutSizeFittingSize(targetSize)
        
     //  return CGSize.init(width: targetSize.width, height: 700)
        return size
    }
}

extension ViewController:UICollectionViewDataSource{
    
    internal func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    internal func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return models.count
    }
    
    internal func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //let cell = self.collection_view.dequeueReusableCell(withReuseIdentifier: "StoryPollCell", for: indexPath) as! StoryPollCell
        let cell = self.collection_view.dequeueReusableCellWithReuseIdentifier("StoryPollCell", forIndexPath: indexPath) as! StoryPollCell
        cell.pollDelegate = self
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
       // cell.configure(models[indexPath.item])
        cell.configure(models[indexPath.item])
        pollIndexPathMapping[models[indexPath.item].pollTypeID] = indexPath
        
        self.getPoll(models[indexPath.item].pollTypeID)
        
        return cell
    }
}
extension ViewController:StoryPollCellDelegate{
    func didClickOnVote(poll: Poll, opinionIndex: Int, cell: StoryPollCell) {
        print("did enter here")
        
        api.voteIntend(poll.id, opinionID: poll.opinions[opinionIndex].id)
        
        if poll.hasAccount{
            
            self.vote(poll, opinionIndex: opinionIndex, cell: cell)
        }
        else{
         /*  DispatchQueue.main.async(execute: {
              self.showWebView(cell: cell)
           })
    */
            dispatch_async(dispatch_get_main_queue(), { 
                self.showWebView(cell)
            })
          
            self.loginCompletion = {
                self.closeWebview(self.loginWebView!)
                self.vote(poll, opinionIndex: opinionIndex, cell: cell)
            }
        }
    }
    
    func vote(poll:Poll, opinionIndex:Int, cell: StoryPollCell){
        
        api.vote(poll, opinionIndex: opinionIndex) { (polld, error) in
            
        //    if let index = self.models.index(where: {$0.pollID == polld?.id ?? -1}){
            
            if let _ = error{
                return
            }
            
            let someIndex = self.models.indexOf({ (storyElement) -> Bool in
                return storyElement.pollTypeID == polld?.id ?? 0
            })
            if let index = someIndex{
                self.models[index].poll = polld!
                
                self.models = self.models.map({ (storyELement) -> StoryElement in
                    
                    storyELement.poll?.hasAccount = polld?.hasAccount ?? false
                    return storyELement
                })
                
                for value in Array(self.pollIndexPathMapping.values){
                    
                    if self.collection_view.cellIsVisible(value){
                        if let cell = self.collection_view.cellForItemAtIndexPath(value) as? StoryPollCell{
                            cell.poll.hasAccount = polld?.hasAccount ?? false
                        }
                    }
                }
                
                if let indexpath = self.pollIndexPathMapping[poll.id]{
                   
              /*    DispatchQueue.main.async(execute: {
                    if let _ = self.collection_view.cellForItem(at: indexpath){
                        self.collection_view.reloadItems(at: [indexpath])
                    }
                  })
 */
                    dispatch_async(dispatch_get_main_queue(), { 
                        if let _ = self.collection_view.cellForItemAtIndexPath(indexpath){
                            self.collection_view.reloadItemsAtIndexPaths([indexpath])
                        }
                    })
                   
                }
            }
        }
    }

    
}
extension ViewController:UIWebViewDelegate{
    public func showWebView(cell: StoryPollCell?){
        loginWebView!.removeFromSuperview()
        self.view.addSubview(self.loginWebView!)
        self.view.bringSubviewToFront(self.loginWebView!)
        self.loginWebView?.delegate = self
        
        
        loginWebView?.topAnchor.constraintEqualToAnchor(self.view.topAnchor).active = true
        loginWebView?.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
        loginWebView?.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor).active = true
        loginWebView?.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor, constant: 0).active = true
        
        let closeButton = UIButton.init(type: .Custom)
        closeButton.tag = 20
        closeButton.backgroundColor = UIColor.darkGrayColor()
        closeButton.setTitle("X", forState: .Normal)
        closeButton.setTitleColor(UIColor.lightTextColor(), forState: .Normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(ViewController.closeWebview(_:)), forControlEvents: .TouchUpInside)
        self.loginWebView?.addSubview(closeButton)
        self.loginWebView?.bringSubviewToFront(closeButton)
        closeButton.widthAnchor.constraintEqualToConstant(40).active = true
        closeButton.heightAnchor.constraintEqualToConstant(40).active = true
        
        closeButton.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor, constant: -20).active = true
        closeButton.topAnchor.constraintEqualToAnchor((self.loginWebView?.topAnchor)!, constant: 20).active = true
        
        self.loginWebView?.loadRequest(NSURLRequest.init(URL: NSURL.init(string: APIManager.BASEURL + "login")!))
    }
    
    func closeWebview(sender:UIWebView){
        
        self.loginWebView?.removeFromSuperview()
        self.loginWebView?.delegate = nil
        self.loginWebView = nil
    }
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        
        return true
    }
    
    public func webViewDidFinishLoad(webView: UIWebView) {
       // let url = String(describing: webView.request!.url!).components(separatedBy: "/")
        
        guard let url = webView.request?.URL?.absoluteString.componentsSeparatedByString("/") else{ return }
    
        url.forEach({ (data) in
            print(data)
            if (data == "me#_=_") || (data ==  "me"){
            
                    print("LoggedIn")
                
                if let someCompletion = loginCompletion{
                    someCompletion()
                }
            }
            
        })
    }
    
    @objc func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
    }
}

