//
//  SJCreateGroupTableViewCell.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/25.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJCreateGroupTableViewCell.h"

@implementation SJCreateGroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (BOOL)canBecomeFirstResponder{
    return YES;
}

-(void)setGroupActivity:(JAActivityModel *)model{
    if ([model.imagesAddressList count] > 0) {
        [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:[model.imagesAddressList firstObject]] placeholderImage:[UIImage imageNamed:@"default_picture"]];
    }
    
    self.titleLabe.text = model.detailsName;
    self.contentLabel.text = model.describtion;
    CGFloat score = [model.average floatValue];
    self.starView.value = score;
    self.starValue.text = [NSString stringWithFormat:@"%.1f", score];
}

@end
