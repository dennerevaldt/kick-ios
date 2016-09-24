//
//  Enterprise.swift
//  kickoff
//
//  Created by Denner Evaldt on 05/09/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import Foundation
import ObjectMapper

class Enterprise: Person {
    var idEnterprise: NSInteger?
    var telephone: String?
    
    required init?(_ map: Map) {
        super.init(map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map)
        
        idEnterprise <- map["id"]
        telephone <- map["telephone"]
    }
}