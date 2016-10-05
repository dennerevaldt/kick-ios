//
//  PlayerNewGameController.swift
//  kickoff
//
//  Created by Denner Evaldt on 13/09/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit
import PKHUD

protocol GameDestinationViewController {
    func setNewGame()
}

class PlayerNewGameController: UIViewController , UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, DestSetEnterpriseViewController {
    
    @IBOutlet weak var textFieldNameGame: UITextField!
    @IBOutlet weak var textFieldEntepriseCourt: UITextField!
    @IBOutlet weak var pickerViewSchedules: UIPickerView!
    
    var entepriseSelected: Enterprise?
    var scheduleSelected: Schedule?
    var pickerData: [Schedule] = []
    var delegate: GameDestinationViewController! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldNameGame.delegate = self
        textFieldEntepriseCourt.delegate = self
        pickerViewSchedules.delegate = self
        pickerViewSchedules.dataSource = self
        self.pickerViewSchedules.hidden = true
        
        self.setBackItem()
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
    
    @IBAction func btnSaveGame(sender: AnyObject) {
        if pickerData.count > 0 && scheduleSelected == nil {
            scheduleSelected = pickerData[0]
        }
        
        if self.checkInputs() {
            HUD.show(.Progress)
            let game = Game(idGame: 0, name: self.textFieldNameGame.text!, creator_id: "", schedule: scheduleSelected!, playerList: [], court: scheduleSelected!.court!)
        
            let gameAPI = GameAPI()
            gameAPI.create(game){ (result) -> Void in
                HUD.hide()
                if result {
                    self.delegate.setNewGame()
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    MessageAlert.error("Problema ao cadastrar novo jogo, tente novamente.")
                }
            }
            
        } else {
            MessageAlert.warning("Preencha os campos corretamente.")
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textFieldEntepriseCourt == textField {
            self.performSegueWithIdentifier("segueSetEnteprise", sender: self)
            return false
        }
        return true
    }
    
    // MARK: load data picker view
    
    func loadDataPickerView() -> Void {
        HUD.show(.Progress)
        let scheduleAPI = ScheduleAPI()
        scheduleAPI.getAllSchedulesByIdEnteprise((entepriseSelected?.idEnterprise)!) {(result, error) -> Void in
            HUD.hide()
            if error == nil {
                self.pickerData = result
                self.pickerViewSchedules.reloadAllComponents()
            }
            
            if self.pickerData.count == 0 {
                self.pickerViewSchedules.hidden = true
                MessageAlert.warning("Não há horários disponíveis para essa empresa, tente outra.")
            } else {
                self.pickerViewSchedules.hidden = false
            }
        }
    }
    
    // MARK: navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueSetEnteprise" {
            let navigationSearch = segue.destinationViewController as! SearchEnterpriseCourtsTvController
            navigationSearch.delegate = self
        }
    }
    
    func setCordinates(enterprise: Enterprise) {
        entepriseSelected = enterprise
        textFieldEntepriseCourt.text = entepriseSelected?.fullName
        self.loadDataPickerView()
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
    // Style row pickerView
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let label = UILabel(frame: CGRectMake(0, 0, 400, 45))
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 4
        label.text = pickerData[row].horary!+"\n"+Util.convertDateFormater(pickerData[row].date!)+"\n"+pickerData[row].court!.name!+"\n"+pickerData[row].court!.category!
        label.sizeToFit()
        return label
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 85.0
    }
    
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        scheduleSelected = pickerData[row]
    }
    
    // MARK: check inputs empty
    func checkInputs() -> Bool {
        if textFieldNameGame.text != "" && entepriseSelected != nil && scheduleSelected != nil {
            return true
        }
        return false
    }
}
