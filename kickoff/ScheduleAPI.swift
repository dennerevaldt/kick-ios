//
//  ScheduleAPI.swift
//  kickoff
//
//  Created by Denner Evaldt on 27/09/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class ScheduleAPI {
    func create(schedule: Schedule, completion:(result: Bool)->Void) -> Void {
        let headers = [
            "x-access-token": KeychainManager.getToken(),
            "Accept": "application/json"
        ]
        var idcourt = 0
        if let court = schedule.court?.idCourt {
            idcourt = court
        }
        let parameters : [ String : String] = [
            "date": schedule.date!,
            "horary": schedule.horary!,
            "court_id": "\(idcourt)"
        ]
        Alamofire.request(.POST, URLRequest.URLSchedulesEnterprise, headers: headers, parameters: parameters)
            .validate()
            .responseJSON{ response in
                if response.result.isSuccess {
                    completion(result: true)
                } else {
                    completion(result: false)
                }
        }
    }
    
    func edit(schedule: Schedule, completion:(result: Bool)->Void) -> Void {
        let headers = [
            "x-access-token": KeychainManager.getToken(),
            "Accept": "application/json"
        ]
        let parameters : [ String : String] = [
            "date": schedule.date!,
            "horary": schedule.horary!,
            "court_id": "\(schedule.court?.idCourt!)"
        ]
        Alamofire.request(.PUT, URLRequest.URLSchedulesEnterprise + "/\(schedule.idSchedule!)", headers: headers, parameters: parameters)
            .validate()
            .responseJSON{ response in
                if response.result.isSuccess {
                    completion(result: true)
                } else {
                    completion(result: false)
                }
        }
    }
    
    func delete(idSchedule: Int, completion:(result: Bool)->Void) -> Void {
        let headers = [
            "x-access-token": KeychainManager.getToken(),
            "Accept": "application/json"
        ]
        Alamofire.request(.DELETE, URLRequest.URLSchedulesEnterprise + "/\(idSchedule)", headers: headers)
            .validate()
            .responseJSON { response in
                if response.result.isSuccess {
                    completion(result: true)
                } else {
                    completion(result: false)
                }
        }
    }
    
    func getAll(completion:(result: Array<Schedule>, error: NSError?)->Void) -> Void {
        let headers = [
            "x-access-token": KeychainManager.getToken(),
            "Accept": "application/json"
        ]
        Alamofire.request(.GET, URLRequest.URLSchedulesEnterprise, headers: headers)
            .validate(statusCode: 200..<300)
            .responseArray { (response: Response<[Schedule], NSError>) in
                
                if response.result.isSuccess {
                    let scheduleArray = response.result.value
                    
                    if let scheduleWrapper = scheduleArray {
                        completion(result: scheduleWrapper, error: response.result.error)
                    }
                } else {
                    completion(result: [], error: response.result.error)
                }
                
        }
    }
}
