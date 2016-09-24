//
//  PlayerGamesTvController.swift
//  kickoff
//
//  Created by Denner Evaldt on 02/09/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import NVActivityIndicatorView
import ObjectMapper
import Alamofire
import AlamofireObjectMapper
import PKHUD

class PlayerGamesTvController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    private var isLoading = Bool()
    private var gamesList: Array<Game> = Array<Game>()
    let loading: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRectMake(0.0, 0.0, 44, 44), type: .LineScale)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(PlayerGamesTvController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
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
        Alamofire.request(.GET, URLRequest.URLGamesPlayer, headers: headers)
            .validate(statusCode: 200..<300)
            .responseArray { (response: Response<[Game], NSError>) in
                let gameArray = response.result.value
                
                if let gameArray = gameArray {
                    self.gamesList = gameArray
                    
                    self.isLoading = false
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
        return gamesList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("gameCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = gamesList[indexPath.row].name
        cell.detailTextLabel?.text = gamesList[indexPath.row].schedule?.horary
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            HUD.show(.Progress)
            let id = gamesList[indexPath.row].idGame!
            
            let headers = [
                "x-access-token": KeychainManager.getToken(),
                "Accept": "application/json"
            ]
            Alamofire.request(.DELETE, URLRequest.URLGamesPlayer + "/\(id)", headers: headers)
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
            string: "Nenhum jogo marcado :(",
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
            string: "Nada de jogo? Marca um aí chama a galera!",
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
        return UIImage(named: "ball")
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
