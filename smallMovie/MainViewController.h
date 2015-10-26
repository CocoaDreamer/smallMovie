//
//  MainViewController.h
//  smallMovie
//
//  Created by aayongche on 15/9/9.
//  Copyright (c) 2015年 lei.cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UITabBarController

@property (nonatomic, strong) UIImageView *iconImageView;

/**
 *  检查下载进度
 */
- (void)checkDownloadPercent;

@end
