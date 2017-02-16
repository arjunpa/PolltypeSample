//
//  Poll.swift
//  PollSample
//
//  Created by Arjun P A on 24/12/16.
//  Copyright © 2016 Arjun P A. All rights reserved.
//

import Foundation

class Poll:NSObject{

    var hasAccount:Bool = false
    var hasQlitics:Bool = false
    var pollDescription:String?
    var votedOn:Int?
    
    
    var id:Int!
    var question:String!
    
    var opinions:[Opinion] = []
    var heroImageS3Key:String?
    var heroImageMetadata:ImageMetdata?
}

class Opinion: NSObject {
    
    var title:String!
    var id:Int!
    var percentVotes:Int!
}
