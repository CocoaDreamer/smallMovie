//
//  APISDK.m
//  EFAnimationMenu
//
//  Created by aayongche on 15/8/14.
//  Copyright (c) 2015年 Jueying. All rights reserved.
//

#import "APISDK.h"

#define TIME_OUT  20
@interface APISDK() 

@end

@implementation APISDK

-(id)init{
    self = [super init];
    if (self) {
        _requestDic = [[NSMutableDictionary alloc]init];
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
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
    NSAssert([NSJSONSerialization isValidJSONObject:object], @"这不是Json类型");
    
    return [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
}

- (void)sendDataWithParamDictionary:(NSDictionary *)param requestMethod:(reqMethod)method finished:(RequestFinished)finished failed:(RequestFailed)failed{
    AFHTTPRequestOperation * operation;
    if (method == post) {
        NSMutableURLRequest *request = [self makePostRequest:self.interface];
        request.HTTPBody = [self makeHTTPbodyFromObject:param];
        operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            finished(responseObject);
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            failed(error.code);
            NSLog(@"%@", error);
        }];
    } else {
        NSMutableURLRequest *request = [self makeGetRequest:self.interface];
        operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            finished(responseObject);
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            failed(error.code);
            NSLog(@"%@", error);
        }];
    }
    [[AFHTTPRequestOperationManager manager].operationQueue addOperation:operation];
}

- (void)addValue:(id)value forKey:(NSString *)key{
    if (value) {
        [self.requestDic setObject:value forKey:key];
    }
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

@end
