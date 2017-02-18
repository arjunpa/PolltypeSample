//
//  APIManager.swift
//  PollSample
//
//  Created by Arjun P A on 13/02/17.
//  Copyright © 2017 Arjun P A. All rights reserved.
//

import Foundation


class APIManager: NSObject {
    
     static let BASEURL = "https://polltype-api.staging.quintype.io/"
     static let POLLTYPEURL = "https://polltype-api.staging.quintype.io/api/polls/560"
    
    
    private var pendingPolls:Array<Int> = []
    
    private var fetchedPolls:Array<Int> = []
    
    internal override init() {
        
    }
    
    
    
    internal func isFetchingPoll(forID:Int) -> Bool{
        if pendingPolls.contains(forID){
            return true
        }
        
        return false
    }
    
    internal func isFetchedPoll(forID:Int) -> Bool{
        if fetchedPolls.contains(forID){
            return true
        }
        
        return false
    }
    
    
    
    internal func fetchPoll(pollID:Int, completion:(poll:Poll?, error:ErrorType?) -> Void){
        
        if isFetchingPoll(pollID) || isFetchedPoll(pollID){
            return
        }
        NSURLSession.sharedSession().dataTaskWithURL(NSURL.init(string: APIManager.BASEURL + "api/polls/" + "\(pollID)")!) { (data, response, error) in
            if let someError = error{
                if let containsIndex = self.pendingPolls.indexOf(pollID){
                    self.pendingPolls.removeAtIndex(containsIndex)
                }
                completion(poll: nil, error: someError)
            }
            else{
                
                do{
                    
                    let parsedObject = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                   // self.startParse(data: parsedObject, completion: completion)
                    self.startParse(parsedObject, completion: { (poll, error) in
                        
                        if let containsIndex = self.pendingPolls.indexOf(poll?.id ?? 0){
                            self.pendingPolls.removeAtIndex(containsIndex)
                        }
                        self.fetchedPolls.append(poll!.id)
                        completion(poll: poll,error: error)
                    })
                }
                catch{
                    if let containsIndex = self.pendingPolls.indexOf(pollID){
                        self.pendingPolls.removeAtIndex(containsIndex)
                    }
                    completion(poll: nil, error: error)
                }
            }
        }.resume()
        
        
    }
    
