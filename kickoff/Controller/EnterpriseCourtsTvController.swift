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
import ObjectMapper
import Alamofire
import AlamofireObjectMapper
import PKHUD

class EnterpriseCourtsTvController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    private var isLoading = Bool()
    private var courtsList: Array<Court> = Array<Court>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(EnterpriseCourtsTvController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        // Cor tabs
        self.tabBarController?.tabBar.tintColor = UIColor(red: CGFloat(76.0/255.0), green: CGFloat(175.0/255.0), blue: CGFloat(80.0/255.0), alpha: CGFloat(1.0))
        
        
        tableView.tableFooterView = UIView()
        customizeDZNEmptyDataSet()
        isLoading = true
        self.loadList()
    }
    
    func loadList() {
        let headers = [
            "x-access-token": KeychainManager.getToken(),
            "Accept": "application/json"
        ]
        Alamofire.request(.GET, URLRequest.URLCourtsEnterprise, headers: headers)
            .validate(statusCode: 200..<300)
            .responseArray { (response: Response<[Court], NSError>) in
                let courtArray = response.result.value
                
                if let courtArray = courtArray {
                    self.courtsList = courtArray
                    
                    self.isLoading = true
                    self.tableView.reloadData()
                    self.refreshControl!.endRefreshing()
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
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            HUD.show(.Progress)
            let id = courtsList[indexPath.row].idCourt!
            
            let headers = [
                "x-access-token": KeychainManager.getToken(),
                "Accept": "application/json"
            ]
            Alamofire.request(.DELETE, URLRequest.URLCourtsEnterprise + "/\(id)", headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    HUD.hide()
                    switch response.result {
                    case .Success:
                        self.loadList()
                    case .Failure(let error):
                        print(error)
                    }
            }
        }
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
        let size: CGFloat = 44
        let x = (self.view.bounds.width - size) / 2
        let y: CGFloat = 0
        let loadingView = UIView(frame: CGRect(x: x, y: y, width: size, height: size))
        let activityIndicatorView = NVActivityIndicatorView(frame: loadingView.frame, type: .LineScale)
        activityIndicatorView.center = loadingView.center
        activityIndicatorView.color = UIColor.lightGrayColor()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.startAnimating()
        loadingView.addSubview(activityIndicatorView)
        return loadingView
    }
}
