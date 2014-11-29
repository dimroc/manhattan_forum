//
//  MFVideoAsset.m
//  ManhattanForum
//
//  Created by Dimitri Roche on 11/28/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFVideoAsset.h"

@implementation MFVideoAssetResponse
@end

@interface MFVideoAsset ()
@property (nonatomic, strong) NSURL *url;
@end

@implementation MFVideoAsset

- (id)init:(NSURL*) url {
    self = [super init];
    if (self) {
        self.url = url;
    }
    
    return self;
}

// Modified from this StackOverflow Gobbly Gook:
// http://stackoverflow.com/questions/19966766/ios-uiimagepickercontroller-result-video-orientation-after-upload
- (void)fixOrientation:(MFExportCallback) callback {
    AVAsset *firstAsset = [AVAsset assetWithURL:[self url]];
    if(firstAsset !=nil && [[firstAsset tracksWithMediaType:AVMediaTypeVideo] count]>0){
        //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
        AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
        
        //VIDEO TRACK
        AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, firstAsset.duration);
        
        if ([[firstAsset tracksWithMediaType:AVMediaTypeAudio] count]>0) {
            //AUDIO TRACK
            AVMutableCompositionTrack *firstAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            [firstAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        }else{
            NSLog(@"warning: video has no audio");
        }
        
        //FIXING ORIENTATION//
        AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
        
        AVAssetTrack *FirstAssetTrack = [[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        
        UIImageOrientation FirstAssetOrientation_  = UIImageOrientationUp;
        
        BOOL  isFirstAssetPortrait_  = NO;
        
        CGAffineTransform firstTransform = FirstAssetTrack.preferredTransform;
        
        if(firstTransform.a == 0 && firstTransform.b == 1.0 && firstTransform.c == -1.0 && firstTransform.d == 0)
        {
            FirstAssetOrientation_= UIImageOrientationRight; isFirstAssetPortrait_ = YES;
        }
        if(firstTransform.a == 0 && firstTransform.b == -1.0 && firstTransform.c == 1.0 && firstTransform.d == 0)
        {
            FirstAssetOrientation_ =  UIImageOrientationLeft; isFirstAssetPortrait_ = YES;
        }
        if(firstTransform.a == 1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == 1.0)
        {
            FirstAssetOrientation_ =  UIImageOrientationUp;
        }
        if(firstTransform.a == -1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == -1.0)
        {
            FirstAssetOrientation_ = UIImageOrientationDown;
        }

        NSLog(@"Original Assets Dimensions. width: %f height: %f", FirstAssetTrack.naturalSize.width, FirstAssetTrack.naturalSize.height);
        CGFloat FirstAssetScaleToFitRatio = 320.0/FirstAssetTrack.naturalSize.width;
        
        if(isFirstAssetPortrait_)
        {
            FirstAssetScaleToFitRatio = 320.0/FirstAssetTrack.naturalSize.height;
            CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
            [FirstlayerInstruction setTransform:CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor) atTime:kCMTimeZero];
        }
        else
        {
            CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
            [FirstlayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor),CGAffineTransformMakeTranslation(0, 160)) atTime:kCMTimeZero];
        }
        [FirstlayerInstruction setOpacity:0.0 atTime:firstAsset.duration];
        
        MainInstruction.layerInstructions = [NSArray arrayWithObjects:FirstlayerInstruction,nil];;
        
        AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
        mainCompositionInst.instructions = [NSArray arrayWithObject:MainInstruction];
        mainCompositionInst.frameDuration = CMTimeMake(1, 30);
        mainCompositionInst.renderSize = CGSizeMake(320.0, 427.0);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *myPathDocs = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideo-%d.mov", arc4random() % 10000]];
        
        NSURL *url = [NSURL fileURLWithPath:myPathDocs];
        
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPreset1280x720];
        
        exporter.outputURL=url;
        exporter.outputFileType = AVFileTypeMPEG4;
        exporter.videoComposition = mainCompositionInst;
        exporter.shouldOptimizeForNetworkUse = YES;
        [exporter exportAsynchronouslyWithCompletionHandler:^
         {
             [self exportDidFinish:exporter withCallback:callback];
         }];
    } else {
        NSLog(@"Error, video track not found");
    }
}

- (void)exportDidFinish:(AVAssetExportSession*)session withCallback:(MFExportCallback)callback
{
    MFVideoAssetResponse *response = [[MFVideoAssetResponse alloc] init];

    if(session.status == AVAssetExportSessionStatusCompleted) {
        response.thumbnail = [self generateThumbnail];
        response.url = session.outputURL;
        response.success = true;
    } else {
        NSLog(@"## error fixing orientation. Session.status: %ld", session.status);
        response.error = session.error;
        response.success = false;
    }
    
    callback(response);
}

- (UIImage*) generateThumbnail {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL: self.url options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}

@end