//
//  Student.swift
//  PollSample
//
//  Created by Arjun P A on 13/02/17.
//  Copyright © 2017 Arjun P A. All rights reserved.
//

import Foundation

struct Student:SampleProtocol {
    
    var name:String
    var rollNo:Int
    
    var podaPotta:String?
    
    
    public init(name:String, rollNo:Int){
        self.name = name
        self.rollNo = rollNo
    }
    
    mutating func totalMark(){
        
     //   podaPotta?.append("kasyap")
        

       
    }
}
