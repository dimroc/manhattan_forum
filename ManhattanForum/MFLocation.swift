//
//  MFLocation.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 9/15/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

import Foundation
import CoreLocation

struct MFLocation: Printable, DebugPrintable {
    let neighborhood, sublocality, locality: String?
    let coordinate: CLLocationCoordinate2D?
    
    var description: String {
        return "\(neighborhood), \(sublocality)"
    }
    
    var debugDescription: String {
        return "\(neighborhood), \(sublocality), \(locality) at \(coordinate?.latitude), \(coordinate?.longitude)"
    }
    
    static func empty() -> MFLocation {
        return MFLocation(neighborhood: "", sublocality: "", locality: "", coordinate: nil)
    }
    
    // JSON Parsing in Swift: http://robots.thoughtbot.com/efficient-json-in-swift-with-functional-concepts-and-generics
    static func fromGoogleJson(json: Dictionary<String, AnyObject>) -> MFLocation {
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
    
    private static func coordinateFromResult(result: AnyObject) -> CLLocationCoordinate2D? {
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
    
    private static func fromAddressComponents(addressComponents: AnyObject, type: String) -> String? {
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