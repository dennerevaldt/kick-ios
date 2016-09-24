//
//  TabPlayerController.swift
//  kickoff
//
//  Created by Denner Evaldt on 19/08/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import PKHUD
import SCLAlertView
import GoogleMaps

class TabPlayerController: UIViewController, UITextFieldDelegate, DestinationViewController {
    
    @IBOutlet weak var nameFull: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var position: UITextField!
    @IBOutlet weak var cityState: UITextField!
    
    var placeItemSelected: GMSPlace?
    
    @IBAction func buttonExitToLogin(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.tintColor = UIColor(red: CGFloat(76.0/255.0), green: CGFloat(175.0/255.0), blue: CGFloat(80.0/255.0), alpha: CGFloat(1.0))
        
        nameFull.delegate = self
//        email.delegate = self
//        user.delegate = self
//        password.delegate = self
//        position.delegate = self
        cityState.delegate = self
        
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
    
    @IBAction func btnCloseTab(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnCreatePlayer(sender: AnyObject) {
        if self.checkInputs() {
            HUD.show(.Progress)
            let headers = [
                "Accept": "application/json"
            ]
            let parameters : [ String : String] = [
                "username": self.user.text!,
                "password": self.password.text!,
                "fullname": self.nameFull.text!,
                "position": self.position.text!,
                "email": self.email.text!,
                "district": self.cityState.text!,
                "typeperson": "P",
                "lat": "\(placeItemSelected?.coordinate.latitude)",
                "lng": "\(placeItemSelected?.coordinate.longitude)"
            ]
            Alamofire.request(.POST, URLRequest.URLCreatePlayer, headers: headers, parameters: parameters)
                .validate(statusCode: 200..<300)
                .responseJSON{ response in
                    if response.result.isSuccess {
                        HUD.hide()
                        self.clearInputs()
                        
                        let appearance = SCLAlertView.SCLAppearance(
                            showCloseButton: false
                        )
                        let alertView = SCLAlertView(appearance: appearance)
                        alertView.addButton("Fazer login") {
                            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                        }
                        alertView.showSuccess("Obrigado", subTitle: "Você foi cadastrado. Entre agora e curta o Kick Off.")
                        
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
        if user.text != "" && password.text != "" && nameFull.text != "" && position.text != "" && email.text != "" && cityState.text != "" && placeItemSelected != nil {
            return true
        }
        return false
    }
    
    func clearInputs() -> Void {
        user.text = ""
        password.text = ""
        nameFull.text = ""
        position.text = ""
        email.text = ""
        cityState.text = ""
    }
    
    // MARK: text fields
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if cityState == textField {
            self.performSegueWithIdentifier("segueSearch", sender: self)
            return false
        }
        return true
    }
    
    // MARK: navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueSearch" {
            let navigationSearch = segue.destinationViewController as! SearchCityTVController
            navigationSearch.delegate = self
        }
    }
    
    // MARK: protocolo
    
    func setCordinates(placeSelected: GMSPlace) {
        placeItemSelected = placeSelected
        cityState.text = placeSelected.formattedAddress
    }
    
}
