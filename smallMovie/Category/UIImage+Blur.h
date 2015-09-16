//
//  UIImage+Blur.h
//  Animation
//
//  Created by yuelixing on 14/12/19.
//  Copyright (c) 2014年 yuelixing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
#import <CoreGraphics/CoreGraphics.h>

@interface UIImage (Blur)

-(UIImage *)boxblurImageWithBlur:(CGFloat)blur;

/**
 *  高斯迷糊效果
 */
- (UIImage *)blur;

- (UIImage *)blurryWithBlurLevel:(CGFloat)blur;

@end
