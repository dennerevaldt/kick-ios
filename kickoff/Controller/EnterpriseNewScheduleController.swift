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
    
    var pickerCourtData: Array<Court> = []
    var delegate: ScheduleDestinationViewController! = nil
    var courtSelected: Court?
    var schedule: Schedule?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.uiPickerCourts.dataSource = self
        self.uiPickerCourts.delegate = self
        
        if let scheduleWrapper = schedule {
            self.textFieldDate.text = Util.convertDateFormater(scheduleWrapper.date!)
            self.textFieldHour.text = scheduleWrapper.horary!
            self.title = "Editar horário"
        } else {
            self.title = "Novo horário"
        }
        
        self.setEventsFields()
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
                if result.count == 0 {
                    MessageAlert.warning("Você ainda não possui quadras cadastradas, insira ao menos uma e tente novamente.")
                    self.navigationController?.popViewControllerAnimated(true)
                }
                
                self.pickerCourtData = result
                self.uiPickerCourts.reloadAllComponents()
                
                if self.schedule != nil && self.pickerCourtData.count > 0 {
                    for (index,_) in self.pickerCourtData.enumerate() {
                        if self.pickerCourtData[index].idCourt == self.schedule?.court?.idCourt {
                            self.uiPickerCourts.selectRow(index, inComponent: 0, animated: true)
                        }
                    }
                }
            } else {
                MessageAlert.error("Não foi possível carregar as quadras cadastradas, tente novamente.")
            }
        }
    }
    
    func dateTapped(textField: UITextField) {
        DatePickerDialog().show("Data do jogo", doneButtonTitle: "OK", cancelButtonTitle: "Cancelar", datePickerMode: .Date) {
            (date) -> Void in
            if let dateWrapper = date {
               self.textFieldDate.text = Util.convertDateFormater(dateWrapper)
            }
        }
    }
    
    func hourTapped(textField: UITextField) {
        DatePickerDialog().show("Horário do jogo", doneButtonTitle: "OK", cancelButtonTitle: "Cancelar", datePickerMode: .Time) {
            (time) -> Void in
            if let time = time {
                let formatter = NSDateFormatter()
                formatter.dateFormat = "HH:mm"
                
                self.textFieldHour.text = "\(formatter.stringFromDate(time))"
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
        HUD.show(.Progress)
        
        if let court = courtSelected {
            courtSelected = court
        } else {
            if pickerCourtData.count > 0 {
                courtSelected = pickerCourtData[0]
            }
        }
        
        let dateFormat = Util.getDateFormatMysql(self.textFieldDate.text!)
        
        if self.schedule == nil {
            let schedule = Schedule(idSchedule: 0, horary: self.textFieldHour.text!, date: dateFormat, court: courtSelected!)
            let scheduleAPI = ScheduleAPI()
            scheduleAPI.create(schedule){(result) -> Void in
                HUD.hide()
                if result {
                    self.delegate.setNewSchedule()
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    MessageAlert.error("Problema ao cadastrar nova quadra, tente novamente.")
                }
            }
        } else {
            let schedule = Schedule(idSchedule: self.schedule!.idSchedule!, horary: self.textFieldHour.text!, date: dateFormat, court: courtSelected!)
            let scheduleAPI = ScheduleAPI()
            scheduleAPI.edit(schedule){(result) -> Void in
                HUD.hide()
                if result {
                    self.delegate.setNewSchedule()
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    MessageAlert.error("Problema ao editar quadra, tente novamente.")
                }
            }
        }
    }
}
