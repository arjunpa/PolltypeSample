//
//  SampleProtocol.swift
//  PollSample
//
//  Created by Arjun P A on 13/02/17.
//  Copyright © 2017 Arjun P A. All rights reserved.
//

import Foundation

public protocol SampleProtocol{

    var name:String{
        get set
    }
    var rollNo:Int{
        get set
    }
    
    mutating func totalMark()
    
}
