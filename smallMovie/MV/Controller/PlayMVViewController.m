//
//  PlayMVViewController.m
//  smallMovie
//
//  Created by 程磊 on 15/9/10.
//  Copyright (c) 2015年 lei.cheng. All rights reserved.
//

#import "PlayMVViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <ShareSDK/ShareSDK.h>
#import "PopMenu.h"
#import "MVListTableViewCell.h"
#import "AppDelegate.h"
#import "DownLoadModel.h"


@interface PlayMVViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;//视频播放控制器

/**
 *  用于展示相关MV的tableview
 */
@property (strong, nonatomic) UITableView *mvListTableView;

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

/**
 *  详情TextView
 */
@property (nonatomic, strong) UITextView *descriptionTextView;

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIImageView *backImageView;

/**
 *  标题
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 *  更新时间
 */
@property (nonatomic, strong) UILabel *updateLabel;

/**
 *  观看次数
 */
@property (nonatomic, strong) UILabel *viewCountLabel;


@end

@implementation PlayMVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarController.tabBar.hidden = YES;
        
    self.navigationItem.title = self.listModel.title;
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
    
    [self initData];
    [self createUI];
    
    [self addNotification];
    
    [self requestData];
}

- (void)requestData{
    APISDK *apisdk = [APISDK getSingleClass];
    apisdk.interface = MV_Related_List;
    NSDictionary *param = @{
                            @"D-A":@0,
                            @"relatedVideos":@"true",
                            @"id":self.listModel.id,
                            @"deviceinfo":@"%7B%22aid%22%3A%2210201024%22%2C%22os%22%3A%22Android%22%2C%22ov%22%3A%224.2.2%22%2C%22rn%22%3A%22480*800%22%2C%22dn%22%3A%22H30-T00%22%2C%22cr%22%3A%2246002%22%2C%22as%22%3A%22WIFI%22%2C%22uid%22%3A%22c5aa133090bd0d5d9ecd4163bb27f3cb%22%2C%22clid%22%3A110013000%7D"
                            };
    [apisdk sendDataWithParamDictionary:param requestMethod:get finished:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSArray *relatedVideos = [dict objectForKey:@"relatedVideos"];
        if (relatedVideos.count > 0) {
            for (NSDictionary *modelDic in relatedVideos) {
                MVListModel *model = [[MVListModel alloc] initWithDic:modelDic];
                model.MVdescription = [modelDic objectForKey:@"description"];
                [_dataSource addObject:model];
            }
        }
        [self.mvListTableView reloadData];
    } failed:^(NSInteger errorCode) {
        [self showHint:@"请求列表失败"];
    }];
}

- (void)playVideo{
    [_backImageView removeFromSuperview];
    NSURL *url;
    if ([self getFileUrl] != nil) {
        url = [self getFileUrl];
    } else {
        url=[self getNetworkUrl];
    }
    self.moviePlayer.contentURL = url;
    [self.moviePlayer play];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound){
        
        //用户点击了返回按钮
        if (_moviePlayer) {
            [self.moviePlayer stop];
            [[NSNotificationCenter defaultCenter] removeObserver:self];
        }
        
    }
    
}

//收藏按钮
- (void)like{
    NSLog(@"喜欢");
    LKDBHelper *helper = [LKDBHelper getUsingLKDBHelper];
    MVListModel *model = [helper searchSingle:[MVListModel class] where:[NSString stringWithFormat:@"id == %@",self.listModel.id] orderBy:nil];
    if (model != nil) {
        self.listModel = model;
    }
    self.listModel.isSaved = YES;
    if ([helper insertToDB:self.listModel]) {
        [self showHint:@"收藏成功"];
    }
}

