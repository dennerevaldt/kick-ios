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
import CoreLocation

protocol DestSetEnterpriseViewController {
    func setCordinates(enterprise: Enterprise)
}

class SearchEnterpriseCourtsTvController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, CLLocationManagerDelegate {
    
    private var isLoading = Bool()
    var listEnterprises: Array<Enterprise> = []
    var entepriseSelected: Enterprise?
    var delegate: DestSetEnterpriseViewController! = nil
    
    var locationManager : CLLocationManager = CLLocationManager()
    var startLocation : CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HUD.show(.Progress)
        self.title = "Escolha a empresa"
        self.customizeDZNEmptyDataSet()
        self.startLocManager()
        self.tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func startLocManager() -> Void {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        startLocation = nil
    }
    
    // MARK: - Load data enteprises
    
    func loadList(lat:String, lng:String) -> Void {
        let entepriseAPI = EnterpriseAPI()
        
        entepriseAPI.getAllProximity(lat, lng: lng){ (result, error) -> Void in
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
    
    // MARK: Location
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations[locations.count - 1]
        
        if startLocation == nil{
            locationManager.stopUpdatingHeading()
            startLocation = lastLocation
            let lat = "\(lastLocation.coordinate.latitude)"
            let lng = "\(lastLocation.coordinate.longitude)"
            self.loadList(lat, lng: lng)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.localizedDescription)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .Restricted:
            // If restricted by e.g. parental controls. User can't enable Location Services
            HUD.hide()
            MessageAlert.warning("Não temos acesso a sua localização, permita nas suas configurações e tente novamente")
            break
        case .Denied:
            // If user denied your app access to Location Services, but can grant access from Settings.app
            HUD.hide()
            MessageAlert.warning("Não temos acesso a sua localização, permita nas suas configurações e tente novamente")
            break
        default:
            break
        }
    }

}
