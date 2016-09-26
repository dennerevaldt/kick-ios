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
    
    init(name:String, category:String) {
        self.name = name
        self.category = category
    }
    
    init(id:NSInteger, name:String, category:String) {
        self.idCourt = id
        self.name = name
        self.category = category
    }
    
    // Mappable
    func mapping(map: Map) {
        idCourt <- map["id"]
        name <- map["name"]
        category <- map["category"]
        schedules <- map["Schedules"]
    }
}