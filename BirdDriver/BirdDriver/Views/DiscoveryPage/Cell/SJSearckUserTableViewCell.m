//
//  SJSearckUserTableViewCell.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/7/26.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJSearckUserTableViewCell.h"

@implementation SJSearckUserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.porImgeView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setUserInfo:(JAUserAccount *)model{
    [self.porImgeView sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl] placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    self.nickName.text = [model getShowNickName];
    //性别0是女，1是男
    if ([model.sex isEqualToString:@"1"]) {//男
        [self.genderImageView setImage:[UIImage imageNamed:@"mine_man"]];
    } else {//女
        [self.genderImageView setImage:[UIImage imageNamed:@"mine_woman"]];
    }
    
    self.attentionNum.text = [NSString stringWithFormat:@"关注：%ld",model.attentionNumber];
    self.fansNum.text = [NSString stringWithFormat:@"粉丝：%ld",model.fansNumber];
    self.activityNum.text = [NSString stringWithFormat:@"足迹：%ld",model.activityNum];
}



@end
