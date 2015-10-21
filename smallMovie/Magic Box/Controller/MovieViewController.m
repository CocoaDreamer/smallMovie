//
//  MovieViewController.m
//  smallMovie
//
//  Created by aayongche on 15/9/16.
//  Copyright (c) 2015年 lei.cheng. All rights reserved.
//

#import "MovieViewController.h"
#import "ListModel.h"
#import "ListTableViewCell.h"
#import "PlayMovieViewController.h"
#import "MVSearchViewController.h"
#import "AppDelegate.h"

@interface MovieViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) ListModel *listModel;

@property (nonatomic, assign) int page;

@property (nonatomic, strong) UIImage *backImage;

@property (weak, nonatomic) IBOutlet UITableView *mvListTableView;
@end

@implementation MovieViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarController.title = @"热播视频";
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
    
}

/**
 *  初始化数据
 */
- (void) initData{
    _dataSource = [[NSMutableArray alloc] init];
    
    if (self.tabBarController.navigationItem.rightBarButtonItem == nil) {
        self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search)];
    }
}

- (void)search{
    MVSearchViewController *search = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MVSearchViewController"];
    [self.tabBarController.navigationController pushViewController:search animated:YES];
}

/**
 *  请求数据   NO上拉  YES下拉
 */
- (void)requestDataWithUpOrDown:(BOOL)upOrDown{
    APISDK *apisdk = [APISDK getSingleClass];
    NSDictionary *dic = @{
                          @"json":@1,
                          @"p":[NSNumber numberWithInt:_page]
                          };
    apisdk.interface = Movie_List;
    
    [apisdk sendDataWithParamDictionary:dic requestMethod:get finished:^(id responseObject) {
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if (upOrDown) {
            [_dataSource removeAllObjects];
        } else {
            _page++ ;
        }
        NSLog(@"responseDict = %@",responseDict);
        NSArray *data = [responseDict objectForKey:@"data"];
        if ([data isKindOfClass: [NSArray class]]) {
            for (NSDictionary *dict in data) {
                ListModel *model = [[ListModel alloc] initWithDict:dict];
                [_dataSource addObject:model];
            }
            [self.mvListTableView reloadData];
            [self stopMJRefresh];
        } else {
            [self stopMJRefresh];
            [self.mvListTableView.footer noticeNoMoreData];
        }
    } failed:^(NSInteger errorCode) {
        NSLog(@"%ld",(long)errorCode);
        [self showHint:@"列表请求失败"];
        if (upOrDown) {
            _page = 1;
        }
        [self stopMJRefresh];
    }];
}

/**
 *  停止刷新
 */
- (void)stopMJRefresh{
    [self.mvListTableView.header endRefreshing];
    [self .mvListTableView.footer endRefreshing];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self setupRefresh];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/**
 *  集成刷新控件
 *
 *
 */
- (void)setupRefresh{
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.mvListTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [weakSelf requestDataWithUpOrDown:YES];
        _page = 2;
    }];
    _mvListTableView.header.scrollView.backgroundColor = [UIColor blackColor];
    
    // 马上进入刷新状态
    [_mvListTableView.header beginRefreshing];
    
    _mvListTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestDataWithUpOrDown:NO];
    }];
    
    
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _dataSource.count;
}


- (ListTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    // Configure the cell...
    ListModel *model = _dataSource[indexPath.row];
    [cell.pictureImageView sd_setImageWithURL:[NSURL URLWithString:model.pimg] placeholderImage:[UIImage imageNamed:@"Jay.jpg"]];
    cell.nameLabel.text = model.pfullname;
    cell.timeLabel.text = model.pviewtime;
    cell.shareLabel.text = [NSString stringWithFormat:@"%@",model.count_share];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ListModel *model = _dataSource[indexPath.row];
    model.isDownload = NO;
    model.isDownloading = NO;
    model.isSaved = NO;
    NSArray *backuplink = model.backuplink;
    NSArray *inBackuplink = backuplink[0];
    NSDictionary *dict = inBackuplink[0];
    //    _video = dict[@"video"];
    _listModel = model;
    ListTableViewCell *cell = (ListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    _backImage = cell.pictureImageView.image;
    [self performSegueWithIdentifier:@"PlayMovie" sender:self];
    
}





#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString: @"PlayMovie"]) {
        PlayMovieViewController *page = segue.destinationViewController;
        page.listModel = _listModel;
        page.backImage = _backImage;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
