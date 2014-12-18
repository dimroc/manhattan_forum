//
//  UIImage+Crop.h
//  ManhattanForum
//
//  Created by Dimitri Roche on 12/10/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Crop)
- (UIImage *)croppedImageInRect:(CGRect)rect;
@end
