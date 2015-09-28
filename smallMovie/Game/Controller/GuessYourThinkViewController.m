//
//  GuessYourThinkViewController.m
//  EFAnimationMenu
//
//  Created by aayongche on 15/8/14.
//  Copyright (c) 2015年 Jueying. All rights reserved.
//

#import "GuessYourThinkViewController.h"
#import "DeformationButton.h"
#import "AppDelegate.h"

@interface GuessYourThinkViewController (){
    DeformationButton *yesBtn;
    DeformationButton *noBtn;
    DeformationButton *notsureBtn;
    DeformationButton *retryBtn;
}


@property (weak, nonatomic) IBOutlet UIImageView *guessImageView;

@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

@property (nonatomic, strong) NSString *yesUrl;

@property (nonatomic, strong) NSString *noUrl;

@property (nonatomic, strong) NSString *notsureUrl;

@property (nonatomic, strong) NSString* requestString;

@property (nonatomic,assign) BOOL flipper;


@end

@implementation GuessYourThinkViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"猜你在想谁";
    
//    self.foundView = [[UIView alloc] initWithFrame:self.view.bounds];
//    self.foundView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:self.foundView];
//    self.colorView = [[UIView alloc] initWithFrame:self.view.bounds];
//    self.colorView.backgroundColor = [UIColor lightGrayColor];
//    [self.foundView addSubview:self.colorView];
    _requestString = GAMEASK_URL;
    
    
    retryBtn = [[DeformationButton alloc] initWithFrame:CGRectMake(APP_WIDTH/3, APP_HEIGHT-170, APP_WIDTH/3, 50) withColor:[UIColor redColor]];
    [retryBtn setExclusiveTouch:YES];
    [retryBtn.forDisplayButton setTitle:@"重新测试" forState:UIControlStateNormal];
    [retryBtn.forDisplayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    retryBtn.tag = 1000;
    [retryBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retryBtn];
    

    
    yesBtn = [[DeformationButton alloc]initWithFrame:CGRectMake(30, APP_HEIGHT-110, (APP_WIDTH-120)/3, 40) withColor:[UIColor orangeColor]];
    [yesBtn setExclusiveTouch:YES];
    [yesBtn.forDisplayButton setTitle:@"是的" forState:UIControlStateNormal];
    [yesBtn.forDisplayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    yesBtn.tag = 101;
    [yesBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yesBtn];
    
    noBtn = [[DeformationButton alloc]initWithFrame:CGRectMake(30+(APP_WIDTH-120)/3+30, APP_HEIGHT-110, (APP_WIDTH-120)/3, 40) withColor:[UIColor orangeColor]];
    [noBtn setExclusiveTouch:YES];
    [noBtn.forDisplayButton setTitle:@"不是" forState:UIControlStateNormal];
    [noBtn.forDisplayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    noBtn.tag = 102;
    [noBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:noBtn];
    
    notsureBtn = [[DeformationButton alloc]initWithFrame:CGRectMake(60+(APP_WIDTH-120)/3*2+30, APP_HEIGHT-110, (APP_WIDTH-120)/3, 40) withColor:[UIColor orangeColor]];
    [notsureBtn setExclusiveTouch:YES];
    [notsureBtn.forDisplayButton setTitle:@"不确定" forState:UIControlStateNormal];
    [notsureBtn.forDisplayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    notsureBtn.tag = 103;
    [notsureBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:notsureBtn];
    [self AskQuestion];
}


/**
 *  做请求
 */
- (void)AskQuestion{
    APISDK *apisk = [[APISDK alloc] init];
    apisk.interface = _requestString;
    [apisk sendDataWithParamDictionary:nil requestMethod:get finished:^(id responseObject) {
        [self performSelector:@selector(btnSettings) withObject:self afterDelay:0.8];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (dic[@"starturl"]) {
            _requestString = dic[@"starturl"];
            [self AskQuestion];
        }
        if ([dic[@"step"] intValue] == 1) {
            _promptLabel.text = dic[@"qtext"];
            self.yesUrl = dic[@"yesurl"];
            self.noUrl = dic[@"nourl"];
            self.notsureUrl = dic[@"notsureurl"];
        }
        if ([dic[@"step"] intValue] == 2) {
            _promptLabel.text = [NSString stringWithFormat:@"您心里想的是:%@",dic[@"guessname"]];
            //头像请求
            NSString *str = [NSString stringWithFormat:@"http://renlifang.msra.cn/portrait.aspx?id=%@",dic[@"pid"]];
            [_guessImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"Jay_2.jpg"]];
        }
    } failed:^(NSInteger errorCode) {
        yesBtn.enabled = YES;
        noBtn.enabled = YES;
        notsureBtn.enabled = YES;
        [self performSelector:@selector(btnSettings) withObject:self afterDelay:0.8];
        [self showHint:@"请求失败"];
    }];
}

- (void)btnSettings{
    yesBtn.enabled = YES;
    noBtn.enabled = YES;
    notsureBtn.enabled = YES;
    retryBtn.enabled = YES;
    [yesBtn stopLoading];
    [noBtn stopLoading];
    [notsureBtn stopLoading];
    [retryBtn stopLoading];
}

/**
 *  按钮点击事件
 */
- (void)click:(DeformationButton *)btn{
    yesBtn.enabled = NO;
    noBtn.enabled = NO;
    notsureBtn.enabled = NO;
    retryBtn.enabled = NO;
    CGPoint p;
    p.x = btn.center.x;
    p.y = btn.center.y;
    if (btn.tag == 101) {
        _requestString = self.yesUrl;
    } else if (btn.tag == 102){
        _requestString = self.noUrl;
    } else if (btn.tag == 103){
        _requestString = self.notsureUrl;
    } else if (btn.tag == 1000){
        _requestString = GAMEASK_URL;
    }
//    [self.foundView materialTransitionWithSubview:self.colorView expandCircle:self.flipper atPoint:p duration:1 changes:^{
//        self.colorView.backgroundColor = [UIColor randomColor];
//    } completion:nil];
    
    
    self.flipper = !self.flipper;
    [self.view fireMaterialTouchDiskAtPoint:p];
    
    [self AskQuestion];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
    APISDK *apisdk = [[APISDK alloc] init];
    [apisdk CloseAndClearRequest];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self.view];
    
    
//    [self.foundView materialTransitionWithSubview:self.colorView expandCircle:self.flipper atPoint:p duration:1 changes:^{
//        self.colorView.backgroundColor = [UIColor randomColor];
//    } completion:nil];
    
    
    self.flipper = !self.flipper;
    [self.view fireMaterialTouchDiskAtPoint:p];
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

@end
