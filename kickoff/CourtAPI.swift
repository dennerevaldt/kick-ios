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
    
    func edit(court: Court, completion:(result: Bool)->Void) -> Void {
        let headers = [
            "x-access-token": KeychainManager.getToken(),
            "Accept": "application/json"
        ]
        let parameters : [ String : String] = [
            "name": court.name!,
            "category": court.category!
        ]
        Alamofire.request(.PUT, URLRequest.URLCourtsEnterprise + "/\(court.idCourt!)", headers: headers, parameters: parameters)
            .validate()
            .responseJSON{ response in
                if response.result.isSuccess {
                    completion(result: true)
                } else {
                    completion(result: false)
                }
        }
    }
    
    func delete(idCourt: Int, completion:(result: Bool)->Void) -> Void {
        let headers = [
            "x-access-token": KeychainManager.getToken(),
            "Accept": "application/json"
        ]
        Alamofire.request(.DELETE, URLRequest.URLCourtsEnterprise + "/\(idCourt)", headers: headers)
            .validate()
            .responseJSON { response in
                if response.result.isSuccess {
                    completion(result: true)
                } else {
                    completion(result: false)
                }
        }
    }
    
    func getAll(completion:(result: Array<Court>, error: NSError?)->Void) -> Void {
        let headers = [
            "x-access-token": KeychainManager.getToken(),
            "Accept": "application/json"
        ]
        Alamofire.request(.GET, URLRequest.URLCourtsEnterprise, headers: headers)
            .validate(statusCode: 200..<300)
            .responseArray { (response: Response<[Court], NSError>) in
                
                if response.result.isSuccess {
                    let courtArray = response.result.value
                    
                    if let courtArray = courtArray {
                        completion(result: courtArray, error: response.result.error)
                    }
                } else {
                    completion(result: [], error: response.result.error)
                }
                
        }
    }
    
}
