//
//  PlacesApi.swift
//  kickoff
//
//  Created by Denner Evaldt on 23/09/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit
import GoogleMaps

class PlacesApi {
    
    var placesClient: GMSPlacesClient?
    
    init() {
        placesClient = GMSPlacesClient.sharedClient()
    }
    
    func searchCityStates(searchStr:String, completion:(result: Array<Place>)->Void) {
        var arrayResult: Array<Place> = []
        
        if placesClient != nil {
            let filter = GMSAutocompleteFilter()
            filter.type = GMSPlacesAutocompleteTypeFilter.City
            filter.country = "BR"
            
            placesClient!.autocompleteQuery(searchStr, bounds: nil, filter: filter) {
                (results, error: NSError?) -> Void in
                
                if let resultWrapper = results {
                    for result in resultWrapper {
                        let place = Place()
                        place.id = result.placeID! as String
                        place.name = result.attributedFullText.string
                        arrayResult.append(place)
                    }
                    completion(result: arrayResult)
                } else {
                    arrayResult.removeAll()
                    completion(result: arrayResult)
                }
                
            }
        }
    }
    
    func getDetailsForId(placeID:String, completion:(result: GMSPlace, error: NSError?)->Void) -> Void {
        placesClient?.lookUpPlaceID(placeID, callback: { (place: GMSPlace?, error: NSError?) -> Void in
            completion(result: place!, error: error)
        })
    }
}
