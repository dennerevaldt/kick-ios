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
    func setNewCourt(result: Bool)
}

class EnterpriseNewCourtController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var textFieldNameCourt: UITextField!
    @IBOutlet weak var pickerViewCategoryCourt: UIPickerView!
    
    var pickerData: [String] = [String]()
    var categoryCourtSelected: String = "Futebol society (7)"
    var delegate: CourtDestinationViewController! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect data:
        self.pickerViewCategoryCourt.delegate = self
        self.pickerViewCategoryCourt.dataSource = self
        
        // Input data into the Array:
        pickerData = ["Futebol society (7)", "Futebol de salão (Futsal)"]
    }
    
    @IBAction func createCourt(sender: AnyObject) {
        if self.checkInputs() {
            HUD.show(.Progress)
            let court = Court(name: textFieldNameCourt.text!, category: categoryCourtSelected)
            
            let courtAPI = CourtAPI()
            
            courtAPI.create(court) {(result) -> Void in
                HUD.hide(animated: true)
                if result {
                    print("created")
                    self.delegate.setNewCourt(true)
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    print("error")
                }
            }
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