    internal func vote(poll:Poll, opinionIndex:Int, completion:(poll:Poll?, error:ErrorType?) -> Void){
        let urlString = APIManager.BASEURL + "api" + "/polls/" + "\(poll.id!)/votes"
        
        let mutableURLRequest = NSMutableURLRequest.init(URL: NSURL.init(string: urlString)!)
        
        mutableURLRequest.HTTPMethod = "POST"
        
        let parameters = ["vote":["opinion-id":poll.opinions[opinionIndex].id]]
        mutableURLRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
  //      mutableURLRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options:[])
        mutableURLRequest.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(parameters, options: [])
        
      //  URLSession.shared.dataTask(with: mutableURLRequest as URLRequest) { (data, response, error) in
        NSURLSession.sharedSession().dataTaskWithRequest(mutableURLRequest) { (data, response, error) in
            
        
            if let someError = error{
                completion(poll: nil, error: someError)
            }
            else{
                
                do {
                    if let unwrappedData = data {
                        
                        let jsonDictionaries = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options: .AllowFragments) as! [String: AnyObject]
                        
                        self.parsePollTypeResult(poll, dictionary: jsonDictionaries, completion: { (refactoredPoll) in
                            
                            completion(poll: refactoredPoll, error: nil)
                        })
                    }
                    
                } catch let jsonError {
                    
                    completion(poll: nil,error: jsonError)
                }
                
            }
        }.resume()
    }
    
    func parsePollTypeResult(poll:Poll,dictionary:[String: AnyObject], completion:(Poll) -> Void){
        
        if let meStructure =  dictionary["me"] as? [String:AnyObject]{
            
            if let hasAccount = meStructure["has-account"] as? NSNumber{
                poll.hasAccount = hasAccount.boolValue
            }
            
            if let qlitics = meStructure["has-qlitics"] as? NSNumber{
                poll.hasQlitics = qlitics.boolValue
            }
        }
        
        if let resultsStructure = dictionary["results"] as? [String:AnyObject]{
            if let opinions = resultsStructure["opinions"] as? [[String:AnyObject]]{
                
                var opinionArray:[Opinion] = []
                
                for opinion in opinions{
                    let opiniond = Opinion()
                    if let id = opinion["id"] as? NSNumber{
                        opiniond.id = id.integerValue
                    }
                    
                    if let text = opinion["text"] as? String{
                        opiniond.title = text
                    }
                    
                    if let percentVotes = opinion["percentage-votes"] as? NSNumber{
                        opiniond.percentVotes = percentVotes.integerValue
                    }
                    opinionArray.append(opiniond)
                }
                
                poll.opinions = opinionArray
               
                
            }
            if let votedOnDict = resultsStructure["voted-on"] as? [String:AnyObject]{
                if let votedOnID = votedOnDict["id"] as? NSNumber{
                    poll.votedOn = votedOnID.integerValue
                }
            }
             completion(poll)
            
        }
    }
    
    internal func voteIntend(pollID:Int,opinionID:Int,completion:((status:Int?, error:ErrorType?, jsonData:[String:AnyObject]?) -> Void)? = nil){
        let urlString = APIManager.BASEURL + "api" + "/polls/" + "\(pollID)/intentions"
        
        let url = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        
        url.HTTPMethod = "POST"
        let parameters = ["intention":["opinion-id":opinionID]]
        
            url.addValue("application/json", forHTTPHeaderField: "Content-Type")
            url.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(parameters, options:[])
            
        
        print(urlString)
   //     NSURLSession.sharedSession().dataTaskWith(with: url as URLRequest) { (data, response, error) in
        NSURLSession.sharedSession().dataTaskWithRequest(url) { (data, response, error) in
            
            
            if error != nil {
                if let someCompletion = completion{
                    someCompletion(status: (response as? NSHTTPURLResponse)?.statusCode, error: error, jsonData: nil)
                }
                return
            }
            
            do {
                if let unwrappedData = data {
                    
                    let jsonDictionaries = try NSJSONSerialization.JSONObjectWithData( unwrappedData, options: .AllowFragments) as? [String: AnyObject]
                    
                  /*  DispatchQueue.main.async(execute: {
                        
                        print(jsonDictionaries ?? "")
                        
                        if let someCompletion = completion{
                            someCompletion((response as? HTTPURLResponse)?.statusCode, nil, jsonDictionaries)
                        }
                    })
    */
                    dispatch_async(dispatch_get_main_queue(), { 
                        print(jsonDictionaries ?? "")
                        
                        if let someCompletion = completion{
                            someCompletion(status: (response as? NSHTTPURLResponse)?.statusCode, error: nil, jsonData: jsonDictionaries)
                        }
                    })
                }
                
            } catch let jsonError {
                if let someCompletion = completion{
                 //   someCompletion(status: (response as? NSHTTPURLResponse)?.statusCode, error: jsonError, jsonData: nil)
                    someCompletion(status:(response as? NSHTTPURLResponse)?.statusCode, error: jsonError, jsonData: nil)
                }
            }
            
            }.resume()
        
    }
    
 
    
    
    
    
    
    func startParse(data:Any,completion:(Poll?, ErrorType?) -> Void){
        
        if let dataJson = data as? [String:AnyObject]{
            
            let pollModel = Poll()
            if let me = (dataJson["me"] as? [String:AnyObject]){
                if let hasAccountNumber = me["has-account"] as? NSNumber{
                    pollModel.hasAccount = hasAccountNumber.boolValue
                }
                
                if let qlicticsNumber = me["has-qlitics"] as? NSNumber{
                    pollModel.hasQlitics = qlicticsNumber.boolValue
                }
            }
            
            if let poll = (dataJson["poll"] as? [String:AnyObject]){
                
                if let pollID = poll["id"] as? NSNumber{
                    pollModel.id = pollID.integerValue
                }
                
                if let topic = poll["topic"] as? String{
                    pollModel.question = topic
                }
                
                if let description = poll["description"] as? String{
                    pollModel.pollDescription  = description
                }
                
                if let votedOnDict = poll["voted-on"] as? [String:AnyObject]{
                    if let votedOnID = votedOnDict["id"] as? NSNumber{
                        pollModel.votedOn = votedOnID.integerValue
                    }
                }
                
                if let opinions = poll["opinions"] as? [[String:AnyObject]]{
                    
                    var opinionArray:[Opinion] = []
                    
                    for opinion in opinions{
                        let opiniond = Opinion()
                        if let id = opinion["id"] as? NSNumber{
                            opiniond.id = id.integerValue
                        }
                        
                        if let text = opinion["text"] as? String{
                            opiniond.title = text
                        }
                        
                        if let percentVotes = opinion["percentage-votes"] as? NSNumber{
                            opiniond.percentVotes = percentVotes.integerValue
                        }
                        opinionArray.append(opiniond)
                    }
                    
                    pollModel.opinions = opinionArray
                    
                }
                
                
                if let heroImage = poll["hero-image"] as? [String:AnyObject]{
                    
                    if let s3Key = heroImage["s3-key"] as? String{
                        pollModel.heroImageS3Key = s3Key
                        if let metadata = heroImage["metadata"] as? [String:Any]{
                            
                            let metadataImage:ImageMetdata = ImageMetdata.init()
                            
                            if let width = metadata["width"] as? NSNumber{
                                metadataImage.width = width.integerValue
                            }
                            
                            if let height = metadata["height"] as? NSNumber{
                                metadataImage.height = height.integerValue
                            }
                            
                            if let focusPoints = metadata["focus-point"] as? [NSNumber]{
                                var focusPointArray = [Int]()
                                
                                for point in focusPoints{
                                    focusPointArray.append(point.integerValue)
                                }
                                
                                metadataImage.focusPoints = focusPointArray
                            }
                            
                            pollModel.heroImageMetadata = metadataImage
                        }
                    }
                    
                }
                
                if let metadata = poll["metadata"] as? [String:AnyObject]{
                    if let options = metadata["options"] as? [String:AnyObject]{
                        
                        if let showResults = options["always-show-results"] as? NSNumber{
                            pollModel.alwaysShowResult = showResults.boolValue
                        }
                    }
                }
            }
            
            completion(pollModel, nil)
        }
        else{
            let error = NSError.init(domain: "Root Structure not defined", code: 24, userInfo: nil)
            completion(nil,error as ErrorType)
            
        }
    }
}
