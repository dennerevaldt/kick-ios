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

class PlayerGamesTvController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, GameDestinationViewController {
    private var isLoading = Bool()
    private var gamesList: Array<Game> = Array<Game>()
    var gameSelected:Game?
    let loc = CoreLocationHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(PlayerGamesTvController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        // Cor tabs
        self.tabBarController?.tabBar.tintColor = UIColor(red: CGFloat(76.0/255.0), green: CGFloat(175.0/255.0), blue: CGFloat(80.0/255.0), alpha: CGFloat(1.0))
        
        tableView.tableFooterView = UIView()
        self.tableView.rowHeight = 64.0
        
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
        let gameAPI = GameAPI()
        
        gameAPI.getAll(){(result, error) -> Void in
            self.isLoading = false
            self.refreshControl!.endRefreshing()
            
            if error == nil {
                self.gamesList = result
                self.tableView.reloadData()
            } else {
                self.gamesList = []
                self.tableView.reloadData()
                MessageAlert.error("Não foi possível buscar os jogos registrados, tente novamente.")
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
        let cell = tableView.dequeueReusableCellWithIdentifier("gameCell", forIndexPath: indexPath) as! GameCell
        
        cell.nameGame.text = gamesList[indexPath.row].name
        cell.dateGame.text = Util.convertDateFormater(gamesList[indexPath.row].schedule!.date!)
        cell.hourGame.text = gamesList[indexPath.row].schedule!.horary
        
        if gamesList[indexPath.row].court?.category == "Futebol society (7)" {
            cell.imageGame.image = UIImage(named: "icon_society")
        } else {
            cell.imageGame.image = UIImage(named: "icon_futsal")
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
            
            let id = self.gamesList[indexPath.row].idGame!
            
            let gameAPI = GameAPI()
            gameAPI.delete(id) { (result) -> Void in
                HUD.hide()
                if result {
                    self.gamesList.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    
                    if self.gamesList.count == 0 {
                        tableView.reloadData()
                    }
                } else {
                    MessageAlert.error("Problemas ao deletar jogo.")
                }
            }
        }
        return [delete]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        gameSelected = gamesList[indexPath.row]
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
        if segue.identifier == "segueNewGame" {
            let destination = segue.destinationViewController as! PlayerNewGameController
            destination.delegate = self
        }
    }
    
    func setNewGame() {
        self.loadList()
    }
}
