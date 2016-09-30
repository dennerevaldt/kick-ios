//
//  ConfirmAccountViewController.swift
//  kickoff
//
//  Created by Denner Evaldt on 22/09/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit
import SCLAlertView
import PKHUD
import Alamofire
import ObjectMapper
import Locksmith
import GoogleMaps

class ConfirmAccountViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, DestinationViewController {
    
    var idConfirm: String!
    var nameConfirm: String!
    var emailConfirm: String!
    var typeUser: Int = 0
    
    @IBOutlet weak var textFieldUser: UITextField!
    @IBOutlet weak var textFieldVariable: UITextField!
    @IBOutlet weak var textFieldCityState: UITextField!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var uiPickerView: UIPickerView!
    
    var pickerData: [String] = [String]()
    var placeItemSelected: GMSPlace?
    
    @IBAction func btnClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelName.text = "Olá \(nameConfirm), seu cadastro está quase concluído! Informe somente mais alguns campos para finalizar."
        self.justifyNameLabel()
        
        // Connect data:
        self.uiPickerView.delegate = self
        self.uiPickerView.dataSource = self
        
        textFieldUser.delegate = self
        textFieldVariable.delegate = self
        textFieldCityState.delegate = self
        
        // Input data into the Array:
        pickerData = ["Empresa", "Jogador"]
        
        // Init placeholder
        textFieldVariable.placeholder = "Telefone"
        
        setBackItem()
    }
    
    func setBackItem() {
        var backBtn = UIImage(named: "ic_back")
        backBtn = backBtn?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.navigationController!.navigationBar.backIndicatorImage = backBtn;
        self.navigationController!.navigationBar.backIndicatorTransitionMaskImage = backBtn;
        
        let backBarButton = UIBarButtonItem()
        backBarButton.title = ""
        navigationItem.backBarButtonItem = backBarButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func justifyNameLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Justified
        paragraphStyle.firstLineHeadIndent = 0.001
        
        let mutableAttrStr = NSMutableAttributedString(attributedString: labelName.attributedText!)
        mutableAttrStr.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, mutableAttrStr.length))
        labelName.attributedText = mutableAttrStr
    }
    
    // MARK: - picker functions
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        self.typeUser = row
        textFieldVariable.text = ""
        if row == 0 {
           textFieldVariable.placeholder = "Telefone"
        } else if row == 1 {
           textFieldVariable.placeholder = "Posição de jogo"
        }
    }
    
    // MARK: - Create user action
    @IBAction func btnCreateUser(sender: AnyObject) {
        if typeUser == 0 {
            createEnterprise()
        } else if typeUser == 1 {
            createPlayer()
        }
    }

    func createEnterprise() {
        if self.checkInputs() {
            HUD.show(.Progress)
            let headers = [
                "Accept": "application/json"
            ]
            let parameters : [ String : String] = [
                "username": textFieldUser.text!,
                "password": self.idConfirm,
                "fullname": self.nameConfirm,
                "telephone": textFieldVariable.text!,
                "email": self.emailConfirm,
                "district": textFieldCityState.text!,
                "typeperson": "E",
                "lat": "\(placeItemSelected!.coordinate.latitude)",
                "lng": "\(placeItemSelected!.coordinate.longitude)"
            ]
            Alamofire.request(.POST, URLRequest.URLCreateEnterprise, headers: headers, parameters: parameters)
                .validate(statusCode: 200..<300)
                .responseJSON{ response in
                    if response.result.isSuccess {
                        self.loginFacebook(self.emailConfirm, password:self.idConfirm)
                    } else {
                        HUD.hide()
                        SCLAlertView().showTitle(
                            "Ops",
                            subTitle: "Falha ao criar usuário, verifique os campos e tente novamente.",
                            duration: nil,
                            completeText: "OK",
                            style: .Error,
                            colorStyle: nil,
                            colorTextButton: nil
                        )
                    }
            }
        } else {
            SCLAlertView().showTitle(
                "Atenção",
                subTitle: "Preencha todos os campos corretamente.",
                duration: nil,
                completeText: "OK",
                style: .Warning,
                colorStyle: nil,
                colorTextButton: nil
            )
        }
    }
    
    func createPlayer() {
        if self.checkInputs() {
            HUD.show(.Progress)
            let headers = [
                "Accept": "application/json"
            ]
            let parameters : [ String : String] = [
                "username": textFieldUser.text!,
                "password": self.idConfirm,
                "fullname": self.nameConfirm,
                "position": textFieldVariable.text!,
                "email": self.emailConfirm,
                "district": textFieldCityState.text!,
                "typeperson": "E",
                "lat": "\(placeItemSelected!.coordinate.latitude)",
                "lng": "\(placeItemSelected!.coordinate.longitude)"
            ]
            Alamofire.request(.POST, URLRequest.URLCreatePlayer, headers: headers, parameters: parameters)
                .validate(statusCode: 200..<300)
                .responseJSON{ response in
                    if response.result.isSuccess {
                        self.loginFacebook(self.emailConfirm, password:self.idConfirm)
                    } else {
                        HUD.hide()
                        SCLAlertView().showTitle(
                            "Ops",
                            subTitle: "Falha ao criar usuário, verifique os campos e tente novamente.",
                            duration: nil,
                            completeText: "OK",
                            style: .Error,
                            colorStyle: nil,
                            colorTextButton: nil
                        )
                    }
            }
        } else {
            SCLAlertView().showTitle(
                "Atenção",
                subTitle: "Preencha todos os campos corretamente.",
                duration: nil,
                completeText: "OK",
                style: .Warning,
                colorStyle: nil,
                colorTextButton: nil
            )
        }
    }
    
    func checkInputs() -> Bool {
        if textFieldUser.text != "" && textFieldVariable.text != "" && placeItemSelected != nil {
            return true
        }
        return false
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
                        if status as! Int == 500 {
                            
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
                        HUD.hide()
                        self.navigationController?.navigationBarHidden = true
                        if (data.objectForKey("Person")?.objectForKey("typeperson"))! as! String == "P" {
                            let User = Mapper<Player>().map(data)
                            self.setCredentials((User?.fullName!)!, token: token, email: (User?.eMail!)!, typeUser: "P")
                            self.performSegueWithIdentifier("seguePlayer", sender: self)
                        } else {
                            let User = Mapper<Enterprise>().map(data)
                            self.setCredentials((User?.fullName!)!, token: token, email: (User?.eMail!)!, typeUser: "E")
                            self.performSegueWithIdentifier("segueEnterprise", sender: self)
                        }
                    }
                }
        }
        
    }
    
    func setCredentials(name: String, token: String, email: String, typeUser: String) -> Void {
        KeychainManager.saveCredentials(name, email: email, token: token, typeUser: typeUser)
    }
    
    // MARK: text fields
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textFieldCityState == textField {
            self.performSegueWithIdentifier("segueSearchConfirmAc", sender: self)
            return false
        }
        return true
    }
    
    // MARK: navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueSearchConfirmAc" {
            let navigationSearch = segue.destinationViewController as! SearchCityTVController
            navigationSearch.delegate = self
        }
    }
    
    // MARK: protocolo
    
    func setCordinates(placeSelected: GMSPlace) {
        placeItemSelected = placeSelected
        textFieldCityState.text = placeSelected.formattedAddress
    }
}