- (void)download:(UIButton *)button{
    __weak __typeof(self) weakSelf = self;
    LKDBHelper *helper = [LKDBHelper getUsingLKDBHelper];
    MVListModel *model = [helper searchSingle:[MVListModel class] where:[NSString stringWithFormat:@"id == %@",self.listModel.id] orderBy:nil];
    if (model != nil) {
        self.listModel = model;
    }
    if (self.listModel.isDownload == YES) {
        [self showHint:@"您已下载过该视频，无需重新下载"];
        return;
    } else if (self.listModel.isDownloading == YES){
        [self showHint:@"该视频正在下载，请稍后"];
        return;
    }
    button.enabled = NO;//点击按钮后禁用，直到下载失败或者成功
    MBRoundProgressView *roundProgressView = [[MBRoundProgressView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    roundProgressView.progress = 0;
    roundProgressView.progressTintColor = RGB_Color(91, 186, 150);
    roundProgressView.backgroundTintColor = [UIColor whiteColor];
    [button addSubview:roundProgressView];
    self.listModel.isDownloading = YES;
    BOOL isUpdate = [helper insertToDB:self.listModel];
    if (isUpdate) {
        NSLog(@"更新成功");
    } else {
        NSLog(@"更新失败");
        
    }
    APISDK *apisdk = [APISDK getSingleClass];
        apisdk.interface = self.listModel.url;
        [apisdk downDataWithParamDictionary:nil requestMethod:get finished:^(id responseObject) {
            NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
            NSString *urlStr = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.mp4",VIDEO_Location,weakSelf.listModel.title]];
            dispatch_async(dispatch_queue_create([weakSelf.listModel.title UTF8String], DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
                BOOL isSucceed = [responseObject writeToFile:urlStr atomically:YES];
                weakSelf.listModel.isDownloading = NO;
                if (isSucceed) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showHint:@"下载成功"];
                    });
                    weakSelf.listModel.isDownload = YES;
                    BOOL isUpdate = [helper updateToDB:weakSelf.listModel where:nil];
                    if (isUpdate) {
                        NSLog(@"更新成功");
                    } else {
                        NSLog(@"更新失败");
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showHint:@"下载失败，请重试"];
                    });
                }
            });
            [roundProgressView removeFromSuperview];
            button.enabled = YES;
        } failed:^(NSInteger errorCode) {
            weakSelf.listModel.isDownloading = NO;
            dispatch_async(dispatch_queue_create([weakSelf.listModel.title UTF8String], DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
                BOOL isUpdate = [helper updateToDB:weakSelf.listModel where:nil];
                if (isUpdate) {
                    NSLog(@"更新成功");
                } else {
                    NSLog(@"更新失败");
                }
            });
            [self showHint:@"下载失败，请重试"];
            [roundProgressView removeFromSuperview];
            button.enabled = YES;
        }];
    DownLoadModel *downModel = [[DownLoadModel alloc] init];
    downModel.title = weakSelf.listModel.title;
    [apisdk.sessionManager setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
        NSLog(@"当前进度%f",(float)dataTask.countOfBytesReceived / (double)dataTask.countOfBytesExpectedToReceive);
        float percent = ((float)dataTask.countOfBytesReceived / (double)dataTask.countOfBytesExpectedToReceive);
        downModel.percent = percent;
        [[NSNotificationCenter defaultCenter] postNotificationName:ISDOWNLOADING object:downModel];
        dispatch_sync(dispatch_get_main_queue(), ^{
            roundProgressView.progress = ((float)dataTask.countOfBytesReceived / (double)dataTask.countOfBytesExpectedToReceive);
        });
    }];
}

