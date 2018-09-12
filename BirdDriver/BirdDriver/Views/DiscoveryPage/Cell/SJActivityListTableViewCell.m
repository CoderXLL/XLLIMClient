//
//  SJActivityListTableViewCell.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/28.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJActivityListTableViewCell.h"

@implementation SJActivityListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.hotBtn.hidden = YES;
    self.goodReputationBtn.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setActivityInfoAction:(JAActivityModel *)model{
    [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:[model.imagesAddressList firstObject]] placeholderImage:[UIImage imageNamed:@"default_picture"]];
    self.titlelabel.text = model.detailsName;
    self.describeLabel.text = [NSString stringWithFormat:@"%ld点评", (long)model.comments] ;
    CGFloat score = [model.average floatValue];
    self.starView.value = score;
    self.starValue.text = [NSString stringWithFormat:@"%.1f", score];
    [self.collectionBtn setTitle:[NSString stringWithFormat:@" %ld", (long)model.collections] forState:UIControlStateNormal];
}

@end
