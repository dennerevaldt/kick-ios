//
//  SearchCityTVController.swift
//  kickoff
//
//  Created by Denner Evaldt on 23/09/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit
import GoogleMaps

protocol DestinationViewController {
    func setCordinates(placeSelected:GMSPlace)
}

class SearchCityTVController: UITableViewController, UISearchBarDelegate {
    var places: Array<Place> = []
    let placesApi = PlacesApi()
    
    @IBOutlet weak var searchBar: UISearchBar!
    var delegate: DestinationViewController! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.title = "Pesquisar"
        
        searchBar.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: search bar
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        placeAutocomplete(searchText)
    }
    
    // MARK: autocomplete city/state
    
    func placeAutocomplete(nameSearch: String) {
        placesApi.searchCityStates(nameSearch) {(result) -> Void in
            self.places = result
            self.tableView.reloadData()
        }
        
    }
    
    func getCordinates(placeID:String) {
        placesApi.getDetailsForId(placeID) {(result) -> Void in
            self.delegate.setCordinates(result)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellCityState", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = self.places[indexPath.row].name

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedPlace = self.places[indexPath.row]
        getCordinates(selectedPlace.id!)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
