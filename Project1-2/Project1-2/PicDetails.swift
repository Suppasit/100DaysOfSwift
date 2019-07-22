//
//  PicDetails.swift
//  Project1-2
//
//  Created by suppasit chuwatsawat on 25/6/2562 BE.
//  Copyright © 2562 suppasit chuwatsawat. All rights reserved.
//

import UIKit

class PicDetails: NSObject, Codable, Comparable {
    static func < (lhs: PicDetails, rhs: PicDetails) -> Bool {
        return lhs.name < rhs.name
    }
    
    var name: String
    var count: Int
    
    init(name: String, count: Int) {
        self.name = name
        self.count = count
    }
}
