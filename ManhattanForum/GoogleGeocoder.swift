//
//  GoogleGeocoder.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 9/14/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

import Foundation
import CoreLocation

enum GoogleGeocoderResponse {
    case Response(MFLocation)
    case Error(NSError)
}

class GoogleGeocoder {
    class func reverse(coordinate: CLLocationCoordinate2D!, callback: (GoogleGeocoderResponse) -> Void) {
        GoogleGeocoder().reverse(coordinate, callback: callback)
    }

    func reverse(coordinate: CLLocationCoordinate2D!, callback: (GoogleGeocoderResponse) -> Void) {
        let manager = AFHTTPRequestOperationManager()
        let parameters = generateParameters(coordinate)
        
        manager.GET(baseUrl(), parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response) in
            let location = GoogleGeocoder.fromResponse(response!)
            println("Retrieved location:\n\(location.debugDescription)")
            callback(GoogleGeocoderResponse.Response(location))
        }) { (operation, error) in
            callback(GoogleGeocoderResponse.Error(error))
        }
    }
    
    class func fromResponse(response: AnyObject?) -> MFLocation {
        return MFLocation.fromGoogleJson(response as Dictionary<String, AnyObject>)
    }
    
    private func generateParameters(coordinate: CLLocationCoordinate2D) -> NSDictionary {
        let coordinateString = "\(coordinate.latitude),\(coordinate.longitude)"
        return NSDictionary(objectsAndKeys: coordinateString, "latlng", key(), "key")
    }
    
    private func baseUrl() -> String {
        return "https://maps.googleapis.com/maps/api/geocode/json"
    }
    
    private func key() -> String {
        return Credentials.objectForKey("GoogleApiKey")
    }
}