//
//  MVListModel.m
//  smallMovie
//
//  Created by aayongche on 15/9/11.
//  Copyright (c) 2015年 lei.cheng. All rights reserved.
//

#import "MVListModel.h"

@implementation MVListModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+ (NSString *)getPrimaryKey{
    return @"id";
}

@end
