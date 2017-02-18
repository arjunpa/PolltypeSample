//
//  UICollectionView + CellVisibility.swift
//  PollSample
//
//  Created by Arjun P A on 17/02/17.
//  Copyright © 2017 Arjun P A. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView{

    func cellIsVisible(forIndexPath:NSIndexPath) -> Bool{
        
        if let _ = cellForItemAtIndexPath(forIndexPath){
            return true
        }
        
        return false
    }
}
