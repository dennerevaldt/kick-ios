//
//  EnterpriseNewScheduleController.swift
//  kickoff
//
//  Created by Denner Evaldt on 13/09/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit
import DatePickerDialog
import PKHUD

protocol ScheduleDestinationViewController {
    func setNewSchedule()
}

class EnterpriseNewScheduleController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var textFieldDate: UITextField!
    @IBOutlet weak var textFieldHour: UITextField!
    @IBOutlet weak var uiPickerCourts: UIPickerView!
    
    let datePickerDialog: DatePickerDialog = DatePickerDialog()
    var pickerCourtData: Array<Court> = []
    var delegate: ScheduleDestinationViewController! = nil
    var courtSelected: Court?
    var schedule: Schedule?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.uiPickerCourts.dataSource = self
        self.uiPickerCourts.delegate = self
        
        if let scheduleWrapper = schedule {
            self.textFieldDate.text = scheduleWrapper.date!
            self.textFieldHour.text = scheduleWrapper.horary!
            self.title = "Editar quadra"
        } else {
            self.title = "Nova quadra"
        }
        
        self.setEventsFields()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.loadDataPicker()
    }
    
    func setEventsFields() -> Void {
        textFieldDate.addTarget(self, action: #selector(EnterpriseNewScheduleController.dateTapped(_:)), forControlEvents: UIControlEvents.TouchDown)
        
        textFieldHour.addTarget(self, action: #selector(EnterpriseNewScheduleController.hourTapped(_:)), forControlEvents: UIControlEvents.TouchDown)
    }
    
    func loadDataPicker() {
        HUD.show(.Progress)
        let courtAPI = CourtAPI()
        courtAPI.getAll(){(result, error) -> Void in
            HUD.hide()
            if error == nil {
                self.pickerCourtData = result
                self.uiPickerCourts.reloadAllComponents()
            } else {
                MessageAlert.error("Não foi posseivel carregar as quadras cadastradas, tente novamente.")
            }
        }
    }
    
    func dateTapped(textField: UITextField) {
        datePickerDialog.show("Data do jogo", doneButtonTitle: "OK", cancelButtonTitle: "Cancelar", datePickerMode: .Date) {
            (date) -> Void in
            if let dateWrapper = date {
               self.textFieldDate.text = Util.convertDateFormater(dateWrapper)
            }
        }
    }
    
    func hourTapped(textField: UITextField) {
        datePickerDialog.show("Horário do jogo", doneButtonTitle: "OK", cancelButtonTitle: "Cancelar", datePickerMode: .Time) {
            (time) -> Void in
            if let time = time {
                self.textFieldHour.text = Util.convertHourFormater(time)
            }
        }
    }
    
    // MARK: - picker functions
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerCourtData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerCourtData[row].name
    }
    
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        courtSelected = pickerCourtData[row]
    }
    
    // MARK: schedule actions buttons
    @IBAction func btnSaveSchedule(sender: AnyObject) {
        if let court = courtSelected {
            courtSelected = court
        } else {
            courtSelected = pickerCourtData[0]
        }
        let dateFormat = Util.getDateFormatMysql(self.textFieldDate.text!)
        
        let schedule = Schedule(idSchedule: 0, horary: self.textFieldHour.text!, date: dateFormat, court: courtSelected!)
        let scheduleAPI = ScheduleAPI()
        scheduleAPI.create(schedule){(result) -> Void in
            if result {
                self.delegate.setNewSchedule()
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                MessageAlert.error("Problema ao cadastrar nova quadra, tente novamente.")
            }
        }
    }
}
