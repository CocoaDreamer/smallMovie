//
//  APISDK.m
//  smallMoview
//
//  Created by 程磊 on 15/8/14.
//  Copyright (c) 2015年 Jueying. All rights reserved.
//

#import "APISDK.h"
#import "objc/runtime.h"

#define TIME_OUT  20
//static char getParamDic;
@interface APISDK()

@end

@implementation APISDK

- (id)init{
    self = [super init];
    if (self) {
        _manager = [AFHTTPRequestOperationManager manager];
        _manager.requestSerializer.timeoutInterval = 15.0;
        _manager.requestSerializer.HTTPShouldUsePipelining = YES;
        _manager.requestSerializer.HTTPShouldHandleCookies = YES;
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}

+ (instancetype)getSingleClass{
    static APISDK *apisdk = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        apisdk = self.new;
    });
    return apisdk;
}



- (AFHTTPRequestOperation *)sendDataWithUrlString:(NSString *)urlString ParamDictionary:(NSDictionary *)param requestMethod:(reqMethod)method finished:(RequestFinished)finished failed:(RequestFailed)failed{
    NSParameterAssert(urlString);
    AFHTTPRequestOperation * operation;
    if (method == post) {
        operation = [_manager POST:urlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            finished(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failed(error.code);
            NSLog(@"%@", error);
        }];
    } else {
        operation = [_manager GET:urlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            finished(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failed(error.code);
            NSLog(@"%@", error);
        }];
    }
    return operation;
}

//下载
- (NSURLSessionTask *)downDataWithUrlString:(NSString *)urlString ParamDictionary:(NSDictionary *)param requestMethod:(reqMethod)method finished:(RequestFinished)finished failed:(RequestFailed)failed{
    NSParameterAssert(urlString);
    NSURLSessionTask *task;
    if (method == post) {
        task = [_sessionManager POST:urlString parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            finished(responseObject);
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            failed(error.code);
        }];
    } else {
        task = [_sessionManager GET:urlString parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            finished(responseObject);
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            failed(error.code);
        }];
    }
    return task;
}

- (void)CloseAndClearRequest{
    [[AFHTTPRequestOperationManager manager].operationQueue cancelAllOperations];
}



//
//- (void)addValue:(id)value forKey:(NSString *)key{
//    if (value) {
//        NSMutableDictionary *requestDic = [self requestParamDictionary];
//        [requestDic setObject:value forKey:key];
//    }
//}
//
//- (NSMutableDictionary *)requestParamDictionary{
//    NSMutableDictionary *paramDictionary = objc_getAssociatedObject(self, &getParamDic);
//    if (paramDictionary) {
//        return paramDictionary;
//    }
//    paramDictionary = [NSMutableDictionary dictionary];
//    objc_setAssociatedObject(self, &getParamDic, paramDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    return paramDictionary;
//}

//- (NSMutableURLRequest *)makePostRequest:(NSString *)url {
//    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
//    request.HTTPMethod = @"POST";
//    request.timeoutInterval = TIME_OUT;
//    return request;
//}
//
//- (NSMutableURLRequest *)makeGetRequest:(NSString *)url {
//    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
//    request.HTTPMethod = @"GET";
//    request.timeoutInterval = TIME_OUT;
//    return request;
//}
//
//- (NSData *)makeHTTPbodyFromObject:(id)object {
//    NSCAssert([NSJSONSerialization isValidJSONObject:object], @"这不是Json类型");
//    return [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
//}


@end
