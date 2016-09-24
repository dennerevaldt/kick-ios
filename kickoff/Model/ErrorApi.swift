//
//  ErrorApi.swift
//  kickoff
//
//  Created by Denner Evaldt on 13/09/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit
import ObjectMapper

class ErrorApi: Mappable {
    
    var message: String?
    var type: String?
    var path: String?
    var value: String?
    
    required init?(_ map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        message <- map["message"]
        type <- map["type"]
        path <- map["path"]
        value <- map["value"]
    }
    
}
