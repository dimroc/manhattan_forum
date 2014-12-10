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

@interface MFVideoAsset : NSObject

@property (readonly, nonatomic, strong) NSURL *url;
@property (readonly, nonatomic, strong) UIImage *thumbnail;

- (id)init:(NSURL*) url;
- (BFTask*)trim:(NSNumber*) videoStart until:(NSNumber*) videoEnd;
- (BFTask*)fixOrientation;
- (BFTask*)generateThumbnail;
- (BFTask*)prepare:(NSNumber*) videoStart until:(NSNumber*) videoEnd;
- (BFTask*)prepare;

@end

#endif
