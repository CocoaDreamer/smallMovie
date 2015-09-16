//
//  NSString+Helper.h
//  nightChat
//
//  Created by 程磊 on 14/12/12.
//  Copyright (c) 2014年 nightGroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Helper)

/**
 *  截断收尾空白字符
 *
 *  @return 截断结果
 */
- (NSString *)trimString;

/**
 *  检测手机号
 */
- (BOOL)checkPhoneNumInput;

@end
