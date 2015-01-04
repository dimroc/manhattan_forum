//
//  GoogleGeocoder.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 9/14/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

import Foundation
import CoreLocation

class GoogleGeocoder {
    class func reverse(coordinate: CLLocationCoordinate2D!) -> BFTask! {
        return GoogleGeocoder().reverse(coordinate)
    }

    func reverse(coordinate: CLLocationCoordinate2D!) -> BFTask! {
        let manager = AFHTTPRequestOperationManager()
        let parameters = generateParameters(coordinate)
        let completionSource = BFTaskCompletionSource()

        manager.GET(baseUrl(), parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response) in
            let location = GoogleGeocoder.fromResponse(response!)
            DDLogHelper.debug("Retrieved location:\n\(location.debugDescription)")
            completionSource.setResult(location)
        }) { (operation, error) in
            completionSource.setError(error)
        }
        
        return completionSource.task
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