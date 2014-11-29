//
//  VideoAsset.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 11/28/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

import Foundation
import AVFoundation

class VideoAsset {
    let url: NSURL
    
    init(url: NSURL!) {
        self.url = url
    }
    
    func getData() -> NSData {
        return NSData.dataWithContentsOfMappedFile(self.url.path as String!) as NSData
    }
    
    func fixOrientation() {
        let asset: AVAsset = AVAsset.assetWithURL(self.url) as AVAsset
        var errorPtr: NSErrorPointer = nil
        let reader = AVAssetReader(asset: asset, error: errorPtr)
        
        var composition = AVMutableComposition()

        var track = composition.addMutableTrackWithMediaType(AVMediaTypeVideo, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))
        let originalTrack = asset.tracksWithMediaType(AVMediaTypeVideo)[0] as AVAssetTrack
        
        var layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
        let orientation = UIImageOrientation.Up
        let transform = originalTrack.preferredTransform;

        
        var scaleToFitRatio = 320.0/originalTrack.naturalSize.width;
        
        if(true)
        {
            scaleToFitRatio = 320.0/originalTrack.naturalSize.height;
            let scaleFactor = CGAffineTransformMakeScale(scaleToFitRatio, scaleToFitRatio);
            layerInstruction.setTransform(CGAffineTransformConcat(transform, scaleFactor), atTime: kCMTimeZero)
        }
    }
}


//- (void)videoFixOrientation{
//    AVAsset *firstAsset = [AVAsset assetWithURL:[self urlVideoLocalLocation]];
//    if(firstAsset !=nil && [[firstAsset tracksWithMediaType:AVMediaTypeVideo] count]>0){
//        //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
//        AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
//        
//        //VIDEO TRACK
//        AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
//        [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
//        AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
//        MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, firstAsset.duration);
//        
//        if ([[firstAsset tracksWithMediaType:AVMediaTypeAudio] count]>0) {
//            //AUDIO TRACK
//            AVMutableCompositionTrack *firstAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
//            [firstAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
//        }else{
//            NSLog(@"warning: video has no audio");
//        }
//        
//        //FIXING ORIENTATION//
//        AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
//        
//        AVAssetTrack *FirstAssetTrack = [[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
//        
//        UIImageOrientation FirstAssetOrientation_  = UIImageOrientationUp;
//        
//        BOOL  isFirstAssetPortrait_  = NO;
//        
//        CGAffineTransform firstTransform = FirstAssetTrack.preferredTransform;
//        
//        if(firstTransform.a == 0 && firstTransform.b == 1.0 && firstTransform.c == -1.0 && firstTransform.d == 0)
//        {
//            FirstAssetOrientation_= UIImageOrientationRight; isFirstAssetPortrait_ = YES;
//        }
//        if(firstTransform.a == 0 && firstTransform.b == -1.0 && firstTransform.c == 1.0 && firstTransform.d == 0)
//        {
//            FirstAssetOrientation_ =  UIImageOrientationLeft; isFirstAssetPortrait_ = YES;
//        }
//        if(firstTransform.a == 1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == 1.0)
//        {
//            FirstAssetOrientation_ =  UIImageOrientationUp;
//        }
//        if(firstTransform.a == -1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == -1.0)
//        {
//            FirstAssetOrientation_ = UIImageOrientationDown;
//        }
//        
//        CGFloat FirstAssetScaleToFitRatio = 320.0/FirstAssetTrack.naturalSize.width;
//        
//        if(isFirstAssetPortrait_)
//        {
//            FirstAssetScaleToFitRatio = 320.0/FirstAssetTrack.naturalSize.height;
//            CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
//            [FirstlayerInstruction setTransform:CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor) atTime:kCMTimeZero];
//        }
//        else
//        {
//            CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
//            [FirstlayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor),CGAffineTransformMakeTranslation(0, 160)) atTime:kCMTimeZero];
//        }
//        [FirstlayerInstruction setOpacity:0.0 atTime:firstAsset.duration];
//        
//        MainInstruction.layerInstructions = [NSArray arrayWithObjects:FirstlayerInstruction,nil];;
//        
//        AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];
//        MainCompositionInst.instructions = [NSArray arrayWithObject:MainInstruction];
//        MainCompositionInst.frameDuration = CMTimeMake(1, 30);
//        MainCompositionInst.renderSize = CGSizeMake(320.0, 480.0);
//        
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideo-%d.mov",arc4random() % 1000]];
//        
//        NSURL *url = [NSURL fileURLWithPath:myPathDocs];
//        
//        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
//        
//        exporter.outputURL=url;
//        exporter.outputFileType = AVFileTypeQuickTimeMovie;
//        exporter.videoComposition = MainCompositionInst;
//        exporter.shouldOptimizeForNetworkUse = YES;
//        [exporter exportAsynchronouslyWithCompletionHandler:^
//        {
//        dispatch_async(dispatch_get_main_queue(), ^{
//        [self exportDidFinish:exporter];
//        });
//        }];
//    }else{
//        NSLog(@"Error, video track not found");
//    }
//    }
//    
//    - (void)exportDidFinish:(AVAssetExportSession*)session
//{
//    if(session.status == AVAssetExportSessionStatusCompleted){
//        #warning DO WHAT EVER YOU NEED AFTER FIXING ORIENTATION
//    }else{
//        NSLog(@"error fixing orientation");
//    }
//}