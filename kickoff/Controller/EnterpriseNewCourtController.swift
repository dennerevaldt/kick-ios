//
//  EnterpriseNewCourtController.swift
//  kickoff
//
//  Created by Denner Evaldt on 13/09/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit
import SCLAlertView
import PKHUD

protocol CourtDestinationViewController {
    func setNewCourt()
}

class EnterpriseNewCourtController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var textFieldNameCourt: UITextField!
    @IBOutlet weak var pickerViewCategoryCourt: UIPickerView!
    
    var pickerData: [String] = [String]()
    var categoryCourtSelected: String = "Futebol society (7)"
    var delegate: CourtDestinationViewController! = nil
    var court: Court? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect data:
        self.pickerViewCategoryCourt.delegate = self
        self.pickerViewCategoryCourt.dataSource = self
        
        // Input data into the Array:
        pickerData = ["Futebol society (7)", "Futebol de salão (Futsal)"]
        
        if let courtWrapper = court {
            textFieldNameCourt.text = courtWrapper.name!
            
            if courtWrapper.category == "Futebol society (7)" {
                pickerViewCategoryCourt.selectRow(0, inComponent: 0, animated: true)
            } else {
                pickerViewCategoryCourt.selectRow(1, inComponent: 0, animated: true)
            }
            
            self.title = "Editar quadra"
        } else {
            self.title = "Nova quadra"
        }
    }
    
    @IBAction func createCourt(sender: AnyObject) {
        if self.checkInputs() {
            HUD.show(.Progress)
            let courtAPI = CourtAPI()
            
            if self.court == nil {
                let court = Court(name: textFieldNameCourt.text!, category: categoryCourtSelected)
                
                courtAPI.create(court) {(result) -> Void in
                    HUD.hide(animated: true)
                    if result {
                        self.delegate.setNewCourt()
                        self.navigationController?.popViewControllerAnimated(true)
                    } else {
                        MessageAlert.error("Problema ao cadastrar nova quadra, tente novamente.")
                    }
                }
            } else {
                let court = Court(id: (self.court?.idCourt)!, name: textFieldNameCourt.text!, category:categoryCourtSelected)
                
                courtAPI.edit(court) {(result) -> Void in
                    HUD.hide()
                    if result {
                        self.delegate.setNewCourt()
                        self.navigationController?.popViewControllerAnimated(true)
                    } else {
                        MessageAlert.error("Problema ao editar quadra, tente novamente.")
                    }
                }
            }
        } else {
            MessageAlert.warning("Preencha os campos corretamente.")
        }
    }
    
    @IBAction func btnClose(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func checkInputs() -> Bool {
        if textFieldNameCourt.text != "" && categoryCourtSelected != "" {
            return true
        } else {
            return false
        }
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
 
        if row == 0 {
            categoryCourtSelected = "Futebol society (7)"
        } else if row == 1 {
            categoryCourtSelected = "Futebol de salão (Futsal)"
        }
    }
}
