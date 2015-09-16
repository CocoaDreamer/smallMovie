//
//  CommentModel.m
//  smallMovie
//
//  Created by aayongche on 15/9/10.
//  Copyright (c) 2015年 lei.cheng. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

- (instancetype)initWithDic:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
