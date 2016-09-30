//
//  SearchEnterpriseCourtsTvController.swift
//  kickoff
//
//  Created by Denner Evaldt on 30/09/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import NVActivityIndicatorView
import PKHUD

protocol DestSetEnterpriseViewController {
    func setCordinates(enterprise: Enterprise)
}

class SearchEnterpriseCourtsTvController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    let loading: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRectMake(0.0, 0.0, 44, 44), type: .LineScale)
    private var isLoading = Bool()
    var listEnterprises: Array<Enterprise> = []
    var entepriseSelected: Enterprise?
    var delegate: DestSetEnterpriseViewController! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Escolha a empresa"
        self.customizeDZNEmptyDataSet()
        self.loadList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Load data enteprises
    
    func loadList() -> Void {
        HUD.show(.Progress)
        let entepriseAPI = EnterpriseAPI()
        
        entepriseAPI.getAllProximity("-29.4529001", lng: "-49.9387414"){ (result, error) -> Void in
            HUD.hide()
            if error == nil {
                self.listEnterprises = result
                self.tableView.reloadData()
            } else {
                self.listEnterprises = []
                self.tableView.reloadData()
                MessageAlert.error("Não foi possível buscar empresas registradas, tente novamente.")
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listEnterprises.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellEnteprise", forIndexPath: indexPath)

        cell.textLabel?.text = listEnterprises[indexPath.row].fullName
        cell.detailTextLabel?.text = listEnterprises[indexPath.row].district

        return cell
    }
 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        entepriseSelected = listEnterprises[indexPath.row]
        self.delegate.setCordinates(entepriseSelected!)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: DZ empty data set
    func customizeDZNEmptyDataSet() {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
    
    // MARK: DZNEmptyDataSetSource Methods
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        if isLoading {
            return nil
        }
        let attrString = NSAttributedString(
            string: "Não encontramos empresas próximas.",
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
            string: "Tente novamente mais tarde!",
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
        return UIImage(named: "ic_sad")
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
        loading.color = UIColor.grayColor()
        loading.center = self.view.center
        self.view.addSubview(loading)
        loading.bringSubviewToFront(self.view)
        loading.startAnimating()
        
        return loading
    }

}
