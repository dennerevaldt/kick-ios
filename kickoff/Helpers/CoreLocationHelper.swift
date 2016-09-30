//
//  CoreLocationHelper.swift
//  kickoff
//
//  Created by Denner Evaldt on 29/09/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit
import CoreLocation

class CoreLocationHelper: NSObject, CLLocationManagerDelegate {
    
    var locationManager : CLLocationManager = CLLocationManager()
    var startLocation : CLLocation!
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        startLocation = nil
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations[locations.count - 1]
        
        if startLocation == nil{
            startLocation = lastLocation
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.localizedDescription)
    }
    
    func calculateLocation(latitude : Double, longitude : Double) -> Double?{
        
        if startLocation != nil{
            let newCoordinate = CLLocation(latitude: latitude, longitude: longitude)
            let coordinate : CLLocationDistance = startLocation.distanceFromLocation(newCoordinate)
            
            let metrics = coordinate.description
            
            let separated = metrics.componentsSeparatedByString(".")
            
            return Double(separated[0])
        }
        return nil
    }
    
    
    
}


