//
//  MVSearchTableViewCell.m
//  smallMovie
//
//  Created by aayongche on 15/9/14.
//  Copyright (c) 2015年 lei.cheng. All rights reserved.
//

#import "MVSearchTableViewCell.h"

@implementation MVSearchTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setprogerssLabelContraint:(float)leadingContranit{
    self.leadingConstraint.constant = leadingContranit;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
