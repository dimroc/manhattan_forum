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
        google_geocode(location)
        locationManager!.stopUpdatingLocation()
    }
    
    private func google_geocode(location: CLLocation!) {
        GoogleGeocoder.reverse(location.coordinate, callback: { (response: GoogleGeocoderResponse) in
            switch response {
            case .Error(let error):
                NSLog(error.description)
            case .Response(let location):
                NSLog(location.description)
            }
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