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
    
    
    
    
    public override init() {
        
    }
    
    public func fetchPoll(completion:@escaping(_ poll:Poll?, Error?) -> Void){
        
        URLSession.shared.dataTask(with: URL.init(string: APIManager.POLLTYPEURL)!) { (data, response, error) in
            if let someError = error{
                completion(nil, someError)
            }
            else{
                
                do{
                    
                    let parsedObject = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    self.startParse(data: parsedObject, completion: completion)
                }
                catch{
                    completion(nil, error)
                }
            }
        }.resume()
        
        
    }
    
    public func vote(poll:Poll, opinionIndex:Int, completion:@escaping (_ poll:Poll?, _ error:Error?) -> Void){
        let urlString = APIManager.BASEURL + "api" + "/polls/" + "\(poll.id!)/votes"
        
        let mutableURLRequest = NSMutableURLRequest.init(url: URL.init(string: urlString)!)
        
        mutableURLRequest.httpMethod = "POST"
        
        let parameters = ["vote":["opinion-id":poll.opinions[opinionIndex].id]]
        mutableURLRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options:[])
        
        URLSession.shared.dataTask(with: mutableURLRequest as URLRequest) { (data, response, error) in
            if let someError = error{
                completion(nil, someError)
            }
            else{
                
                do {
                    if let unwrappedData = data {
                        
                        let jsonDictionaries = try JSONSerialization.jsonObject(with: unwrappedData, options: .allowFragments) as! [String: Any]
                        
                        self.parsePollTypeResult(poll: poll, dictionary: jsonDictionaries, completion: { (refactoredPoll) in
                            
                            completion(refactoredPoll, nil)
                        })
                    }
                    
                } catch let jsonError {
                    
                    completion(nil,jsonError)
                }
                
            }
        }.resume()
    }
    
    func parsePollTypeResult(poll:Poll,dictionary:[String: Any], completion:(Poll) -> Void){
        
        if let meStructure =  dictionary["me"] as? [String:Any]{
            
            if let hasAccount = meStructure["has-account"] as? NSNumber{
                poll.hasAccount = hasAccount.boolValue
            }
            
            if let qlitics = meStructure["has-qlitics"] as? NSNumber{
                poll.hasQlitics = qlitics.boolValue
            }
        }
        
        if let resultsStructure = dictionary["results"] as? [String:Any]{
            if let opinions = resultsStructure["opinions"] as? [[String:Any]]{
                
                var opinionArray:[Opinion] = []
                
                for opinion in opinions{
                    let opiniond = Opinion()
                    if let id = opinion["id"] as? NSNumber{
                        opiniond.id = id.intValue
                    }
                    
                    if let text = opinion["text"] as? String{
                        opiniond.title = text
                    }
                    
                    if let percentVotes = opinion["percentage-votes"] as? NSNumber{
                        opiniond.percentVotes = percentVotes.intValue
                    }
                    opinionArray.append(opiniond)
                }
                
                poll.opinions = opinionArray
               
                
            }
            if let votedOnDict = resultsStructure["voted-on"] as? [String:Any]{
                if let votedOnID = votedOnDict["id"] as? NSNumber{
                    poll.votedOn = votedOnID.intValue
                }
            }
             completion(poll)
            
        }
    }
    
    public func voteIntend(pollID:Int,opinionID:Int,completion:((_ status:Int?, _ error:Error?, _ jsonData:[String:Any]?) -> Void)? = nil){
        let urlString = APIManager.BASEURL + "api" + "/polls/" + "\(pollID)/intentions"
        
        let url = NSMutableURLRequest(url: URL(string: urlString)!)
        
        url.httpMethod = "POST"
        let parameters = ["intention":["opinion-id":opinionID]]
        
            url.addValue("application/json", forHTTPHeaderField: "Content-Type")
            url.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options:[])
            
        
        print(urlString)
        URLSession.shared.dataTask(with: url as URLRequest) { (data, response, error) in
            
            if error != nil {
                if let someCompletion = completion{
                    someCompletion((response as? HTTPURLResponse)?.statusCode, error, nil)
                }
                return
            }
            
            do {
                if let unwrappedData = data {
                    
                    let jsonDictionaries = try JSONSerialization.jsonObject(with: unwrappedData, options: .allowFragments) as? [String: Any]
                    
                    DispatchQueue.main.async(execute: {
                        
                        print(jsonDictionaries ?? "")
                        
                        if let someCompletion = completion{
                            someCompletion((response as? HTTPURLResponse)?.statusCode, nil, jsonDictionaries)
                        }
                    })
                }
                
            } catch let jsonError {
                if let someCompletion = completion{
                    someCompletion((response as? HTTPURLResponse)?.statusCode, jsonError, nil)
                }
            }
            
            }.resume()
        
    }
    
 
    
    
    
    
    
    func startParse(data:Any,completion:@escaping(Poll?, Error?) -> Void){
        
        if let dataJson = data as? [String:Any]{
            
            let pollModel = Poll()
            if let me = (dataJson["me"] as? [String:Any]){
                if let hasAccountNumber = me["has-account"] as? NSNumber{
                    pollModel.hasAccount = hasAccountNumber.boolValue
                }
                
                if let qlicticsNumber = me["has-qlitics"] as? NSNumber{
                    pollModel.hasQlitics = qlicticsNumber.boolValue
                }
            }
            
            if let poll = (dataJson["poll"] as? [String:Any]){
                
                if let pollID = poll["id"] as? NSNumber{
                    pollModel.id = pollID.intValue
                }
                
                if let topic = poll["topic"] as? String{
                    pollModel.question = topic
                }
                
                if let description = poll["description"] as? String{
                    pollModel.pollDescription  = description
                }
                
                if let votedOnDict = poll["voted-on"] as? [String:Any]{
                    if let votedOnID = votedOnDict["id"] as? NSNumber{
                        pollModel.votedOn = votedOnID.intValue
                    }
                }
                
                if let opinions = poll["opinions"] as? [[String:Any]]{
                    
                    var opinionArray:[Opinion] = []
                    
                    for opinion in opinions{
                        let opiniond = Opinion()
                        if let id = opinion["id"] as? NSNumber{
                            opiniond.id = id.intValue
                        }
                        
                        if let text = opinion["text"] as? String{
                            opiniond.title = text
                        }
                        
                        if let percentVotes = opinion["percentage-votes"] as? NSNumber{
                            opiniond.percentVotes = percentVotes.intValue
                        }
                        opinionArray.append(opiniond)
                    }
                    
                    pollModel.opinions = opinionArray
                    
                }
                
                
                if let heroImage = poll["hero-image"] as? [String:Any]{
                    
                    if let s3Key = heroImage["s3-key"] as? String{
                        pollModel.heroImageS3Key = s3Key
                        if let metadata = heroImage["metadata"] as? [String:Any]{
                            
                            let metadataImage:ImageMetdata = ImageMetdata.init()
                            
                            if let width = metadata["width"] as? NSNumber{
                                metadataImage.width = width.intValue
                            }
                            
                            if let height = metadata["height"] as? NSNumber{
                                metadataImage.height = height.intValue
                            }
                            
                            if let focusPoints = metadata["focus-point"] as? [NSNumber]{
                                var focusPointArray = [Int]()
                                
                                for point in focusPoints{
                                    focusPointArray.append(point.intValue)
                                }
                                
                                metadataImage.focusPoints = focusPointArray
                            }
                            
                            pollModel.heroImageMetadata = metadataImage
                        }
                    }
                    
                }
            }
            
            completion(pollModel, nil)
        }
        else{
            let error = NSError.init(domain: "Root Structure not defined", code: 24, userInfo: nil)
            completion(nil,error as Error)
            
        }
    }
}
