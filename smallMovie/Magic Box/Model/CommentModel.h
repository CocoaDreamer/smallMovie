//
//  CommentModel.h
//  smallMovie
//
//  Created by aayongche on 15/9/10.
//  Copyright (c) 2015年 lei.cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property (nonatomic, strong) NSNumber *addtime;

@property (nonatomic, strong) NSNumber *commentid;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSNumber *count_approve;

@property (nonatomic, strong) NSNumber *isapprove;

@property (nonatomic, strong) NSNumber *postid;

@property (nonatomic, strong) NSNumber *referid;

@property (nonatomic, strong) NSNumber *totalCount;

@property (nonatomic, strong) NSNumber *ftotalCount;

@property (nonatomic, strong) NSArray *hotComments;

@property (nonatomic, strong) NSNumber *pageNumber;

@property (nonatomic, strong) NSNumber *pageSize;

@property (nonatomic, strong) NSString *msg;

@property (nonatomic, strong) NSNumber *status;

@property (nonatomic ,strong) NSString *t;

@property (nonatomic, strong) NSDictionary *user;

- (instancetype)initWithDic:(NSDictionary *)dict;


@end
