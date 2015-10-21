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
/**
 *  下载管理者
 */
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
/**
 *  接口网址
 */
@property (nonatomic, strong) NSString *interface;
/**
 *  获取单例
 *
 */
+ (instancetype)getSingleClass;
//@property (nonatomic, strong)    AFHTTPRequestOperationManager *manager;


/**
 *  发送请求
 *
 *  @param method   post还是get
 *  @param finished 请求成功结果
 *  @param failed   请求失败描述
 */
- (AFHTTPRequestOperation *)sendDataWithParamDictionary:(NSDictionary *)param requestMethod:(reqMethod)method finished:(RequestFinished)finished failed:(RequestFailed)failed;
/**
 *  取消请求
 */
- (void)CloseAndClearRequest;
///**
// *  添加post参数
// *
// *  @param value 值
// *  @param key   键
// */
//- (void)addValue:(id)value forKey:(NSString *)key;
/**
 *  下载
 *
 *  @param param    参数
 *  @param method   get Or post
 *  @param finished 请求完成
 *  @param failed   请求失败
 */
- (NSURLSessionTask *)downDataWithParamDictionary:(NSDictionary *)param requestMethod:(reqMethod)method finished:(RequestFinished)finished failed:(RequestFailed)failed;


@end
