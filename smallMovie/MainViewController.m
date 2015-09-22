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
    [self createFile];//创建文件夹
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

//创建文件夹
- (void)createFile{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    BOOL isDirExist = [fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",documentPath,VIDEO_Location] isDirectory:FALSE];
    if (!(isDirExist)) {
        BOOL isCreateDir = [fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@/video",documentPath] withIntermediateDirectories:YES attributes:nil error:nil];
        if (isCreateDir) {
            NSLog(@"创建成功:%@",[NSString stringWithFormat:@"%@/video",documentPath]);
        } else {
            NSLog(@"常见失败");
        }
    }
    
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
    BMEnvObserverCenterNetworkStatus *networkStatus = [BMEnvObserverCenterNetworkStatus defaultCenter];
    NSString  *statusStr = [networkStatus currentNetWorkStatusString];
    NSLog(@"当前网络状态为: %@",statusStr);
    if (networkStatus.currentNetWorkStatus == BMNetworkReachabilityStatusUnknown || networkStatus.currentNetWorkStatus == BMNetworkReachabilityStatusNotReachable) {
        [self showHint:@"亲，请检查您的网络连接"];
    } else if (networkStatus.currentNetWorkStatus == BMNetworkReachabilityStatusReachableVia2G) {
        [self showHint:@"您现在处在2G网络，建议您切换到Wifi网络下使用此应用"];
    } else if (networkStatus.currentNetWorkStatus == BMNetworkReachabilityStatusReachableVia3G) {
        [self showHint:@"您现在处在3G网络，建议您切换到Wifi网络下使用此应用"];
    } else if (networkStatus.currentNetWorkStatus == BMNetworkReachabilityStatusReachableVia4G) {
        [self showHint:@"您现在处在4G网络，建议您切换到Wifi网络下使用此应用"];
    } else if (networkStatus.currentNetWorkStatus == BMNetworkReachabilityStatusReachableViaWiFi) {
        [self showHint:@"您现在处在Wifi下，请放心使用此应用"];
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
