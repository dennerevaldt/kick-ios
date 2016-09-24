//
//  Person.swift
//  kickoff
//
//  Created by Denner Evaldt on 05/09/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import Foundation
import ObjectMapper

class Person: Mappable {
    var idPerson: NSInteger?
    var fullName: String?
    var userName: String?
    var eMail: String?
    var password: String?
    var district: String?
    var lat: String?
    var lng: String?
    
    required init?(_ map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        idPerson <- map["Person.id"]
        fullName <- map["Person.fullname"]
        userName <- map["Person.username"]
        eMail <- map["Person.email"]
        password <- map["Person.password"]
        district <- map["Person.district"]
        lat <- map["Person.lat"]
        lng <- map["Person.lng"]
    }
    
}