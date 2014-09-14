//
//  GoogleGeocoderWrapper.m
//  ManhattanForum
//
//  Created by Dimitri Roche on 9/14/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoogleGeocoderWrapper.h"

@implementation GoogleGeocoderWrapper

+ (void)reverseGeocode:(CLLocationCoordinate2D)coordinate completionHandler: (void (^)(GMSAddress *, NSError*))callback {
    NSLog(@"%f", coordinate.latitude);

    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:coordinate completionHandler:^(GMSReverseGeocodeResponse * response, NSError *error) {
        GMSAddress *addressObj = response.firstResult;
        
        NSLog(@"coordinate.latitude=%f", addressObj.coordinate.latitude);
        NSLog(@"coordinate.longitude=%f", addressObj.coordinate.longitude);
        NSLog(@"thoroughfare=%@", addressObj.thoroughfare);
        NSLog(@"locality=%@", addressObj.locality);
        NSLog(@"subLocality=%@", addressObj.subLocality);
        NSLog(@"administrativeArea=%@", addressObj.administrativeArea);
        NSLog(@"postalCode=%@", addressObj.postalCode);
        NSLog(@"country=%@", addressObj.country);
        NSLog(@"lines=%@", addressObj.lines);
        
        callback(response.firstResult, error);
    }];
    
//    reverseGeocodeCoordinate(location.coordinate, completionHandler: { (response, error) in
//        NSLog(response!.description)
//        let address = response!.firstResult
//        NSLog("Got the address")
//    })
}

@end