//
//  PlayMovieViewController.m
//  smallMovie
//
//  Created by aayongche on 15/9/9.
//  Copyright (c) 2015年 lei.cheng. All rights reserved.
//

#import "PlayMovieViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CommentModel.h"
#import <ShareSDK/ShareSDK.h>
#import "PopMenu.h"
#import "AppDelegate.h"



@interface PlayMovieViewController ()

@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;//视频播放控制器

/**
 *  用于展示评论的tableview
 */
@property (strong, nonatomic) UITableView *commentTableView;

/**
 *  最底层的scrovllView
 */
@property (strong, nonatomic) UIScrollView *bottomScrollView;

/**
 *  当前评论第几页
 */
@property (nonatomic, assign) int page;

/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/**
 *  分享方式
 */
@property (nonatomic, strong) NSMutableArray *items;


/**
 *  分享视图
 */
@property (nonatomic, strong) PopMenu *popMenu;

@property (nonatomic, strong) UIImageView *backImageView;





@end

@implementation PlayMovieViewController

- (void)viewWillDisappear:(BOOL)animated{
    
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound){
        
        //用户点击了返回按钮
        if (_moviePlayer) {
            [self.moviePlayer stop];
            [[NSNotificationCenter defaultCenter] removeObserver:self];

        }
        
    }
    
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    self.tabBarController.tabBar.hidden = YES;
    
    self.navigationItem.title = self.listModel.title;
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
    
    [self initData];
    
    [self createUI];
    
//    [self requestComments];
    //添加通知
    [self addNotification];
}

- (void)initData{
    _page = 1;
    _items = [[NSMutableArray alloc] init];
//    MenuItem *item = [MenuItem alloc] initWithTitle
    MenuItem *menuItem = [[MenuItem alloc] initWithTitle:nil iconName:@"button_share_friends" glowColor:[UIColor whiteColor] index:1];
    [_items addObject:menuItem];
    
    menuItem = [[MenuItem alloc] initWithTitle:nil iconName:@"button_share_tencent" glowColor:[UIColor whiteColor] index:2];
    [_items addObject:menuItem];
    
    menuItem = [[MenuItem alloc] initWithTitle:nil iconName:@"button_share_wechat" glowColor:[UIColor whiteColor] index:3];
    [_items addObject:menuItem];
    
    menuItem = [[MenuItem alloc] initWithTitle:nil iconName:@"button_share_wechat" glowColor:[UIColor whiteColor] index:4];
    [_items addObject:menuItem];
    
    menuItem = [[MenuItem alloc] initWithTitle:nil iconName:@"button_share_sinaweibo" glowColor:[UIColor whiteColor] index:5];
    [_items addObject:menuItem];
    
    
    _popMenu = [[PopMenu alloc] initWithFrame:CGRectMake(0, 64, APP_WIDTH, APP_HEIGHT-64) items:_items];
    _popMenu.menuAnimationType = kPopMenuAnimationTypeNetEase; // kPopMenuAnimationTypeSina
    _popMenu.perRowItemCount = 3; // or 2
    
    
    
    _popMenu.didSelectedItemCompletion = ^(MenuItem *selectedItem){
        NSLog(@"%lu",(unsigned long)selectedItem.index);
        SSDKPlatformType formType;
        
        SSDKContentType contentType;
        
         __weak typeof(self) weakSelf = self;

        NSString *shareText;
        if (selectedItem.index == 1) {
            formType = SSDKPlatformTypeQQ;
            contentType = SSDKContentTypeVideo;
            shareText = weakSelf.listModel.intro;
        } else if (selectedItem.index == 2){
            formType = SSDKPlatformSubTypeQZone;
            contentType = SSDKContentTypeVideo;
            shareText = weakSelf.listModel.intro;
        } else if (selectedItem.index == 3){
            formType = SSDKPlatformSubTypeWechatSession;
            contentType = SSDKContentTypeVideo;
            shareText = weakSelf.listModel.intro;
        } else if (selectedItem.index == 4){
            formType = SSDKPlatformSubTypeWechatTimeline;
            contentType = SSDKContentTypeVideo;
            shareText = weakSelf.listModel.intro;
        } else if (selectedItem.index == 5){
            formType = SSDKPlatformTypeSinaWeibo;
            contentType = SSDKContentTypeAuto;
            shareText = @"看看图片，聊以自慰";
        }
        NSArray *backuplink = _listModel.backuplink;
        NSArray *inBackuplink = backuplink[0];
        NSDictionary *dict = inBackuplink[0];
        NSString *urlStr = dict[@"video"];
        NSString *title;
        if (CL_TEST) {
            title = CL_TITLE;
        } else {
            title = self.listModel.title;
        }
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:shareText images:@[[UIImage imageNamed:@"Jay.jpg"]] url:[NSURL URLWithString:urlStr] title:title type:contentType];
        [ShareSDK share:formType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            switch (state) {
                case SSDKResponseStateSuccess:
                    [self alertErrorTitle:@"成功" andMessage:@"分享成功"];
                    break;
                case SSDKResponseStateFail:
                    [self alertErrorTitle:@"失败" andMessage:@"分享失败"];
                    break;
                case SSDKResponseStateCancel:
                    [self alertErrorTitle:@"取消" andMessage:@"取消分享"];
                default:
                    break;
            }
        }];
    };
    
}

