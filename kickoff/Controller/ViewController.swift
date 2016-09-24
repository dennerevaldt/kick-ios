//
//  ViewController.swift
//  kickoff
//
//  Created by Denner Evaldt on 19/08/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit
import PKHUD
import Alamofire
import ObjectMapper
import SCLAlertView
import Locksmith
import FacebookCore
import FacebookLogin

class ViewController: UIViewController, UITextFieldDelegate {
    
    var isLogged: Bool = false

    @IBOutlet weak var labelCreateAccount: UILabel!
    @IBOutlet weak var textFieldUser: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    var name: String = ""
    var email: String = ""
    var id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textFieldUser.delegate = self
        textFieldPassword.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        let tpUser = KeychainManager.getTypeUser()
        if tpUser != "" {
            if tpUser == "P" {
                self.performSegueWithIdentifier("segueHomePlayer", sender: self)
            } else {
                self.performSegueWithIdentifier("segueHomeEnterprise", sender: self)
            }
        }
    }

    @IBAction func btnLoginFacebook(sender: AnyObject) {
        let loginManager = LoginManager()
        loginManager.logIn([.PublicProfile, .Email], viewController: self) { loginResult in
            switch loginResult {
            case .Success( _, _, let accessToken):
                self.getDataFacebook(accessToken)
                break
            case .Failed(let error):
                print(error)
                break
            case .Cancelled:
                print("User cancelled login.")
                break
            }
        }
    }
    
    @IBAction func btnLoginSimple(sender: AnyObject) {
        
        if textFieldUser.text == "" || textFieldPassword.text == "" {
            SCLAlertView().showTitle(
                "Atenção",
                subTitle: "Usuário e senha devem ser preenchidos corretamente.",
                duration: nil,
                completeText: "OK",
                style: .Warning,
                colorStyle: nil,
                colorTextButton: nil
            )
            return
        }
        
        HUD.show(.Progress)

        let parameters = [
            "username": textFieldUser.text!,
            "password": textFieldPassword.text!
        ]
        
        Alamofire.request(.POST, URLRequest.URLToken, parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if response.result.isSuccess {
                    if let data = response.result.value {
                        if let token = data["token"] {
                            self.getCredentials(token! as! String)
                        }
                    }
                } else {
                    HUD.hide()
                    SCLAlertView().showTitle(
                        "Ops",
                        subTitle: "Usuário ou senha inválidos.",
                        duration: nil,
                        completeText: "Tentar novamente",
                        style: .Warning,
                        colorStyle: nil,
                        colorTextButton: nil
                    )
                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tapCreateNewAccount(sender: UITapGestureRecognizer) {
        self.performSegueWithIdentifier("segueNewAccount", sender: self)
    }
    
    func textFieldShouldReturn(textFieldResponsible : UITextField) -> Bool {
        textFieldResponsible.resignFirstResponder()
        return true;
    }
    
    func setCredentials(name: String, token: String, email: String, typeUser: String) -> Void {
        KeychainManager.saveCredentials(name, email: email, token: token, typeUser: typeUser)
    }
    
    func getCredentials (token: String) -> Void {
        let headers = [
            "x-access-token": token,
            "Accept": "application/json"
        ]
        Alamofire.request(.GET, URLRequest.URLDataUser, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                HUD.hide()
                if response.result.isSuccess {
                    if let data = response.result.value {
                        if (data.objectForKey("Person")?.objectForKey("typeperson"))! as! String == "P" {
                            let User = Mapper<Player>().map(data)
                            self.setCredentials((User?.fullName!)!, token: token, email: (User?.eMail!)!, typeUser: "P")
                            self.performSegueWithIdentifier("segueHomePlayer", sender: self)
                            
                        } else {
                            let User = Mapper<Enterprise>().map(data)
                            self.setCredentials((User?.fullName!)!, token: token, email: (User?.eMail!)!, typeUser: "E")
                            self.performSegueWithIdentifier("segueHomeEnterprise", sender: self)
                        }
                    }
                }
        }
        
    }
    
    func getDataFacebook(accessToken: AccessToken) {
        let parameters = ["fields": "name, email"]
        
        GraphRequest(graphPath: "me", parameters: parameters).start({(connection, result) -> Void in
            
            switch result {
            case .Success(let response):
                
                for (key, value) in response.dictionaryValue! {
                    if key == "name" {
                        self.name = value as! String
                    }
                    if key == "email" {
                        self.email = value as! String
                    }
                    if key == "id" {
                        self.id = value as! String
                    }
                }
                
                self.loginFacebook(self.email, password: self.id)

            case .Failed(let error):
                print("Graph Request Failed: \(error)")
            }
        })
    }
    
    func loginFacebook(email: String, password: String) -> Void {
        HUD.show(.Progress)
        
        let parameters = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request(.POST, URLRequest.URLTokenFacebook, parameters: parameters)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                case .Success:
                    if let data = response.result.value {
                        if let token = data["token"] {
                            self.getCredentials(token! as! String)
                        }
                    }
                case .Failure(let error):
                    HUD.hide()
                    
                    if let status = error.userInfo["StatusCode"]{
                        if status as! Int == 401 {
                            
                            SCLAlertView().showTitle(
                                "Ops",
                                subTitle: "Usuário não cadastro via Facebook.",
                                duration: nil,
                                completeText: "Tentar novamente",
                                style: .Warning,
                                colorStyle: nil,
                                colorTextButton: nil
                            )
                            
                        } else if status as! Int == 404 {
                            
                            self.performSegueWithIdentifier("segueConfirmAccount", sender: self)
                            
                        } else if status as! Int == 500 {
                            
                            SCLAlertView().showTitle(
                                "Ops",
                                subTitle: "Problemas com a conexão, verifique e tente novamente.",
                                duration: nil,
                                completeText: "Tentar novamente",
                                style: .Error,
                                colorStyle: nil,
                                colorTextButton: nil
                            )
                            
                        }
                    }
                }
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueConfirmAccount" {
            let viewController = segue.destinationViewController as! UINavigationController
            let confirmVC = viewController.topViewController as! ConfirmAccountViewController
            confirmVC.idConfirm = self.id
            confirmVC.nameConfirm = self.name
            confirmVC.emailConfirm = self.email
        }
    }
}

