//
//  NSString+Extension.m
//  nightChat
//
//  Created by 程磊 on 14/12/16.
//  Copyright (c) 2014年 nightGroup. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        return [self boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine |
                NSStringDrawingUsesLineFragmentOrigin |
                NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
//        return [self boundingRectWithSize:maxSize options:UILineBreakModeCharacterWrap attributes:attrs context:nil].size;
    } else {
        return [self sizeWithFont:font constrainedToSize:maxSize lineBreakMode:0];
    }
    
    
}


@end