- (void)createUI{
    if (!_moviePlayer) {
        _moviePlayer=[[MPMoviePlayerController alloc] init];
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
    
    
    //分享按钮
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"share_normal"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"share_click"] forState:UIControlStateHighlighted];
    [shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.frame = CGRectMake(0, 0, 25, 25);
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
//    self.navigationItem.rightBarButtonItem = barItem;
    
    
    //收藏按钮
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(0, 0, 25, 25);
    [collectBtn setImage:[UIImage imageNamed:@"collectionIcon"] forState:UIControlStateNormal];
    [collectBtn setImage:[UIImage imageNamed:@"collectionSelectedIcon"] forState:UIControlStateHighlighted];
    [collectBtn addTarget:self action:@selector(like) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *collectItem = [[UIBarButtonItem alloc] initWithCustomView:collectBtn];
    
    //下载按钮
    UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downBtn.frame = CGRectMake(0, 0, 25, 25);
    [downBtn addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
    [downBtn setImage:[UIImage imageNamed:@"Download"] forState:UIControlStateNormal];
    [downBtn setImage:[UIImage imageNamed:@"DownloadHighlighted"] forState:UIControlStateHighlighted];
    UIBarButtonItem *downItem = [[UIBarButtonItem alloc] initWithCustomView:downBtn];
    
    NSArray *array = [NSArray arrayWithObjects:downItem,barItem,collectItem, nil];
    self.navigationItem.rightBarButtonItems = array;
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"MV描述",@"MV相关", nil]];
    segmentedControl.frame = CGRectMake(20, 280, APP_WIDTH-40, 30);
    segmentedControl.tintColor = RGB(0x295891);
    //瞬时单击
    segmentedControl.momentary = NO; //按钮被按下后很快恢复，默认为选中状态就一直保持
    
    //初始化默认片段
    segmentedControl.selectedSegmentIndex = 0; //初始指定第0个选中
    
    //显示控件
    [self.view addSubview:segmentedControl]; //添加到父视图
    
    //读取控件
    [segmentedControl addTarget:self action:@selector(controlPressed:) forControlEvents:UIControlEventValueChanged];
    
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 324, APP_WIDTH, APP_HEIGHT-324)];
    [self.view addSubview:_backgroundView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, APP_WIDTH-40, 20)];
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.text = self.listModel.title;
    [_backgroundView addSubview:_titleLabel];
    
    _updateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, APP_WIDTH-40, 15)];
    _updateLabel.font = [UIFont systemFontOfSize:13];
    _updateLabel.text = [NSString stringWithFormat:@"更新时间：%@",self.listModel.regdate];
    _updateLabel.textColor = [UIColor grayColor];
    [_backgroundView addSubview:_updateLabel];
    
    _viewCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 370-324, APP_WIDTH-40, 15)];
    _viewCountLabel.textColor = [UIColor redColor];
    _viewCountLabel.font = [UIFont systemFontOfSize:13.0];
    _viewCountLabel.text = [NSString stringWithFormat:@"播放次数：%@",self.listModel.totalViews];
    [_backgroundView addSubview:_viewCountLabel];
    
    _descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 384-324, APP_WIDTH-30, APP_HEIGHT-404)];
    _descriptionTextView.editable = NO;
    _descriptionTextView.text = self.listModel.MVdescription;
    [_backgroundView addSubview:_descriptionTextView];
    
    _mvListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 324, APP_WIDTH, APP_HEIGHT-324)];
    _mvListTableView.delegate = self;
    _mvListTableView.dataSource = self;
}

//SegmentedControl触发的动作

-(void)controlPressed:(id)sender{
    
    UISegmentedControl *control = (UISegmentedControl *)sender;
    
    if (control.selectedSegmentIndex == 0) {
        NSLog(@"selectedIndex = 0");
        if (_mvListTableView.superview != nil) {
            [_mvListTableView removeFromSuperview];
        }
        if (_backgroundView.superview == nil) {
            [self.view addSubview:_backgroundView];
        }
    } else {
        NSLog(@"selectedIndex = 1");
        if (_mvListTableView.superview == nil) {
            [self.view addSubview:_mvListTableView];
        }
        if (_backgroundView.superview != nil) {
            [_backgroundView removeFromSuperview];
        }
        
    }
}


/**
 *  弹出视图
 */
- (void)share{
    [_popMenu showMenuAtView:self.view];
}

/**
 *  初始化数据
 */
- (void)initData{
    _dataSource = [[NSMutableArray alloc] init];
    
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
            shareText = weakSelf.listModel.MVdescription;
        } else if (selectedItem.index == 2){
            formType = SSDKPlatformSubTypeQZone;
            contentType = SSDKContentTypeVideo;
            shareText = weakSelf.listModel.MVdescription;
        } else if (selectedItem.index == 3){
            formType = SSDKPlatformSubTypeWechatSession;
            contentType = SSDKContentTypeVideo;
            shareText = weakSelf.listModel.MVdescription;
        } else if (selectedItem.index == 4){
            formType = SSDKPlatformSubTypeWechatTimeline;
            contentType = SSDKContentTypeVideo;
            shareText = weakSelf.listModel.MVdescription;
        } else if (selectedItem.index == 5){
            formType = SSDKPlatformTypeSinaWeibo;
            contentType = SSDKContentTypeAuto;
            shareText = @"看看图片，聊以自慰";
        }
        NSString *title;
        if (CL_TEST) {
            title = CL_TITLE;
        } else {
            title = self.listModel.title;
        }
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:shareText images:@[[UIImage imageNamed:@"Jay.jpg"]] url:[NSURL URLWithString:self.listModel.url] title:title type:contentType];
        [ShareSDK share:formType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            switch (state) {
                case SSDKResponseStateSuccess:
                    [self alertTitle:@"成功" andMessage:@"分享成功"];
                    break;
                case SSDKResponseStateFail:
                    [self alertTitle:@"失败" andMessage:@"分享失败"];
                    break;
                case SSDKResponseStateCancel:
                    [self alertTitle:@"取消" andMessage:@"取消分享"];
                default:
                    break;
            }
        }];
    };
    
}

