//
//  UIImage+Extension.h
//  nightChat
//
//  Created by 程磊 on 14/12/16.
//  Copyright (c) 2014年 nightGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/**
 *  返回一张可以随意拉伸不变形的图片
 *
 *  @param name 图片名字
 */
+ (UIImage *)resizableImage:(NSString *)name;

/**
 *  fanhui图片
 *
 *  @param name <#name description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)resizableImageBubbleImage:(NSString *)name;

@end
