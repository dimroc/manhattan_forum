//
//  GoogleGeocoderWrapper.h
//  ManhattanForum
//
//  Created by Dimitri Roche on 9/14/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

#ifndef ManhattanForum_GoogleGeocoderWrapper_h
#define ManhattanForum_GoogleGeocoderWrapper_h

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface GoogleGeocoderWrapper : NSObject

+ (void)reverseGeocode:(CLLocationCoordinate2D)coordinate completionHandler: (void (^)(GMSAddress *, NSError*))callback;

@end

#endif
