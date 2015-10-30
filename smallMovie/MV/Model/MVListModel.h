//
//  MVListModel.h
//  smallMovie
//
//  Created by aayongche on 15/9/11.
//  Copyright (c) 2015年 lei.cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVListModel : NSObject

@property (nonatomic, strong) NSNumber *id;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSArray *artists;

@property (nonatomic, strong) NSString *artistName;

@property (nonatomic, strong) NSString *MVdescription;

@property (nonatomic, strong) NSString *posterPic;

@property (nonatomic, strong) NSString *thumbnailPic;

@property (nonatomic, strong) NSString *albumImg;

@property (nonatomic, strong) NSString *regdate;

@property (nonatomic, strong) NSString *videoSourceTypeName;

@property (nonatomic, strong) NSNumber *totalViews;

@property (nonatomic, strong) NSNumber *totalPcViews;

@property (nonatomic, strong) NSNumber *totalMobileViews;

@property (nonatomic, strong) NSNumber *totalComments;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSString *hdUrl;

@property (nonatomic, strong) NSString *uhdUrl;

@property (nonatomic, strong) NSString *shdUrl;

@property (nonatomic, strong) NSNumber *videoSize;

@property (nonatomic, strong) NSNumber *hdVideoSize;

@property (nonatomic, strong) NSNumber *uhdVideoSize;

@property (nonatomic, strong) NSNumber *shdVideoSize;

@property (nonatomic, strong) NSNumber *duration;

@property (nonatomic, strong) NSNumber *status;

@property (nonatomic, strong) NSNumber *score;

@property (nonatomic, assign) BOOL up;

@property (nonatomic, strong) NSString *trendScore;

@property (nonatomic, strong) NSString *playListPic;

/**********************************自定义字段**********************************************/

/**
 *  是否下载完成
 */
@property (nonatomic, assign) BOOL isDownload;

/**
 *  是否收藏
 */
@property (nonatomic, assign) BOOL isSaved;

/**
 *  是否正在下载
 */
@property (nonatomic, assign) BOOL isDownloading;

/**
 *  下载百分比
 */
@property (nonatomic, assign) float percent;

@end
