//
//  SJTReviewContentableViewCell.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/7/18.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJTReviewContentableViewCell.h"


@interface SJTReviewContentableViewCell ()

@end

@implementation SJTReviewContentableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contectView.zw_placeHolder = @"请在此编辑您对这儿体验后各方面感受";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
