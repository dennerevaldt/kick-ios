//
//  EnterpriseCourtsTvController.swift
//  kickoff
//
//  Created by Denner Evaldt on 04/09/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import Locksmith
import NVActivityIndicatorView
import PKHUD
import SCLAlertView

class EnterpriseCourtsTvController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, CourtDestinationViewController {
    
    private var isLoading = Bool()
    private var courtsList: Array<Court> = Array<Court>()
    var courtSelected: Court?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        customizeDZNEmptyDataSet()
        isLoading = true
        
        self.tableView.rowHeight = 65.0
        
        self.refreshControl?.addTarget(self, action: #selector(EnterpriseCourtsTvController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        // Cor tabs
        self.tabBarController?.tabBar.tintColor = UIColor(red: CGFloat(76.0/255.0), green: CGFloat(175.0/255.0), blue: CGFloat(80.0/255.0), alpha: CGFloat(1.0))
        
        self.loadList()
        setBackItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
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
        let courtAPI = CourtAPI()
        
        courtAPI.getAll(){(result, error) -> Void in
            self.isLoading = false
            self.refreshControl!.endRefreshing()
            
            if error == nil {
                self.courtsList = result
                self.tableView.reloadData()
            } else {
                self.courtsList = []
                self.tableView.reloadData()
                MessageAlert.error("Não foi possível buscar quadras registradas, tente novamente.")
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
        return courtsList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("courtCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = courtsList[indexPath.row].name
        cell.detailTextLabel?.text = courtsList[indexPath.row].category
        
        if courtsList[indexPath.row].category == "Futebol society (7)" {
            let img = Util.imageWithImage(UIImage(named: "icon_society")!, scaledToSize: CGSize(width: 45, height: 45))
            cell.imageView?.image = img
        } else {
            let img = Util.imageWithImage(UIImage(named: "icon_futsal")!, scaledToSize: CGSize(width: 45, height: 45))
            cell.imageView?.image = img
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        courtSelected = courtsList[indexPath.row]
        self.performSegueWithIdentifier("segueEditCourt", sender: self)
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .Default, title: "Excluir")
        { (action, indexPath) -> Void in
            HUD.show(.Progress)
            
            let id = self.courtsList[indexPath.row].idCourt!
            
            let courtAPI = CourtAPI()
            courtAPI.delete(id) { (result) -> Void in
                HUD.hide()
                if result {
                    self.courtsList.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    
                    if self.courtsList.count == 0 {
                        tableView.reloadData()
                    }
                } else {
                    MessageAlert.error("Problemas ao deletar quadra.")
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
            string: "Nenhuma quadra cadastrada :(",
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
            string: "Você ainda não cadastrou novas quadras!",
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
        return UIImage(named: "corner")
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
        activityIndicatorView.startAnimating()
        loadingView.addSubview(activityIndicatorView)
        return loadingView
    }
    
    // MARK: navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueNewCourt" {
            let destination = segue.destinationViewController as! EnterpriseNewCourtController
            destination.delegate = self
        }
        
        if segue.identifier == "segueEditCourt" {
            let destination = segue.destinationViewController as! EnterpriseNewCourtController
            destination.delegate = self
            destination.court = courtSelected
        }
    }
    
    // MARK: protocol court
    func setNewCourt() {
        self.loadList()
    }
}
