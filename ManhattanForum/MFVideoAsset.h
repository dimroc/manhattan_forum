//
//  MFVideoAsset.h
//  ManhattanForum
//
//  Created by Dimitri Roche on 11/28/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

#ifndef ManhattanForum_MFVideoAsset_h
#define ManhattanForum_MFVideoAsset_h

#import <AVFoundation/AVFoundation.h>

@interface MFVideoAssetResponse : NSObject
@property (nonatomic, strong) NSURL* url;
@property (nonatomic, strong) UIImage* thumbnail;
@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) NSError* error;
@end

@interface MFVideoAsset : NSObject

typedef void (^MFExportCallback)(MFVideoAssetResponse *);

- (id)init:(NSURL*) url;
- (void)fixOrientation:(MFExportCallback) callback;

@end

#endif
