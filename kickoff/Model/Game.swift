//
//  Game.swift
//  kickoff
//
//  Created by Denner Evaldt on 12/09/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit
import ObjectMapper

class Game: Mappable {
    var idGame: NSInteger?
    var name: String?
    var creator_id: String?
    var schedule: Schedule?
    var playerList: Array<Player>?
    var court: Court?
    
    required init?(_ map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        idGame <- map["id"]
        name <- map["name"]
        creator_id <- map["creator_id"]
        schedule <- map["Schedule"]
        playerList <- map["Players"]
        court <- map ["Schedule.Court"]
    }
}