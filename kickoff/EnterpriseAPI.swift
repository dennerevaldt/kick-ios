//
//  EnterpriseAPI.swift
//  kickoff
//
//  Created by Denner Evaldt on 30/09/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class EnterpriseAPI {
    
    func getAllProximity(lat:String, lng: String, completion:(result: Array<Enterprise>, error: NSError?)->Void) -> Void {
        let headers = [
            "x-access-token": KeychainManager.getToken(),
            "Accept": "application/json"
        ]
        let parameters : [ String : String] = [
            "lat": lat,
            "lng": lng
        ]
        Alamofire.request(.POST, URLRequest.URLCreateEnterprise + "/proximity", headers: headers, parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseArray { (response: Response<[Enterprise], NSError>) in
                
                if response.result.isSuccess {
                    let entepriseArray = response.result.value
                    
                    if let entepriseWrapper = entepriseArray {
                        completion(result: entepriseWrapper, error: response.result.error)
                    }
                } else {
                    completion(result: [], error: response.result.error)
                }
        }
    }
    
}
