//
//  MVListTableViewCell.h
//  smallMovie
//
//  Created by aayongche on 15/9/14.
//  Copyright (c) 2015年 lei.cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MVListTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *listImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *artistLabel;

+ (MVListTableViewCell *)cellWithTable:(UITableView *)tableView;


@end
