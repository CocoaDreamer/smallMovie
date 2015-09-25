//
//  ViewController.m
//  smallMovie
//
//  Created by aayongche on 15/9/8.
//  Copyright (c) 2015年 lei.cheng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    APISDK *apisdk = [[APISDK alloc] init];
    apisdk.interface = @"http://magicapi.vmovier.com/magicapi/find";
    [apisdk addValue:@1 forKey:@"json"];
    [apisdk addValue:@1 forKey:@"p"];
    [apisdk sendDataWithParamDictionary:apisdk.requestDic requestMethod:get finished:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"dict = %@",dict);
    } failed:^(NSInteger errorCode) {
        NSLog(@"%ld",(long)errorCode);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
