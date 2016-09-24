//
//  URL.swift
//  kickoff
//
//  Created by Denner Evaldt on 05/09/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import Foundation

struct URLRequest {
    static let URLToken = "\(base_url)/token"
    static let URLTokenFacebook = "\(base_url)/token-facebook"
    static let URLDataUser = "\(base_url)/user"
    // Player
    static let URLGamesPlayer = "\(base_url)/game"
    static let URLCreatePlayer = "\(base_url)/player"
    // Enterprise
    static let URLCreateEnterprise = "\(base_url)/enterprise"
    static let URLCourtsEnterprise = "\(base_url)/court"
    static let URLSchedulesEnterprise = "\(base_url)/schedule"
}

let base_url = "http://localhost:3000"
//let base_url = "http://192.168.0.6:3000"
