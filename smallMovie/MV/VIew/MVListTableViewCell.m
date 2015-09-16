//
//  MVListTableViewCell.m
//  smallMovie
//
//  Created by aayongche on 15/9/14.
//  Copyright (c) 2015年 lei.cheng. All rights reserved.
//

#import "MVListTableViewCell.h"

@implementation MVListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (MVListTableViewCell *)cellWithTable:(UITableView *)tableView {
    MVListTableViewCell * cell = (MVListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MVListTableViewCell"];
    if (cell == nil) {
        cell = [[MVListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MVListTableViewCell"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _listImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130, 80)];
        [self.contentView addSubview:_listImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 10, APP_WIDTH-160, 30)];
        _titleLabel.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:_titleLabel];
        
        _artistLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 40, APP_WIDTH-160, 20)];
        _artistLabel.font = [UIFont systemFontOfSize:17.0];
        _artistLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:_artistLabel];
    }
    return self;
}

@end
