//
//  MainViewController.m
//  smallMovie
//
//  Created by aayongche on 15/9/9.
//  Copyright (c) 2015年 lei.cheng. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"

@interface MainViewController ()<BMNetworkStatusProtocol>

@end

@implementation MainViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 34, 34)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openOrCloseLeftList)];
    [imageView addGestureRecognizer:tap];
    imageView.image = [UIImage imageWithData:[USERDEFAULT objectForKey:MY_Icon]];
    imageView.layer.cornerRadius = 17;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderWidth = 1;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    self.iconImageView = imageView;
    BMAddNetworkStatusObserver(self);
}

- (void)updateIconImageView{
    self.iconImageView.image = [UIImage imageWithData:[USERDEFAULT objectForKey:MY_Icon]];
}

- (void)initData{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateIconImageView) name:@"updateIconImageView" object:nil];
}

#pragma mark - BMNetworkStatusProtocol
- (void)networkStatusDidChangedFromStatus:(BMNetworkReachabilityStatus)fromStatus
                                 toStatus:(BMNetworkReachabilityStatus)toStatus{
    NSLog(@"*****************************************");
    if (fromStatus != toStatus) {
        NSLog(@"========状态改变了啊=========");
    }
    NSLog(@"fromStatus:  %@   toStatus: %@",@(fromStatus),@(toStatus));
    NSString  *statusStr = [[BMEnvObserverCenterNetworkStatus defaultCenter] currentNetWorkStatusString];
    NSLog(@"当前网络状态为: %@",statusStr);
    if ([BMEnvObserverCenterNetworkStatus defaultCenter].currentNetWorkStatus == BMNetworkReachabilityStatusUnknown || [BMEnvObserverCenterNetworkStatus defaultCenter].currentNetWorkStatus == BMNetworkReachabilityStatusNotReachable) {
        [self alertTitle:@"Warning" andMessage:@"无网络连接,请重试"];
    }
}

- (void) openOrCloseLeftList
{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (tempAppDelegate.LeftSlideVC.closed)
    {
        [tempAppDelegate.LeftSlideVC openLeftView];
    }
    else
    {
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }
}


- (void)alertTitle:(NSString *)title andMessage:(NSString *)message{
    TAlertView *alert = [[TAlertView alloc] initWithTitle:title andMessage:message];
    [alert show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)shouldAutorotate{
//    if ([self.selectedViewController respondsToSelector:@selector(shouldAutorotate)]) {
//        return [self.selectedViewController shouldAutorotate];
//    }
//    return NO;
//}
//
//- (NSUInteger)supportedInterfaceOrientations{
//    if ([self.selectedViewController respondsToSelector:@selector(supportedInterfaceOrientations)]) {
//        return [self.selectedViewController supportedInterfaceOrientations];
//    }
//    return [super supportedInterfaceOrientations];
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    if ([self.selectedViewController respondsToSelector:@selector(preferredInterfaceOrientationForPresentation)]) {
//        return [self.selectedViewController preferredInterfaceOrientationForPresentation];
//    }
//    return [super preferredInterfaceOrientationForPresentation];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
