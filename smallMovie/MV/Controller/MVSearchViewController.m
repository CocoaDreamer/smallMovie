//
//  MVSearchViewController.m
//  smallMovie
//
//  Created by aayongche on 15/9/14.
//  Copyright (c) 2015年 lei.cheng. All rights reserved.
//

#import "MVSearchViewController.h"
#import "MVListModel.h"
#import "MVSearchTableViewCell.h"
#import "PlayMVViewController.h"
#import "AppDelegate.h"

@interface MVSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *MVSearchBar;

@property (weak, nonatomic) IBOutlet UITableView *searchMVTableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) int offset;

@property (nonatomic, strong) UIImage *iconImage;

@property (nonatomic, strong) MVListModel *listModel;

@end

@implementation MVSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
    [self initData];
    [self setupRefresh];
    _MVSearchBar.delegate = self;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    _offset = 0;
    [_dataSource removeAllObjects];
    [self requestData];
    [_MVSearchBar resignFirstResponder];
}


/**
 *  请求数据
 */
- (void)requestData{
    APISDK *apisdk = [[APISDK alloc] init];
    NSString *artist = [_MVSearchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    apisdk.interface = MV_Search([NSNumber numberWithInt:_offset], artist);
    [apisdk sendDataWithParamDictionary:nil requestMethod:get finished:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic = %@",dic);
        NSArray *videos = dic[@"videos"];
        if (videos.count > 0) {
            for (NSDictionary *video in videos) {
                MVListModel *model = [[MVListModel alloc] initWithDic:video];
                model.MVdescription = video[@"description"];
                [_dataSource addObject:model];
            }
        }
        _offset += 20;
        [_searchMVTableView reloadData];
        [self stopMJRefresh];
    } failed:^(NSInteger errorCode) {
        NSLog(@"errorCode = %ld",(long)errorCode);
        [self showHint:@"列表请求错误"];
        [self stopMJRefresh];
    }];
}

/**
 *  初始化数据
 */
- (void)initData{
    _dataSource = [[NSMutableArray alloc] init];
    _offset = 0;
}

- (IBAction)searchMV:(id)sender {
    _offset = 0;
    [_dataSource removeAllObjects];
    [self requestData];
    [_MVSearchBar resignFirstResponder];
}


/**
 *  集成刷新控件
 *
 *
 */
- (void)setupRefresh{
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    
    _searchMVTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
}

/**
 *  停止刷新
 */
- (void)stopMJRefresh{
    [_searchMVTableView.footer endRefreshing];
}

#pragma mark - UITableViewDelegate
- (MVSearchTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MVSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MVSearchTableViewCell"];
    MVListModel *model = _dataSource[indexPath.row];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.thumbnailPic] placeholderImage:[UIImage imageNamed:@"Jay.jpg"]];
    cell.titleLabel.text = model.title;
    cell.artistLabel.text = model.artistName;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MVListModel *model = _dataSource[indexPath.row];
    _listModel = model;
    MVSearchTableViewCell *cell = (MVSearchTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    _iconImage = cell.iconImageView.image;
    [self performSegueWithIdentifier:@"MVSearch" sender:self];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    PlayMVViewController *page = segue.destinationViewController;
    page.listModel = _listModel;
    page.backImage = _iconImage;
}

@end
