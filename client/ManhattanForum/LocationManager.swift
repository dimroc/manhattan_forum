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

        // The location manager can invoke this delegate method multiple times
        // before stopUpdatingLocation() takes effect.
        // This is why we invoke completionsource.trySet... at the end of each delegate.
        google_geocode(location)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        NSLog("Encountered an error retrieving location: \(error.code) - \(error.description)")
        locationManager!.stopUpdatingLocation()
        self.completionSource.trySetError(error)
    }
    
    private func google_geocode(cllocation: CLLocation!) {
        NSLog("Retrieving reverse geocode for \(cllocation.description)")
        GoogleGeocoder.reverse(cllocation.coordinate).continueWithBlock { (task: BFTask!) -> AnyObject! in
            if(task.success) {
                let location = task.result as MFLocation!
                NSLog(location.description)
                if (location.valid) {
                    self.completionSource.trySetResult(location)
                } else {
                    let details = [NSLocalizedDescriptionKey: "Unable to find a valid location with neighborhood, sublocality, and locality."]
                    let error = NSError(domain: "locationmanager.geocode.google.manhattanforum.com", code: 0, userInfo: details)
                    self.completionSource.trySetError(error)
                }
                
            } else {
                NSLog(task.error.description)
                self.completionSource.trySetError(task.error)
            }
            
            return nil
        }
    }
}