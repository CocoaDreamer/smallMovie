//
//  OrientationController.m
//  smallMovie
//
//  Created by aayongche on 15/9/14.
//  Copyright (c) 2015年 lei.cheng. All rights reserved.
//

#import "OrientationController.h"

@interface OrientationController ()

@end

@implementation OrientationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)shouldAutorotate{
    if ([self.visibleViewController respondsToSelector:@selector(shouldAutorotate)]) {
        return [self.visibleViewController shouldAutorotate];
        NSLog(@"==================%@",self.visibleViewController);
    }
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations{
    if ([self.visibleViewController respondsToSelector:@selector(supportedInterfaceOrientations)]) {
        return [self.visibleViewController supportedInterfaceOrientations];
    }
    return [super supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    if ([self.visibleViewController respondsToSelector:@selector(preferredInterfaceOrientationForPresentation)]) {
        return [self.visibleViewController preferredInterfaceOrientationForPresentation];
    }
    return [super preferredInterfaceOrientationForPresentation];
}


@end
