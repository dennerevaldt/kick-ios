//
//  Court.swift
//  kickoff
//
//  Created by Denner Evaldt on 12/09/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit

import ObjectMapper

class Court: Mappable {
    var idCourt: NSInteger?
    var name: String?
    var category: String?
    var schedules: Array<Schedule>?
    
    required init?(_ map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        idCourt <- map["id"]
        name <- map["name"]
        category <- map["category"]
        schedules <- map["Schedules"]
    }
}