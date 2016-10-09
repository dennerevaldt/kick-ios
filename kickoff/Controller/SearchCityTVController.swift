//
//  SearchCityTVController.swift
//  kickoff
//
//  Created by Denner Evaldt on 23/09/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import NVActivityIndicatorView
import SCLAlertView
import GoogleMaps

protocol DestinationViewController {
    func setCordinates(placeSelected:GMSPlace)
}

class SearchCityTVController: UITableViewController, UISearchBarDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    var places: Array<Place> = []
    let placesApi = PlacesApi()
    private var isLoading = Bool()
    
    @IBOutlet weak var searchBar: UISearchBar!
    var delegate: DestinationViewController! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.title = "Pesquisar"
        self.tableView.tableFooterView = UIView()
        
        searchBar.delegate = self
        customizeDZNEmptyDataSet()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: DZ empty data set
    func customizeDZNEmptyDataSet() {
        tableView.tableFooterView = UIView()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
    
    // MARK: DZNEmptyDataSetSource Methods
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        if isLoading {
            return nil
        }
        let attrString = NSAttributedString(
            string: "Não encontrou seu local?",
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
            string: "Pesquise novamente!",
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
    
    // MARK: search bar
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        placeAutocomplete(searchText)
    }
    
    // MARK: autocomplete city/state
    
    func placeAutocomplete(nameSearch: String) {
        isLoading = true
        placesApi.searchCityStates(nameSearch) {(result) -> Void in
            self.isLoading = false
            self.places = result
            self.tableView.reloadData()
        }
        
    }
    
    func getCordinates(placeID:String) {
        placesApi.getDetailsForId(placeID) {(result, error) -> Void in
            if error == nil {
                self.delegate.setCordinates(result)
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                SCLAlertView().showTitle(
                    "Ops",
                    subTitle: "Não foi possível encontrar sua localização, tente novamente.",
                    duration: nil,
                    completeText: "OK",
                    style: .Error,
                    colorStyle: nil,
                    colorTextButton: nil
                )
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellCityState", forIndexPath: indexPath)
        cell.textLabel?.text = self.places[indexPath.row].name

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedPlace = self.places[indexPath.row]
        getCordinates(selectedPlace.id!)
    }

}
