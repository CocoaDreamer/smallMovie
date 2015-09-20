//
//  MyCollectionViewController.m
//  smallMovie
//
//  Created by aayongche on 15/9/18.
//  Copyright © 2015年 lei.cheng. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "MVSearchTableViewCell.h"
#import "ListModel.h"
#import "MVListModel.h"
#import "PlayMovieViewController.h" 
#import "PlayMVViewController.h"
#import "AppDelegate.h"

@interface MyCollectionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myListTableView;

@property (nonatomic, strong) NSMutableArray *mvDataSource;

@property (nonatomic, strong) NSMutableArray *movieDataSoure;

@property (nonatomic, assign) NSInteger movieCount;//收藏电影的数量

@property (nonatomic, assign) NSInteger mvCount;//收藏MV的数量


@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    
    [self addNotifications];
}

- (void)addNotifications{
}

- (void)initData{
    _movieCount = [[LKDBHelper getUsingLKDBHelper] rowCount:[ListModel class] where:nil];
    _movieDataSoure = [[LKDBHelper getUsingLKDBHelper] search:[ListModel class] where:nil orderBy:nil offset:0 count:_movieCount];
    _mvCount = [[LKDBHelper getUsingLKDBHelper] rowCount:[MVListModel class] where:nil];
    _mvDataSource = [[LKDBHelper getUsingLKDBHelper] search:[MVListModel class] where:nil orderBy:nil offset:0 count:_mvCount];
}

- (MVSearchTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MVSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MVSearchTableViewCell"];
    if (indexPath.section == 0) {
        ListModel *model = _movieDataSoure[indexPath.row];
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.pimg] placeholderImage:[UIImage imageNamed:@"Jay.jpg"]];
        cell.titleLabel.text = model.title;
        cell.artistLabel.text = model.intro;
    } else {
        MVListModel *model = _mvDataSource[indexPath.row];
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.thumbnailPic] placeholderImage:[UIImage imageNamed:@"Jay.jpg"]];
        cell.titleLabel.text = model.title;
        cell.artistLabel.text = model.MVdescription;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexpath.row = %ld",(long)indexPath.row);
    if (indexPath.section == 0) {
        MVSearchTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        ListModel *model = _movieDataSoure[indexPath.row];
        PlayMovieViewController *vc = [[PlayMovieViewController alloc] init];
        vc.listModel = model;
        vc.backImage = cell.iconImageView.image;
        self.navigationController.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 1){
        MVSearchTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        MVListModel *model = _mvDataSource[indexPath.row];
        PlayMVViewController *vc = [[PlayMVViewController alloc] init];
        vc.listModel = model;
        vc.backImage = cell.iconImageView.image;
        self.navigationController.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [[LKDBHelper getUsingLKDBHelper] rowCount:[ListModel class] where:nil];
    } else {
        return [[LKDBHelper getUsingLKDBHelper] rowCount:[MVListModel class] where:nil];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"Movie";
    } else {
        return @"MV";
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ListModel *model = _movieDataSoure[indexPath.row];
        [[LKDBHelper getUsingLKDBHelper] deleteToDB:model];
    } else {
        MVListModel *model = _mvDataSource[indexPath.row];
        [[LKDBHelper getUsingLKDBHelper] deleteToDB:model];
    }
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
}

//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
//    return YES;
//}


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
