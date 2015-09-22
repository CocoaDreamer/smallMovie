//
//  APISDK.h
//  EFAnimationMenu
//
//  Created by aayongche on 15/8/14.
//  Copyright (c) 2015年 Jueying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetWorking.h"
typedef enum {
    get = 1,
    post = 2,
}reqMethod;

typedef void(^RequestFinished)(id responseObject);

typedef void(^RequestFailed)(NSInteger errorCode);
@interface APISDK : NSObject
@property(nonatomic,strong) NSMutableDictionary * requestDic;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) NSString *interface;
- (void)sendDataWithParamDictionary:(NSDictionary *)param requestMethod:(reqMethod)method finished:(RequestFinished)finished failed:(RequestFailed)failed;
//- (void)sendDataNoLoadingWithParamDictionary:(NSDictionary *)param requestMethod:(reqMethod)method;
- (void)CloseAndClearRequest;
- (void)addValue:(id)value forKey:(NSString *)key;
//download
- (void)downDataWithParamDictionary:(NSDictionary *)param requestMethod:(reqMethod)method finished:(RequestFinished)finished failed:(RequestFailed)failed;


@end
