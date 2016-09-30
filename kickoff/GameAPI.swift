//
//  GameAPI.swift
//  kickoff
//
//  Created by Denner Evaldt on 30/09/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class GameAPI {
    func create(game: Game, completion:(result: Bool)->Void) -> Void {
        let headers = [
            "x-access-token": KeychainManager.getToken(),
            "Accept": "application/json"
        ]
        let parameters : [ String : String] = [
            "name": game.name!,
            "schedule_id": "\(game.schedule!.idSchedule!)"
        ]
        Alamofire.request(.POST, URLRequest.URLGamesPlayer, headers: headers, parameters: parameters)
            .validate()
            .responseJSON{ response in
                if response.result.isSuccess {
                    completion(result: true)
                } else {
                    completion(result: false)
                }
        }
    }
    
    func edit(game: Game, completion:(result: Bool)->Void) -> Void {
        let headers = [
            "x-access-token": KeychainManager.getToken(),
            "Accept": "application/json"
        ]
        let parameters : [ String : String] = [
            "name": game.name!,
            "schedule_id": "\(game.schedule!.idSchedule!)"
        ]
        Alamofire.request(.PUT, URLRequest.URLGamesPlayer + "/\(game.idGame!)", headers: headers, parameters: parameters)
            .validate()
            .responseJSON{ response in
                if response.result.isSuccess {
                    completion(result: true)
                } else {
                    completion(result: false)
                }
        }
    }
    
    func delete(idGame: Int, completion:(result: Bool)->Void) -> Void {
        let headers = [
            "x-access-token": KeychainManager.getToken(),
            "Accept": "application/json"
        ]
        Alamofire.request(.DELETE, URLRequest.URLGamesPlayer + "/\(idGame)", headers: headers)
            .validate()
            .responseJSON { response in
                if response.result.isSuccess {
                    completion(result: true)
                } else {
                    completion(result: false)
                }
        }
    }
    
    func getAll(completion:(result: Array<Game>, error: NSError?)->Void) -> Void {
        let headers = [
            "x-access-token": KeychainManager.getToken(),
            "Accept": "application/json"
        ]
        Alamofire.request(.GET, URLRequest.URLGamesPlayer, headers: headers)
            .validate(statusCode: 200..<300)
            .responseArray { (response: Response<[Game], NSError>) in
                
                if response.result.isSuccess {
                    let gameArray = response.result.value
                    
                    if let gameWrapper = gameArray {
                        completion(result: gameWrapper, error: response.result.error)
                    }
                } else {
                    completion(result: [], error: response.result.error)
                }
                
        }
    }
}