/**
 *  请求评论
 */
- (void)requestComments{
    APISDK *apisdk = [[APISDK alloc] init];
    apisdk.interface = Comment_List;
http://magicapi.vmovier.com/magicapi/comment/getList?p=1&postid=5639&sort=new&withHot=1

    [apisdk addValue:[NSNumber numberWithInt:_page] forKey:@"p"];
    [apisdk addValue:self.listModel.id forKey:@"postid"];
    [apisdk addValue:@"new" forKey:@"sort"];
    [apisdk addValue:@1 forKey:@"withHot"];
    [apisdk sendDataWithParamDictionary:apisdk.requestDic requestMethod:post finished:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"dic = %@",dic);
        
    } failed:^(NSInteger errorCode) {
        NSLog(@"%ld",(long)errorCode);
        [self alertErrorTitle:@"列表请求失败" andMessage:[NSString stringWithFormat:@"错误码%ld",(long)errorCode]];
    }];
}

/**
 *  弹出提示框
 *
 */
- (void)alertErrorTitle:(NSString *)title andMessage:(NSString *)message{
    TAlertView *alert = [[TAlertView alloc] initWithTitle:title andMessage:message];
    [alert show];
}

/**
 *  播放按钮
 */
- (void)playVideo{
    [_backImageView removeFromSuperview];
    [self.moviePlayer play];
}

- (void)like{
    NSLog(@"喜欢");
    LKDBHelper *helper = [LKDBHelper getUsingLKDBHelper];
    if ([helper insertToDB:self.listModel]) {
        NSLog(@"插入成功");
    }
}

/**
 *  创建UI
 */
- (void) createUI{
    
    if (!_moviePlayer) {
        NSURL *url=[self getNetworkUrl];
        _moviePlayer=[[MPMoviePlayerController alloc]initWithContentURL:url];
        _moviePlayer.view.frame = CGRectMake(0, 64, APP_WIDTH, 200);
        [self.view addSubview:_moviePlayer.view];
    }
    
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, APP_WIDTH, 200)];
    _backImageView.image = _backImage;
    [self.view addSubview:_backImageView];
    _backImageView.userInteractionEnabled = YES;
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playButton setImage:[UIImage imageNamed:@"bfzn"] forState:UIControlStateNormal];
    playButton.frame = CGRectMake(_backImageView.frame.size.width/2-30, _backImageView.frame.size.height/2-30, 60, 60);
    [playButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    [_backImageView addSubview:playButton];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"wshare_click"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"wshare_normal"] forState:UIControlStateHighlighted];
    [shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.frame = CGRectMake(0, 0, 40, 40);
    UIBarButtonItem *likeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(like)];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    NSArray *array = [NSArray arrayWithObjects:likeItem,barItem, nil];
    self.navigationItem.rightBarButtonItems = array;

