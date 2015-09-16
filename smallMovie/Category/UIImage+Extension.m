//
//  UIImage+Extension.m
//  nightChat
//
//  Created by 程磊 on 14/12/16.
//  Copyright (c) 2014年 nightGroup. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)


+ (UIImage *)resizableImage:(NSString *)name
{
    UIImage *normal = [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CGFloat w = normal.size.width * 0.5;
    CGFloat h = normal.size.height * 0.5;
    // 拉伸图片
//            [normal stretchableImageWithLeftCapWidth:normal.size.width*0.4 topCapHeight:normal.size.height*0.4];
//            [normal resizableImageWithCapInsets:UIEdgeInsetsMake(-h, -w, -h, -w) resizingMode:UIImageResizingModeStretch];
    return [normal resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
    return normal;
}

+ (UIImage *)resizableImageBubbleImage:(NSString *)name{
    UIImage *normal = [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CGFloat w = normal.size.width * 0.5;
    CGFloat h = normal.size.height * 0.6;
    
    // 拉伸图片
    //            [normal stretchableImageWithLeftCapWidth:normal.size.width*0.4 topCapHeight:normal.size.height*0.4];
    //            [normal resizableImageWithCapInsets:UIEdgeInsetsMake(-h, -w, -h, -w) resizingMode:UIImageResizingModeStretch];
    return [normal resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
    return normal;
}

@end
