//
//  EnterpriseAPI.swift
//  kickoff
//
//  Created by Denner Evaldt on 26/09/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class CourtAPI {
    
    func create(court: Court, completion:(result: Bool)->Void) -> Void {
        let headers = [
            "x-access-token": KeychainManager.getToken(),
            "Accept": "application/json"
        ]
        let parameters : [ String : String] = [
            "name": court.name!,
            "category": court.category!
        ]
        Alamofire.request(.POST, URLRequest.URLCourtsEnterprise, headers: headers, parameters: parameters)
            .validate()
            .responseJSON{ response in
                if response.result.isSuccess {
                    completion(result: true)
                } else {
                    completion(result: false)
                }
        }
    }
    
    func edit() {
        
    }
    
    func delete() {
        
    }
    
}
