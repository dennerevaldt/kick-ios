//
//  Schedule.swift
//  kickoff
//
//  Created by Denner Evaldt on 12/09/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit
import ObjectMapper

class Schedule: Mappable {
    var idSchedule: NSInteger?
    var horary: String?
    var date: String?
    var court: Court?
    
    init(idSchedule:Int, horary:String, date:String, court:Court) {
        self.idSchedule = idSchedule
        self.horary = horary
        self.date = date
        self.court = court
    }
    
    required init?(_ map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        idSchedule <- map["id"]
        horary <- map["horary"]
        date <- map["date"]
        court <- map ["Court"]
    }
}
