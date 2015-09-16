//
//  APISDK.m
//  EFAnimationMenu
//
//  Created by aayongche on 15/8/14.
//  Copyright (c) 2015年 Jueying. All rights reserved.
//

#import "APISDK.h"

@interface APISDK() 

@end

@implementation APISDK

-(id)init{
    self = [super init];
    if (self) {
        _requestDic = [[NSMutableDictionary alloc]init];
        _manager = [AFHTTPRequestOperationManager manager];
        _manager.requestSerializer.timeoutInterval = 15.0;
        _manager.requestSerializer.HTTPShouldUsePipelining = YES;
        _manager.requestSerializer.HTTPShouldHandleCookies = YES;
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}




- (void)sendDataWithParamDictionary:(NSDictionary *)param requestMethod:(reqMethod)method finished:(RequestFinished)finished failed:(RequestFailed)failed{
    NSString *urlString = self.interface;
    if (method == post) {
        [_manager POST:urlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            finished(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failed(error.code);
            NSLog(@"%@", error);
        }];
    } else {
        [_manager GET:urlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            finished(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failed(error.code);
            NSLog(@"%@", error);
        }];
    }
}



- (void)CloseAndClearRequest{
    if (_manager) {
        [_manager.operationQueue cancelAllOperations];
    }
}

- (void)addValue:(id)value forKey:(NSString *)key{
    if (value) {
        [self.requestDic setObject:value forKey:key];
    }
}

@end
