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
    typealias Callback = (GoogleGeocoderResponse) -> Void

    var locationManager: CLLocationManager? = nil
    var callback: Callback
    
    init(callback: Callback) {
        self.callback = callback
    }
    
    class func start(callback: Callback) -> LocationManager {
        var locationManager = LocationManager(callback)
        locationManager.locationManager = generateCLLocationManager(locationManager)
        locationManager.locationManager!.requestWhenInUseAuthorization()
        locationManager.locationManager!.startUpdatingLocation()
        return locationManager
    }
    
    private class func generateCLLocationManager(locationManagerInstance: LocationManager) -> CLLocationManager! {
        var cllocationManager = CLLocationManager()
        cllocationManager.delegate = locationManagerInstance
        cllocationManager.distanceFilter = kCLDistanceFilterNone
        cllocationManager.desiredAccuracy = kCLLocationAccuracyBest
        return cllocationManager
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("## INFO: Updating location!")
        let location: CLLocation = locations.last! as CLLocation
        NSLog(location.description)
        google_geocode(location)
        locationManager!.stopUpdatingLocation()
    }
    
    private func google_geocode(location: CLLocation!) {
        NSLog("Retrieving reverse geocode for \(location.description)")
        GoogleGeocoder.reverse(location.coordinate, callback: { (response: GoogleGeocoderResponse) in
            switch response {
            case .Error(let error):
                NSLog(error.description)
            case .Response(let location):
                NSLog(location.description)
            }
            
            self.callback(response)
        })
    }
    
    private func geocode(location: CLLocation!) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            if((error) != nil) {
                NSLog(error.description)
            } else {
                for placemark in placemarks {
                    NSLog("## INFO: Location \(placemark.description) is in the neighborhood \(placemark.subLocality), \(placemark.locality)")
                }
            }
        })
    }
}