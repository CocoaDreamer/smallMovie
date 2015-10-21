//
//  APISDK.m
//  EFAnimationMenu
//
//  Created by aayongche on 15/8/14.
//  Copyright (c) 2015年 Jueying. All rights reserved.
//

#import "APISDK.h"
#import "objc/runtime.h"

#define TIME_OUT  20
static char getParamDic;
@interface APISDK()

@end

@implementation APISDK

- (id)init{
    self = [super init];
    if (self) {
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

- (NSMutableURLRequest *)makePostRequest:(NSString *)url {
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = TIME_OUT;
    return request;
}

- (NSMutableURLRequest *)makeGetRequest:(NSString *)url {
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = TIME_OUT;
    return request;
}

- (NSData *)makeHTTPbodyFromObject:(id)object {
    NSCAssert([NSJSONSerialization isValidJSONObject:object], @"这不是Json类型");
    return [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
}

- (AFHTTPRequestOperation *)sendDataWithParamDictionary:(NSDictionary *)param requestMethod:(reqMethod)method finished:(RequestFinished)finished failed:(RequestFailed)failed{
    NSMutableString *urlString = [NSMutableString stringWithString:self.interface];
    AFHTTPRequestOperation * operation;
    if (method == post) {
        NSMutableURLRequest *request = [self makePostRequest:urlString];
        request.HTTPBody = [self makeHTTPbodyFromObject:param];
        operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            finished(responseObject);
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            failed(error.code);
            NSLog(@"%@", error);
        }];
    } else {
        if (param.allKeys.count > 0) {
            [urlString appendFormat:@"?"];
            for (NSString *key in param.allKeys) {
                [urlString appendFormat:@"%@=",key];
                [urlString appendFormat:@"%@",param[key]];
                [urlString appendString:@"&"];
            }
            [urlString deleteCharactersInRange:NSMakeRange(urlString.length-1, 1)];
        }
        NSMutableURLRequest *request = [self makeGetRequest:urlString];
        operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            finished(responseObject);
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            failed(error.code);
            NSLog(@"%@", error);
        }];
    }
    [[AFHTTPRequestOperationManager manager].operationQueue addOperation:operation];
    return operation;
}

//下载
- (void)downDataWithParamDictionary:(NSDictionary *)param requestMethod:(reqMethod)method finished:(RequestFinished)finished failed:(RequestFailed)failed{
    NSString *urlString = self.interface;
    if (method == post) {
        _task = [_sessionManager POST:urlString parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            finished(responseObject);
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            failed(error.code);
        }];
    } else {
        _task = [_sessionManager GET:urlString parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            finished(responseObject);
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            failed(error.code);
        }];
    }
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


@end