/**
 *  弹出提示框
 *
 */
- (void)alertTitle:(NSString *)title andMessage:(NSString *)message{
    TAlertView *alert = [[TAlertView alloc] initWithTitle:title andMessage:message];
    [alert show];
}

//#pragma MPMovieController
///**
// *  创建媒体播放控制器
// *
// *  @return 媒体播放控制器
// */
//-(MPMoviePlayerController *)moviePlayer{
//    if (!_moviePlayer) {
//        NSURL *url=[self getNetworkUrl];
//        _moviePlayer=[[MPMoviePlayerController alloc]initWithContentURL:url];
//        _moviePlayer.view.frame = CGRectMake(0, 64, APP_WIDTH, 200);
//        [self.view addSubview:_moviePlayer.view];
//    }
//    return _moviePlayer;
//}



#pragma mark - 获取视频路径
/**
 *  取得本地文件路径
 *
 *  @return 文件路径
 */
-(NSURL *)getFileUrl{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *urlStr = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.mp4",VIDEO_Location,self.listModel.title]];
    if ([fileManager fileExistsAtPath:urlStr isDirectory:FALSE]) {
        NSURL *url=[NSURL fileURLWithPath:urlStr];
        return url;
    } else {
        return nil;
    }
    
}
/**
 *  取得网络文件路径
 *
 *  @return 文件路径
 */
-(NSURL *)getNetworkUrl{
    NSString *urlStr = _listModel.url;
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    return url;
}
#pragma mark -添加通知
/**
 *  添加通知监控媒体播放控制器状态
 */
-(void)addNotification{
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
    [noti addObserver:self    selector:@selector(moviePlayerWillEnterFullscreenNotification:)
                 name:MPMoviePlayerWillEnterFullscreenNotification
               object:_moviePlayer];
    [noti addObserver:self     selector:@selector(moviePlayerWillExitFullscreenNotification:)
                 name:MPMoviePlayerWillExitFullscreenNotification
               object:_moviePlayer];
    
}

#pragma mark -moviePlayer代理方法
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

#pragma mark -tableview代理方法
- (MVListTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MVListModel *model = _dataSource[indexPath.row];
    MVListTableViewCell *cell = [MVListTableViewCell cellWithTable:tableView];
    [cell.listImageView sd_setImageWithURL:[NSURL URLWithString:model.thumbnailPic] placeholderImage:[UIImage imageNamed:@"Jay.jpg"]];
    cell.titleLabel.text = model.title;
    //    NSMutableString *artist = [NSMutableString string];
    //    for (NSDictionary *dict in model.artists) {
    //        [artist appendString:[NSString stringWithFormat:@"%@&",[dict objectForKey:@"artistName"]]];
    //    }
    //    [artist deleteCharactersInRange:NSMakeRange(artist.length-1, 1)];
    //    NSLog(@"artist = %@",artist);
    cell.artistLabel.text = model.artistName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.moviePlayer stop];
    MVListModel *model = _dataSource[indexPath.row];
    _listModel = model;
    self.moviePlayer.contentURL = [self getNetworkUrl];
    if (_backImageView.superview != nil) {
        [_backImageView removeFromSuperview];
    }
    [self.moviePlayer play];
    _titleLabel.text = _listModel.title;
    _updateLabel.text = _listModel.regdate;
    _viewCountLabel.text = [NSString stringWithFormat:@"播放次数：%@",self.listModel.totalViews];
    _descriptionTextView.text = self.listModel.MVdescription;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
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