//    self.navigationItem.rightBarButtonItem = barItem;
    
    
    
    
    //多少人看过
    UIImageView *count_viewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 274, 20, 20)];
    count_viewImageView.image = [UIImage imageNamed:@"wshare_click"];
    [self.view addSubview:count_viewImageView];
    UILabel *count_viewLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 274, 60, 20)];
    count_viewLabel.font = [UIFont systemFontOfSize:15];
    count_viewLabel.textColor = [UIColor grayColor];
    count_viewLabel.text = self.listModel.count_view;
    [self.view addSubview:count_viewLabel];
    
    //多少人喜欢
    UIImageView *count_likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 274, 20, 20)];
    count_likeImageView.image = [UIImage imageNamed:@"wshare_click"];
    [self.view addSubview:count_likeImageView];
    UILabel *count_likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 274, 60, 20)];
    count_likeLabel.font = [UIFont systemFontOfSize:15];
    count_likeLabel.textColor = [UIColor grayColor];
    count_likeLabel.text = [NSString stringWithFormat:@"%@",self.listModel.count_like];
    [self.view addSubview:count_likeLabel];
    
    //多少人分享
    UIImageView *count_shareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(180, 274, 20, 20)];
    count_shareImageView.image = [UIImage imageNamed:@"wshare_click"];
    [self.view addSubview:count_shareImageView];
    UILabel *count_shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 274, 60, 20)];
    count_shareLabel.font = [UIFont systemFontOfSize:15.0];
    count_shareLabel.textColor = [UIColor grayColor];
    count_shareLabel.text = [NSString stringWithFormat:@"%@",self.listModel.count_share];
    [self.view addSubview:count_shareLabel];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2];
    CGSize introLabelSize = [self.listModel.intro boundingRectWithSize:CGSizeMake(APP_WIDTH-40, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{
                                                                    NSFontAttributeName: [UIFont systemFontOfSize:17.0],
                                                                    NSParagraphStyleAttributeName: paragraphStyle
                                                                    }context:nil].size;
    UITextView *introLabel = [[UITextView alloc] initWithFrame:CGRectMake(20, 314, APP_WIDTH-40, introLabelSize.height)];
    introLabel.text = self.listModel.intro;
    [self.view addSubview:introLabel];
}

- (void)share{
    [_popMenu showMenuAtView:self.view];
}

#pragma mark - 私有方法
/**
 *  取得本地文件路径
 *
 *  @return 文件路径
 */
-(NSURL *)getFileUrl{
    NSString *urlStr=[[NSBundle mainBundle] pathForResource:@"The New Look of OS X Yosemite.mp4" ofType:nil];
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    return url;
}

/**
 *  取得网络文件路径
 *
 *  @return 文件路径
 */
-(NSURL *)getNetworkUrl{
    NSArray *backuplink = _listModel.backuplink;
    NSArray *inBackuplink = backuplink[0];
    NSDictionary *dict = inBackuplink[0];
    NSString *urlStr = dict[@"video"];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    return url;
}

/**
 *  添加通知监控媒体播放控制器状态
 */
-(void)addNotification{
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    NSNotificationCenter *NSDC = [NSNotificationCenter defaultCenter];
    [NSDC addObserver:self    selector:@selector(moviePlayerWillEnterFullscreenNotification:)
                 name:MPMoviePlayerWillEnterFullscreenNotification
               object:_moviePlayer];
    [NSDC addObserver:self     selector:@selector(moviePlayerWillExitFullscreenNotification:)
                 name:MPMoviePlayerWillExitFullscreenNotification
               object:_moviePlayer];
    
}

- (void)moviePlayerWillEnterFullscreenNotification:(NSNotification*)notify

{
    AppDelegate  *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.allowRotation = YES;
    NSLog(@"moviePlayerWillEnterFullscreenNotification");
}

- (void)moviePlayerWillExitFullscreenNotification:(NSNotification*)notify

{
    AppDelegate  *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.allowRotation = NO;
    [self.moviePlayer play];
    NSLog(@"moviePlayerWillExitFullscreenNotification");
}

/**
 *  播放状态改变，注意播放完成时的状态是暂停
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackStateChange:(NSNotification *)notification{
    switch (self.moviePlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            NSLog(@"正在播放...");
            break;
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停播放.");
            break;
        case MPMoviePlaybackStateStopped:
            NSLog(@"停止播放.");
            break;
        default:
            NSLog(@"播放状态:%li",self.moviePlayer.playbackState);
            break;
    }
}

/**
 *  播放完成
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackFinished:(NSNotification *)notification{
    NSLog(@"播放完成.%li",self.moviePlayer.playbackState);
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
