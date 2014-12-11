//
//  LocationManager.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 8/27/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager? = nil
    var completionSource: BFTaskCompletionSource = BFTaskCompletionSource()
    
    func startAsync() -> BFTask {
        self.locationManager = LocationManager.generateCLLocationManager(self)
        return completionSource.task
    }
    
    private class func generateCLLocationManager(locationManagerInstance: LocationManager) -> CLLocationManager! {
        var cllocationManager = CLLocationManager()
        cllocationManager.delegate = locationManagerInstance
        cllocationManager.distanceFilter = kCLDistanceFilterNone
        cllocationManager.desiredAccuracy = kCLLocationAccuracyBest
        cllocationManager.requestWhenInUseAuthorization()
        cllocationManager.startUpdatingLocation()
        return cllocationManager
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        println("didChangeAuthorizationStatus: \(status.rawValue)")
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("## INFO: Updating location!")
        let location: CLLocation = locations.last! as CLLocation
        NSLog(location.description)
        locationManager!.stopUpdatingLocation()

        google_geocode(location)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        NSLog("Encountered an error retrieving location: \(error.code) - \(error.description)")
        locationManager!.stopUpdatingLocation()
        self.completionSource.setError(error)
    }
    
    private func google_geocode(location: CLLocation!) {
        NSLog("Retrieving reverse geocode for \(location.description)")
        GoogleGeocoder.reverse(location.coordinate, callback: { (response: GoogleGeocoderResponse) in
            switch response {
            case .Error(let error):
                NSLog(error.description)
                self.completionSource.setError(error)
            case .Response(let location):
                NSLog(location.description)
                self.completionSource.setResult(location)
            }
        })
    }
}