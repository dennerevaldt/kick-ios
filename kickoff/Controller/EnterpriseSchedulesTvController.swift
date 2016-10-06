//
//  EnterpriseSchedulesTvController.swift
//  kickoff
//
//  Created by Denner Evaldt on 05/09/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import NVActivityIndicatorView
import ObjectMapper
import Alamofire
import AlamofireObjectMapper
import PKHUD

class EnterpriseSchedulesTvController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, ScheduleDestinationViewController {
    private var isLoading = Bool()
    private var schedulesList: Array<Schedule> = Array<Schedule>()
    var scheduleSelected:Schedule?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(EnterpriseSchedulesTvController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.tableFooterView = UIView()
        customizeDZNEmptyDataSet()
        isLoading = true
        self.loadList()
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
    
    func loadList() {
        let scheduleAPI = ScheduleAPI()
        
        scheduleAPI.getAll(){(result, error) -> Void in
            self.isLoading = false
            self.refreshControl!.endRefreshing()
            
            if error == nil {
                self.schedulesList = result
                self.tableView.reloadData()
            } else {
                self.schedulesList = []
                self.tableView.reloadData()
                MessageAlert.error("Não foi possível buscar os horários registrados, tente novamente.")
            }
        }
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.loadList();
    }
    
    func customizeDZNEmptyDataSet() {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedulesList.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        scheduleSelected = schedulesList[indexPath.row]
        self.performSegueWithIdentifier("segueEditSchedule", sender: self)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

//        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("scheduleCell", forIndexPath: indexPath)
//        
//        cell.textLabel?.text = Util.convertDateFormater(schedulesList[indexPath.row].date!)
//        cell.detailTextLabel?.text = schedulesList[indexPath.row].horary
        let cell = tableView.dequeueReusableCellWithIdentifier("scheduleCell", forIndexPath: indexPath) as! ScheduleCell
        
        cell.dateSchedule.text = Util.convertDateFormater(schedulesList[indexPath.row].date!)
        cell.horarySchedule.text = schedulesList[indexPath.row].horary
        cell.nameCourtSchedule.text = schedulesList[indexPath.row].court!.name
        
        if schedulesList[indexPath.row].court?.category == "Futebol society (7)" {
            cell.imageSchedule.image = UIImage(named: "icon_society")
        } else {
            cell.imageSchedule.image = UIImage(named: "icon_futsal")
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .Default, title: "Excluir")
        { (action, indexPath) -> Void in
            HUD.show(.Progress)
            
            let id = self.schedulesList[indexPath.row].idSchedule!
            
            let scheduleAPI = ScheduleAPI()
            scheduleAPI.delete(id) { (result) -> Void in
                HUD.hide()
                if result {
                    self.schedulesList.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    
                    if self.schedulesList.count == 0 {
                        tableView.reloadData()
                    }
                } else {
                    MessageAlert.error("Problemas ao deletar horário.")
                }
            }
        }
        return [delete]
    }
    
    // MARK: DZNEmptyDataSetSource Methods
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        if isLoading {
            return nil
        }
        let attrString = NSAttributedString(
            string: "Nenhum horário disponível :(",
            attributes: [
                NSFontAttributeName: UIFont.boldSystemFontOfSize(17.0)
            ]
        )
        return attrString
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        if isLoading {
            return nil
        }
        let attrString = NSAttributedString (
            string: "Você ainda não cadastrou novos horários!",
            attributes: [
                NSFontAttributeName: UIFont.systemFontOfSize(12.0)
            ]
        )
        return attrString
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        if isLoading {
            return nil
        }
        return UIImage(named: "clock")
    }
    
    func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor! {
        return UIColor.whiteColor()
    }
    
    func offsetForEmptyDataSet(scrollView: UIScrollView!) -> CGPoint {
        return CGPoint.zero
    }
    
    func customViewForEmptyDataSet(scrollView: UIScrollView!) -> UIView! {
        if isLoading {
            return addActivityIndicatorView()
        }
        return nil
    }
    
    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    // MARK: ActivityIndicatorView Methods
    func addActivityIndicatorView() -> UIView {
        let size: CGFloat = 64
        let x = (self.view.bounds.width - size) / 2
        let y: CGFloat = 0
        let loadingView = UIView(frame: CGRect(x: x, y: y, width: size, height: size))
        let activityIndicatorView = NVActivityIndicatorView(frame: loadingView.frame, type: .LineScale)
        activityIndicatorView.center = loadingView.center
        activityIndicatorView.color = UIColor.darkGrayColor()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.startAnimating()
        loadingView.addSubview(activityIndicatorView)
        return loadingView
    }
    
    // MARK: navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueNewSchedule" {
            let destination = segue.destinationViewController as! EnterpriseNewScheduleController
            destination.delegate = self
        }
        
        if segue.identifier == "segueEditSchedule" {
            let destination = segue.destinationViewController as! EnterpriseNewScheduleController
            destination.delegate = self
            destination.schedule = scheduleSelected
        }
    }
    
    // MARK: protocol schedule
    func setNewSchedule() {
        self.loadList()
    }
}
