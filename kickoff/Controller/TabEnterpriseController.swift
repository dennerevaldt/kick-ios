//
//  TabEnterpriseController.swift
//  kickoff
//
//  Created by Denner Evaldt on 19/08/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper
import PKHUD
import SCLAlertView
import GoogleMaps

class TabEnterpriseController: UIViewController, UITextFieldDelegate, DestinationViewController {

    @IBOutlet weak var nameFull: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var telephone: UITextField!
    @IBOutlet weak var cityState: UITextField!
    @IBOutlet weak var scrollViewForm: UIScrollView!
    
    var placeItemSelected: GMSPlace?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameFull.delegate = self
        email.delegate = self
        user.delegate = self
        password.delegate = self
        telephone.delegate = self
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
    
    @IBAction func buttonExitToLogin(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnCloseTab(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnCreateEnterprise(sender: AnyObject) {
        if self.checkInputs() {
            HUD.show(.Progress)
            let headers = [
                "Accept": "application/json"
            ]
            let parameters : [ String : String] = [
                "username": self.user.text!,
                "password": self.password.text!,
                "fullname": self.nameFull.text!,
                "telephone": self.telephone.text!,
                "email": self.email.text!,
                "district": self.cityState.text!,
                "typeperson": "E",
                "lat": "\(placeItemSelected!.coordinate.latitude)",
                "lng": "\(placeItemSelected!.coordinate.longitude)"
            ]
            Alamofire.request(.POST, URLRequest.URLCreateEnterprise, headers: headers, parameters: parameters)
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
        if user.text != "" && password.text != "" && nameFull.text != "" && telephone.text != "" && email.text != "" && cityState.text != "" && placeItemSelected != nil {
            return true
        }
        return false
    }
    
    func clearInputs() -> Void {
        user.text = ""
        password.text = ""
        nameFull.text = ""
        telephone.text = ""
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
            self.performSegueWithIdentifier("segueSearchEnterprise", sender: self)
            return false
        }
        return true
    }
    
    // MARK: navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueSearchEnterprise" {
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
