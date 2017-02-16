//
//  ViewController.swift
//  PollSample
//
//  Created by Arjun P A on 24/12/16.
//  Copyright © 2016 Arjun P A. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var models:Array<Poll> = []
    var sizingCell:Dictionary<String,UICollectionViewCell> = [:]
    var api:APIManager!
    var pollIndexPathMapping:[Int:IndexPath] = [:]
    typealias LOGIN_COMPLETION = () -> ()
    var loginCompletion:LOGIN_COMPLETION?
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
     
        self.doRegistrations()
     //   self.createModel()
        self.getPoll()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepateModel(){
        
    }
    
    func getPoll(){
         api = APIManager.init()
        
        api.fetchPoll { (poll, error) in
            if let _ = error{
              
            }
            else{
                self.models.append(poll!)
                DispatchQueue.main.async(execute: { 
                    self.collection_view.delegate = self
                    self.collection_view.dataSource = self
                    self.collection_view.reloadData()
                })
                
            }
        }
    }

    func createModel(){
        
        var opinions:[Opinion] = []
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
    }
    
    func doRegistrations(){
        let nib1 = UINib.init(nibName: "StoryPollCell", bundle: nil)
        self.sizingCell["StoryPollCell"] = nib1.instantiate(withOwner: self, options: nil)[0] as! StoryPollCell
        self.collection_view.register(nib1, forCellWithReuseIdentifier: "StoryPollCell")
       
    }

}
extension ViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sizingCell = self.sizingCell["StoryPollCell"] as! StoryPollCell
        sizingCell.configure(models[indexPath.item])
        
        let targetSize = CGSize.init(width: UIScreen.main.bounds.size.width, height: 0.5 * UIScreen.main.bounds.size.width)
        let size =  sizingCell.preferredLayoutSizeFittingSize(targetSize)
        
     //  return CGSize.init(width: targetSize.width, height: 700)
        return size
    }
}

extension ViewController:UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collection_view.dequeueReusableCell(withReuseIdentifier: "StoryPollCell", for: indexPath) as! StoryPollCell
        cell.pollDelegate = self
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        cell.configure(models[indexPath.item])
        pollIndexPathMapping[models[indexPath.item].id] = indexPath
        
        return cell
    }
}
extension ViewController:StoryPollCellDelegate{
    func didClickOnVote(poll: Poll, opinionIndex: Int, cell: StoryPollCell) {
        print("did enter here")
        
        api.voteIntend(pollID: poll.id, opinionID: poll.opinions[opinionIndex].id)
        
        if poll.hasAccount{
            
            self.vote(poll: poll, opinionIndex: opinionIndex, cell: cell)
        }
        else{
           DispatchQueue.main.async(execute: {
              self.showWebView(cell: cell)
           })
          
            self.loginCompletion = {
                self.closeWebview(sender: self.loginWebView!)
                self.vote(poll: poll, opinionIndex: opinionIndex, cell: cell)
            }
        }
    }
    
    func vote(poll:Poll, opinionIndex:Int, cell: StoryPollCell){
        
        api.vote(poll: poll, opinionIndex: opinionIndex) { (polld, error) in
            
            if let index = self.models.index(where: {$0.id == polld?.id}){
                self.models[index] = polld!
                
                if let indexpath = self.pollIndexPathMapping[poll.id]{
                   
                  DispatchQueue.main.async(execute: {
                    if let _ = self.collection_view.cellForItem(at: indexpath){
                        self.collection_view.reloadItems(at: [indexpath])
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
        self.view.bringSubview(toFront: self.loginWebView!)
        self.loginWebView?.delegate = self
        
        
        loginWebView?.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        loginWebView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        loginWebView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        loginWebView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        
        let closeButton = UIButton.init(type: .custom)
        closeButton.tag = 20
        closeButton.backgroundColor = UIColor.darkGray
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(UIColor.lightText, for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(ViewController.closeWebview(sender:)), for: .touchUpInside)
        self.loginWebView?.addSubview(closeButton)
        self.loginWebView?.bringSubview(toFront: closeButton)
        closeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        closeButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        closeButton.topAnchor.constraint(equalTo: (self.loginWebView?.topAnchor)!, constant: 20).isActive = true
        
        self.loginWebView?.loadRequest(URLRequest.init(url: URL.init(string: APIManager.BASEURL + "login")!))
    }
    
    func closeWebview(sender:UIWebView){
        
        self.loginWebView?.removeFromSuperview()
        self.loginWebView?.delegate = nil
        self.loginWebView = nil
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let url = String(describing: webView.request!.url!).components(separatedBy: "/")
        
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
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
    }
}

