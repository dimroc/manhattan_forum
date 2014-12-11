//
//  MFLocation.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 9/15/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

import Foundation
import CoreLocation

class MFLocation: Printable, DebugPrintable, Equatable {
    let neighborhood, sublocality, locality: String?
    let coordinate: CLLocationCoordinate2D?
    
    init(neighborhood: String?, sublocality: String?, locality: String?, coordinate: CLLocationCoordinate2D?) {
        self.neighborhood = neighborhood
        self.sublocality = sublocality
        self.locality = locality
        self.coordinate = coordinate
    }
    
    var description: String {
        switch (neighborhood, sublocality) {
        case (.Some, _):
            return neighborhood!
        case (.None, .Some):
            return sublocality!
        default:
            return "Unknown"
        }
    }
    
    var debugDescription: String {
        return "\(neighborhood), \(sublocality), \(locality) at \(coordinate?.latitude), \(coordinate?.longitude)"
    }
    
    class func empty() -> MFLocation {
        return MFLocation(neighborhood: nil, sublocality: nil, locality: nil, coordinate: nil)
    }
    
    // JSON Parsing in Swift: http://robots.thoughtbot.com/efficient-json-in-swift-with-functional-concepts-and-generics
    class func fromGoogleJson(json: Dictionary<String, AnyObject>) -> MFLocation {
        if let results: AnyObject? = json["results"] as? NSArray {
            if let result: AnyObject? = results?[0] {
//                println("## DEBUG: Parsing through:\n\(result)")
                if let addressComponents: AnyObject? = result?["address_components"] {
                    return MFLocation(
                        neighborhood: fromAddressComponents(addressComponents!, type: "neighborhood"),
                        sublocality: fromAddressComponents(addressComponents!, type: "sublocality"),
                        locality: fromAddressComponents(addressComponents!, type: "locality"),
                        coordinate: coordinateFromResult(result!)
                    )
                }
            }
        }
        
        return MFLocation.empty()
    }
    
    private class func coordinateFromResult(result: AnyObject) -> CLLocationCoordinate2D? {
        if let geometry: AnyObject? = result["geometry"] {
            if let location: AnyObject? = geometry?["location"] {
                if let lat: AnyObject? = location?["lat"] {
                    if let lng: AnyObject? = location?["lng"] {
                        return CLLocationCoordinate2D(latitude: lat! as CLLocationDegrees, longitude: lng! as CLLocationDegrees)
                    }
                }
            }
        }

        return nil
    }
    
    private class func fromAddressComponents(addressComponents: AnyObject, type: String) -> String? {
        let array = addressComponents as Array<Dictionary<String, AnyObject>>
        for addressComponent in array {
            let types: AnyObject? = addressComponent["types"]
            let typeArray = types as Array<String>
            if let presence = find(typeArray, type) {
                let long_name: AnyObject? = addressComponent["long_name"]
                return long_name as? String
            }
        }
        
        return nil
    }
}

func == (lhs: MFLocation, rhs: MFLocation) -> Bool {
    if lhs.neighborhood == rhs.neighborhood && lhs.sublocality == rhs.sublocality && lhs.locality == rhs.locality {
        return lhs.coordinate?.latitude == rhs.coordinate?.latitude && lhs.coordinate?.longitude == rhs.coordinate?.longitude
    }
    
    return false
}