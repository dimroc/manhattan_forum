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
#import "UIImage+Crop.h"

@implementation MFVideoAssetResponse
@end

@interface MFVideoAsset ()
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSNumber *videoStart;
@property (nonatomic, strong) NSNumber *videoEnd;
@end

@implementation MFVideoAsset

- (id)init:(NSURL*) url {
    self = [super init];
    if (self) {
        self.url = url;
        self.videoStart = nil;
        self.videoEnd = nil;
    }
    
    return self;
}

- (id)init:(NSURL*) url videoStart: (NSNumber*) videoStart videoEnd: (NSNumber*) videoEnd {
    self = [super init];
    if (self) {
        self.url = url;
        self.videoStart = videoStart;
        self.videoEnd = videoEnd;
    }
    
    return self;
}

// Jacked from a StackOverflow post:
// http://stackoverflow.com/questions/4439707/how-to-trim-the-video-using-avfoundation/7141620#7141620
- (BFTask*)trim {
    // if start and end are nil then clipping was not used.
    // You should use the entire video.
    
    if (self.videoStart == nil) {
        return [BFTask taskWithResult: self];
    }
    
    int startMilliseconds = ([self.videoStart doubleValue] * 1000);
    int endMilliseconds = ([self.videoEnd doubleValue] * 1000);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *outputURL = [documentsDirectory stringByAppendingPathComponent:@"output"] ;
    [manager createDirectoryAtPath:outputURL withIntermediateDirectories:YES attributes:nil error:nil];
    
    outputURL = [outputURL stringByAppendingPathComponent:@"trimmed.mp4"];
    
    // Remove Existing File
    [manager removeItemAtPath:outputURL error:nil];
    
    AVURLAsset *videoAsset = [AVURLAsset URLAssetWithURL:self.url options:nil];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:videoAsset presetName:AVAssetExportPresetHighestQuality];
    exportSession.outputURL = [NSURL fileURLWithPath:outputURL];
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    CMTimeRange timeRange = CMTimeRangeMake(CMTimeMake(startMilliseconds, 1000), CMTimeMake(endMilliseconds - startMilliseconds, 1000));
    exportSession.timeRange = timeRange;
    
    BFTaskCompletionSource *completionSource = [[BFTaskCompletionSource alloc] init];
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        switch (exportSession.status) {
            case AVAssetExportSessionStatusCompleted:
            {
                MFVideoAsset *newVideoAsset = [[MFVideoAsset alloc] init:exportSession.outputURL];
                [completionSource setResult:newVideoAsset];
                break;
            }
            case AVAssetExportSessionStatusFailed:
            case AVAssetExportSessionStatusCancelled:
                [completionSource setError:exportSession.error];
                NSLog(@"Failed:%@",exportSession.error);
                break;
            default:
                [completionSource setError:exportSession.error];
                break;
        }
    }];
  
    return completionSource.task;
}

// Modified from this StackOverflow Gobbly Gook:
// http://stackoverflow.com/questions/19966766/ios-uiimagepickercontroller-result-video-orientation-after-upload
- (BFTask*)fixOrientation {
    BFTaskCompletionSource *completionSource = [[BFTaskCompletionSource alloc] init];
    AVAsset *firstAsset = [AVAsset assetWithURL:[self url]];
    if(firstAsset !=nil && [[firstAsset tracksWithMediaType:AVMediaTypeVideo] count]>0){
        //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
        AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
        
        //VIDEO TRACK
        AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        AVMutableVideoCompositionInstruction * mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, firstAsset.duration);
        
        if ([[firstAsset tracksWithMediaType:AVMediaTypeAudio] count]>0) {
            //AUDIO TRACK
            AVMutableCompositionTrack *firstAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            [firstAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        }else{
            NSLog(@"warning: video has no audio");
        }
        
        //FIXING ORIENTATION//
        AVMutableVideoCompositionLayerInstruction *firstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
        
        AVAssetTrack *firstAssetTrack = [[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        UIImageOrientation firstAssetOrientation_  = UIImageOrientationUp;
        
        BOOL  isFirstAssetPortrait_  = NO;
        
        CGAffineTransform firstTransform = firstAssetTrack.preferredTransform;
        
        if(firstTransform.a == 0 && firstTransform.b == 1.0 && firstTransform.c == -1.0 && firstTransform.d == 0)
        {
            firstAssetOrientation_= UIImageOrientationRight; isFirstAssetPortrait_ = YES;
        }
        if(firstTransform.a == 0 && firstTransform.b == -1.0 && firstTransform.c == 1.0 && firstTransform.d == 0)
        {
            firstAssetOrientation_ =  UIImageOrientationLeft; isFirstAssetPortrait_ = YES;
        }
        if(firstTransform.a == 1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == 1.0)
        {
            firstAssetOrientation_ =  UIImageOrientationUp;
        }
        if(firstTransform.a == -1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == -1.0)
        {
            firstAssetOrientation_ = UIImageOrientationDown;
        }

        NSLog(@"Original Assets Dimensions. width: %f height: %f", firstAssetTrack.naturalSize.width, firstAssetTrack.naturalSize.height);

        CGFloat originalHeight = firstAssetTrack.naturalSize.height;
        CGFloat originalWidth = firstAssetTrack.naturalSize.width;
        CGFloat firstAssetScaleToFitRatio = originalHeight/firstAssetTrack.naturalSize.width;
        
        if(isFirstAssetPortrait_)
        {
            firstAssetScaleToFitRatio = originalHeight/firstAssetTrack.naturalSize.height;
            CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(firstAssetScaleToFitRatio,firstAssetScaleToFitRatio);
            [firstlayerInstruction setTransform:CGAffineTransformConcat(firstAssetTrack.preferredTransform, FirstAssetScaleFactor) atTime:kCMTimeZero];
        }
        else
        {
            CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(firstAssetScaleToFitRatio,firstAssetScaleToFitRatio);
            [firstlayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(firstAssetTrack.preferredTransform, FirstAssetScaleFactor),CGAffineTransformMakeTranslation(0, 160)) atTime:kCMTimeZero];
        }
        [firstlayerInstruction setOpacity:0.0 atTime:firstAsset.duration];
        
        mainInstruction.layerInstructions = [NSArray arrayWithObjects:firstlayerInstruction,nil];;
        
        AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
        mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
        mainCompositionInst.frameDuration = CMTimeMake(1, 30);
        mainCompositionInst.renderSize = CGSizeMake(originalHeight, originalWidth);
        
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
             [self exportDidFinish:exporter withCompletionSource: completionSource];
         }];
    } else {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Error, video track not found" forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"MFVideoAsset" code:500 userInfo:details];
        [completionSource setError:error];
    }
    
    return [completionSource task];
}

- (void)exportDidFinish:(AVAssetExportSession*)session withCompletionSource:(BFTaskCompletionSource*)completionSource
{
    MFVideoAssetResponse *response = [[MFVideoAssetResponse alloc] init];

    if(session.status == AVAssetExportSessionStatusCompleted) {
        response.thumbnail = [self generateThumbnail];
        response.url = session.outputURL;
        [completionSource setResult:response];
    } else {
        NSLog(@"## error fixing orientation. Session.status: %ld", session.status);
        [completionSource setError:session.error];
    }
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
    
    CGRect rect = CGRectMake(0, 0, 320.0, 320.0);
    return [thumb croppedImageInRect:rect];
}

@end