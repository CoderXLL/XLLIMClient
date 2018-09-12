//
//  SJMessageListTableViewCell.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/8/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJMessageListTableViewCell.h"

@implementation SJMessageListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.notReadNum.layer.masksToBounds = YES;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
