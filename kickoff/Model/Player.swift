//
//  Player.swift
//  kickoff
//
//  Created by Denner Evaldt on 19/08/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit
import ObjectMapper

class Player: Person {
    var idPlayer: NSInteger?
    var position: String?
    
    required init?(_ map: Map) {
        super.init(map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map)
        
        idPlayer <- map["id"]
        position <- map["position"]
    }
}