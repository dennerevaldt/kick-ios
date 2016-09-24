//
//  KeychainManager.swift
//  kickoff
//
//  Created by Denner Evaldt on 15/09/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit
import Locksmith

class KeychainManager {   
    static func saveCredentials(name: String, email: String, token: String, typeUser: String) -> Void {
        do {
            try Locksmith.saveData(["name": name, "email": email, "token": token, "typeUser": typeUser], forUserAccount: "accountKick")
        } catch {
            print("Erro ao salvar credenciais")
        }
    }
    
    static func clearCredentials() -> Void {
        do {
            try Locksmith.deleteDataForUserAccount("accountKick")
        } catch {
            print("Erro ao limpar credenciais")
        }
    }
    
    static func getToken() -> String {
        var dictionary = Locksmith.loadDataForUserAccount("accountKick")
        return dictionary != nil ? dictionary!["token"] as! String : ""
    }
    
    static func getName() -> String {
        var dictionary = Locksmith.loadDataForUserAccount("accountKick")
        return dictionary != nil ? dictionary!["name"] as! String : ""
    }
    
    static func getEmail() -> String {
        var dictionary = Locksmith.loadDataForUserAccount("accountKick")
        return dictionary != nil ? dictionary!["email"] as! String : ""
    }
    
    static func getTypeUser() -> String {
        var dictionary = Locksmith.loadDataForUserAccount("accountKick")
        return dictionary != nil ? dictionary!["typeUser"] as! String : ""
    }
}
