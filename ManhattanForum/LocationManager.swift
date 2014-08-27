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
    
    func start() {
        self.locationManager = generateLocationManager()
        self.locationManager!.startUpdatingLocation()
    }
    
    private func generateLocationManager() -> CLLocationManager! {
        var newLocationManager = CLLocationManager()
        newLocationManager.delegate = self
        newLocationManager.distanceFilter = kCLDistanceFilterNone
        newLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        return newLocationManager
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location: CLLocation = locations.last! as CLLocation
        NSLog(location.description)
        geocode(location)
        locationManager!.stopUpdatingLocation()
    }
    
    private func geocode(location: CLLocation!) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            if(error) {
                NSLog(error.description)
            } else {
                for placemark in placemarks {
                    NSLog(placemark.description)
                }
            }
        })
    }
}