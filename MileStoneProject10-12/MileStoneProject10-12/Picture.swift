//
//  Picture.swift
//  MileStoneProject10-12
//
//  Created by suppasit chuwatsawat on 27/6/2562 BE.
//  Copyright © 2562 suppasit chuwatsawat. All rights reserved.
//

import UIKit

class Picture: NSObject, Codable {
    var caption: String
    var path: String
    
    init(caption: String, path: String) {
        self.caption = caption
        self.path = path
    }

}
