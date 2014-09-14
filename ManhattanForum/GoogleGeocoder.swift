//
//  GoogleGeocoder.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 9/14/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

import Foundation

class GoogleGeocoder {
    class func reverse(coordinate: CLLocationCoordinate2D!) {
        GoogleGeocoder().reverse(coordinate)
    }
    
    func reverse(coordinate: CLLocationCoordinate2D!) {
        let manager = AFHTTPRequestOperationManager()
        let parameters = generateParameters(coordinate)
        manager.GET(baseUrl(), parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response) in
            NSLog(response!.description)
        }) { (operation, error) in
            NSLog(error.description)
        }
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