//
//  MyDownloadsViewController.m
//  smallMovie
//
//  Created by 程磊 on 15/9/23.
//  Copyright © 2015年 lei.cheng. All rights reserved.
//

#import "MyDownloadsViewController.h"
#import "MVSearchTableViewCell.h"
#import "ListModel.h"
#import "MVListModel.h"
#import "PlayMovieViewController.h"
#import "PlayMVViewController.h"
#import "AppDelegate.h"
#import "DownLoadModel.h"

@interface MyDownloadsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *dloadsTableView;

@property (nonatomic, strong) NSMutableArray *mvDataSource;

@property (nonatomic, strong) NSMutableArray *movieDataSoure;

@property (nonatomic, assign) NSInteger movieCount;//收藏电影的数量

@property (nonatomic, assign) NSInteger mvCount;//收藏MV的数量

@property (nonatomic, strong) NSMutableDictionary *totalDict;//存放所有的model，用来判断下载时的进度，因为这里用了通知来通知每一个下载的进度，如果用数组的话则每次都要遍历，这样对系统开销过于强大，因为字典中是采用hash算法直接根据key获取value，个人觉得会比较好一点

@property (nonatomic, strong) NSTimer *timer;//为了优化，1秒刷新一次


@end

@implementation MyDownloadsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    
    [self addNotifications];
    
    self.title = @"我的下载";
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshTableView) userInfo:nil repeats:YES];
}

- (void)refreshTableView{
    [_dloadsTableView reloadData];
}

- (void)addNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downProgress:) name:ISDOWNLOADING object:nil];
}

- (void)downProgress:(NSNotification *)noti{
    DownLoadModel *model = noti.object;
    NSLog(@"title = %@",model.title);
    NSLog(@"percent = %f",model.percent);
    id idModel = [_totalDict objectForKey:model.title];
    if ([idModel isKindOfClass:[ListModel class]]) {
        ListModel *listModel = [_totalDict objectForKey:model.title];
        listModel.percent = model.percent;
    } else {
        MVListModel *mvListModel = [_totalDict objectForKey:model.title];
        mvListModel.percent = model.percent;
    }
}

- (void)initData{
    _totalDict = [[NSMutableDictionary alloc] init];
    LKDBHelper *hepler = [LKDBHelper getUsingLKDBHelper];
    _movieCount = [hepler rowCount:[ListModel class] where:[NSString stringWithFormat:@"isDownload == 1 or isDownloading == 1"]];
    _movieDataSoure = [hepler search:[ListModel class] where:[NSString stringWithFormat:@"isDownload == 1 or isDownloading == 1"] orderBy:nil offset:0 count:_movieCount];
    _mvCount = [hepler rowCount:[MVListModel class] where:[NSString stringWithFormat:@"isDownload == 1 or isDownloading == 1"]];
    _mvDataSource = [hepler search:[MVListModel class] where:[NSString stringWithFormat:@"isDownload == 1 or isDownloading == 1"] orderBy:nil offset:0 count:_mvCount];
    if (_movieCount == 0 && _mvCount == 0) {
        [self showHint:@"无下载视频"];
    }
    for (ListModel *model in _movieDataSoure) {
        [_totalDict setObject:model forKey:model.title];
    }
    for (MVListModel *model in _mvDataSource) {
        [_totalDict setObject:model forKey:model.title];
    }
}


#pragma mark - UITableViewDelegate
- (MVSearchTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MVSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MVSearchTableViewCell"];
    if (indexPath.section == 0) {
        ListModel *model = _movieDataSoure[indexPath.row];
//        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:cell.progressLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:(APP_WIDTH * model.percent)];
//        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:cell.progressLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
//        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:cell.progressLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0];
//        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:cell.progressLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0];
//        cell.progressLabel.frame = CGRectMake(APP_WIDTH*model.percent, 0, APP_WIDTH, 100);
//        [cell.contentView addConstraint:leftConstraint];
//        [cell.contentView addConstraint:rightConstraint];
//        [cell.contentView addConstraint:topConstraint];
//        [cell.contentView addConstraint:bottomConstraint];

        

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
        if (_movieDataSoure.count > 0) {
            return _movieDataSoure.count;
        } else {
            return 0;
        }
    } else {
        if (_mvDataSource.count > 0) {
            return _mvDataSource.count;
        } else {
            return 0;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_mvDataSource.count > 0 && _movieDataSoure.count > 0) {
        return 2;
    } else if (_movieDataSoure.count > 0 || _mvDataSource.count > 0){
        return 1;
    } else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (_mvDataSource.count > 0 && _movieDataSoure.count > 0) {
        if (section == 0) {
            return @"我下载的电影";
        } else {
            return @"我下载的MV";
        }
    } else if (_movieDataSoure.count > 0){
        return @"我下载的电影";
    } else if (_mvDataSource.count > 0){
        return @"我下载的MV";
    } else {
        return nil;
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ListModel *model = _movieDataSoure[indexPath.row];
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *urlStr = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.mp4",VIDEO_Location,model.title]];
        [fileManager removeItemAtPath:urlStr error:nil];
        if (model.isSaved == NO) {
            [[LKDBHelper getUsingLKDBHelper] deleteToDB:model];
        } else {
            model.isDownload = NO;
            BOOL isSuccess = [[LKDBHelper getUsingLKDBHelper] insertToDB:model];
            if (isSuccess) {
                NSLog(@"更新成功");
            } else {
                NSLog(@"更新失败");
            }
        }
        [_movieDataSoure removeObject:model];
    } else {
        MVListModel *model = _mvDataSource[indexPath.row];
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *urlStr = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.mp4",VIDEO_Location,model.title]];
        [fileManager removeItemAtPath:urlStr error:nil];
        if (model.isSaved == NO) {
            [[LKDBHelper getUsingLKDBHelper] deleteToDB:model];
        } else {
            model.isDownload = NO;
            BOOL isSuccess = [[LKDBHelper getUsingLKDBHelper] insertToDB:model];
            if (isSuccess) {
                NSLog(@"更新成功");
            } else {
                NSLog(@"更新失败");
            }
        }
        [_mvDataSource removeObject:model];
    }
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_timer invalidate];
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
