//
//  ListModel.h
//  smallMovie
//
//  Created by aayongche on 15/9/9.
//  Copyright (c) 2015年 lei.cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListModel : NSObject

@property (nonatomic, strong) NSNumber *_1_file_size;

@property (nonatomic, strong) NSArray *backuplink;

@property (nonatomic, strong) NSArray *cid;

@property (nonatomic, strong) NSNumber *content_type;

/**
 *  评论数量
 */
@property (nonatomic, strong) NSNumber *count_comment;

@property (nonatomic, strong) NSNumber *count_like;

@property (nonatomic, strong) NSNumber *count_share;

@property (nonatomic, strong) NSString *count_view;

@property (nonatomic, strong) NSNumber *episode;

@property (nonatomic, strong) NSNumber *id;

@property (nonatomic, strong) NSString *intro;

@property (nonatomic, strong) NSNumber *is_recent_hot;

@property (nonatomic, strong) NSString *md5;

@property (nonatomic, strong) NSArray *pdownlink;

@property (nonatomic, strong) NSString *pfullname;

@property (nonatomic, strong) NSNumber *pid;

@property (nonatomic, strong) NSString *pimg;

@property (nonatomic, strong) NSString *pintro;

@property (nonatomic, strong) NSString *pname;

@property (nonatomic, strong) NSString *prating;

@property (nonatomic, strong) NSString *pviewtime;

@property (nonatomic, strong) NSNumber *pviewtimeint;

@property (nonatomic, strong) NSString *resolution;

@property (nonatomic, strong) NSNumber *seriesid;

@property (nonatomic, strong) NSString *sharelink;

@property (nonatomic, strong) NSString *source_link;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *videolink;

//自己加的字段  用来判断是不是下载了
@property (nonatomic, assign) BOOL isDownload;

@property (nonatomic, assign) BOOL isSaved;//是否收藏


- (instancetype)initWithDict:(NSDictionary *)dict;

@end
