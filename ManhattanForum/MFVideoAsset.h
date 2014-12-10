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
#import <Bolts/Bolts.h>

@interface MFVideoAssetResponse : NSObject
@property (nonatomic, strong) NSURL* url;
@property (nonatomic, strong) UIImage* thumbnail;
@end

@interface MFVideoAsset : NSObject

typedef void (^MFExportCallback)(MFVideoAssetResponse *);

- (id)init:(NSURL*) url;
- (id)init:(NSURL*) url videoStart: (NSNumber*) videoStart videoEnd: (NSNumber*) videoEnd;
- (BFTask*)trim;
- (BFTask*)fixOrientation;

@end

#endif
