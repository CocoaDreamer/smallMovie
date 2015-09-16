//
//  NSString+Extension.h
//  nightChat
//
//  Created by 程磊 on 14/12/16.
//  Copyright (c) 2014年 nightGroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/**
 *  返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

@end
