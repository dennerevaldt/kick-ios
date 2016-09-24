//
//  EnterpriseNewScheduleController.swift
//  kickoff
//
//  Created by Denner Evaldt on 13/09/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit
import DatePickerDialog

class EnterpriseNewScheduleController: UIViewController {

    @IBOutlet weak var textFieldDate: UITextField!
    @IBOutlet weak var textFieldHour: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldDate.addTarget(self, action: #selector(EnterpriseNewScheduleController.dateTapped(_:)), forControlEvents: UIControlEvents.TouchDown)
        
        textFieldHour.addTarget(self, action: #selector(EnterpriseNewScheduleController.hourTapped(_:)), forControlEvents: UIControlEvents.TouchDown)
    }
    
    func dateTapped(textField: UITextField) {
        DatePickerDialog().show("Data do jogo", doneButtonTitle: "OK", cancelButtonTitle: "Cancelar", datePickerMode: .Date) {
            (date) -> Void in
            if let date = date {
               self.textFieldDate.text = "\(date)"
            }
        }
    }
    
    func hourTapped(textField: UITextField) {
        DatePickerDialog().show("Horário do jogo", doneButtonTitle: "OK", cancelButtonTitle: "Cancelar", datePickerMode: .Time) {
            (time) -> Void in
            if let time = time {
                self.textFieldHour.text = "\(time)"
            }
        }
    }
    
    @IBAction func btnClose(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
