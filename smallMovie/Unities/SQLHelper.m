//
//  SQLHelper.m
//  smallMovie
//
//  Created by aayongche on 15/9/18.
//  Copyright © 2015年 lei.cheng. All rights reserved.
//

#import "SQLHelper.h"
#import "LKDBHelper.h"

@implementation SQLHelper

+ (LKDBHelper *)defaultHelper{
    static LKDBHelper* db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //        NSString* dbpath = [NSHomeDirectory() stringByAppendingPathComponent:@"asd/asd.db"];
        //        db = [[LKDBHelper alloc]initWithDBPath:dbpath];
        //or
        db = [[LKDBHelper alloc]init];
    });
    return db;
}



@end
