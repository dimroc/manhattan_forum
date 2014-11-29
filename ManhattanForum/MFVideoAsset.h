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

@interface MFVideoAsset : NSObject

typedef void (^MFExportCallback)(AVAssetExportSession *);

- (id)init:(NSURL*) url;
- (void)fixOrientation:(MFExportCallback) callback;
@end

#endif
