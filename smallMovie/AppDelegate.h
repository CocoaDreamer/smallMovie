//
//  AppDelegate.h
//  smallMovie
//
//  Created by aayongche on 15/9/8.
//  Copyright (c) 2015年 lei.cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL allowRotation;

@property (strong, nonatomic) LeftSlideViewController *LeftSlideVC;

@property (strong, nonatomic) UINavigationController *mainNavigationController;


@end

