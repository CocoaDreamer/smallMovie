//
//  MVListViewController.m
//  smallMovie
//
//  Created by aayongche on 15/9/15.
//  Copyright (c) 2015年 lei.cheng. All rights reserved.
//

#import "MVListViewController.h"
#import "ListTableViewCell.h"
#import "APISDK.h"
#import "MVListModel.h"
#import "PlayMVViewController.h"
#import "AppDelegate.h"

@interface MVListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *mvListTableView;

@property (nonatomic, assign) int offset;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) MVListModel *listModel;

@property (nonatomic, strong) UIImage *backImage;

@property (nonatomic, strong) NSString *area;

@property (weak, nonatomic) IBOutlet UIButton *KRButton;

@property (weak, nonatomic) IBOutlet UIButton *USButton;

@property (weak, nonatomic) IBOutlet UIButton *MLButton;

@property (weak, nonatomic) IBOutlet UIButton *HTButton;

@property (weak, nonatomic) IBOutlet UIButton *JPButton;

@end

@implementation MVListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarController.title = @"热播MV";
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
    
}

- (IBAction)btnClick:(UIButton *)sender {
    if (sender.tag == 10) {
        NSLog(@"KR");
        _area = @"KR";
    } else if (sender.tag == 11) {
        NSLog(@"US");
        _area = @"US";
    } else if (sender.tag == 12) {
        NSLog(@"ML");
        _area = @"ML";
    } else if (sender.tag == 13) {
        NSLog(@"HT");
        _area = @"HT";
    } else {
        NSLog(@"JP");
        _area = @"JP";
    }
    [_mvListTableView.header beginRefreshing];
}

/**
 *  初始化数据
 */
- (void)initData{
    
    /**
     *  禁止事件同时相应
     */
    [_KRButton setExclusiveTouch:YES];
    [_JPButton setExclusiveTouch:YES];
    [_MLButton setExclusiveTouch:YES];
    [_USButton setExclusiveTouch:YES];
    [_HTButton setExclusiveTouch:YES];
    _dataSource = [[NSMutableArray alloc] init];
    _area = @"ML";
}

- (void)refreshTableView{
    [self stopMJRefresh];
    [self requestDataWithUpOrDown:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self setupRefresh];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
}

/**
 *  集成刷新控件
 *
 *
 */
- (void)setupRefresh{
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    _mvListTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _offset = 0;
        [weakSelf requestDataWithUpOrDown:YES];
        _offset = 20;
    }];
    _mvListTableView.header.scrollView.backgroundColor = [UIColor blackColor];
    _mvListTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestDataWithUpOrDown:NO];
    }];
    // 马上进入刷新状态
    [_mvListTableView.header beginRefreshing];
}

/**
 *  请求数据   NO上拉  YES下拉
 */
- (void)requestDataWithUpOrDown:(BOOL)upOrDown{
    APISDK *apisdk = [[APISDK alloc] init];
    apisdk.interface = MV_List(_area, [NSNumber numberWithInt:_offset]);
    [apisdk sendDataWithParamDictionary:nil requestMethod:get finished:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if (upOrDown) {
            [_dataSource removeAllObjects];
        } else {
            _offset += 20 ;
        }
        NSArray *videos = [dict objectForKey:@"videos"];
        if (videos.count > 0) {
            for (NSDictionary *video in videos) {
                MVListModel *model = [[MVListModel alloc] initWithDic:video];
                model.MVdescription = video[@"description"];
                [_dataSource addObject:model];
            }
        }
        [_mvListTableView reloadData];
        [self stopMJRefresh];
    } failed:^(NSInteger errorCode) {
        NSLog(@"errorCode = %ld",(long)errorCode);
        [self showHint:@"列表请求失败"];
        if (upOrDown) {
            _offset = 0;
        }
        [self stopMJRefresh];
    }];
}

/**
 *  停止刷新
 */
- (void)stopMJRefresh{
    [_mvListTableView.header endRefreshing];
    [_mvListTableView.footer endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _dataSource.count;
}


- (ListTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MVListModel *model = _dataSource[indexPath.row];
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    cell.shareNumImageView.hidden = YES;
    cell.timeImageView.hidden = YES;
    // Configure the cell...
    [cell.pictureImageView sd_setImageWithURL:[NSURL URLWithString:model.thumbnailPic] placeholderImage:[UIImage imageNamed:@"Jay.jpg"]];
    cell.nameLabel.text = model.title;
    cell.descriptionLabel.text = model.MVdescription;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MVListModel *model = _dataSource[indexPath.row];
    model.isDownload = NO;
    model.isDownloading = NO;
    model.isSaved = NO;
    _listModel = model;
    ListTableViewCell *cell = (ListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    _backImage = cell.pictureImageView.image;
    [self performSegueWithIdentifier:@"PlayMV" sender:self];
    
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString: @"PlayMV"]) {
        PlayMVViewController *page = segue.destinationViewController;
        page.listModel = _listModel;
        page.backImage = _backImage;
    }
}




@end
