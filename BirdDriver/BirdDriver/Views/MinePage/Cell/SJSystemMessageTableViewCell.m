//
//  SJSystemMessageTableViewCell.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/8/23.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJSystemMessageTableViewCell.h"

static float textHeight  = 50.0;         //文字估高

@implementation SJSystemMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.bgView.bounds;
//    maskLayer.path = maskPath.CGPath;
//    self.bgView.layer.mask = maskLayer;
    
    self.bgView.layer.cornerRadius = 10;
    
    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(2, 5);
    self.bgView.layer.shadowOpacity = 0.5;
    self.bgView.layer.shadowRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setSystemMessage:(JASystemModel *)model{
    self.timeLabel.text = [SPDateHandler getTimeLongStringFromTimestamp:[model.createTime longLongValue]];
    self.messageTitle.text = model.messageTitle;
    self.messageContent.text= model.messageContent;
    textHeight = [self.messageContent sizeThatFits:self.messageContent.size].height;
    //1纯文字 2链接图文
    if (model.messageType == 2) {
        self.messagePicture.hidden = NO;
        [self.messagePicture sd_setImageWithURL:[NSURL URLWithString:model.imagesAddress] placeholderImage:[UIImage imageNamed:@"default_picture"]];
    } else {
        self.messagePicture.hidden = YES;
    }
}

+ (CGFloat)cellHeightWithMessageModel:(JASystemModel *)messageModel
{
    if (messageModel.messageType==2){
        return textHeight+139+(kScreenWidth-114)*110.0/263+40;
    }
    return textHeight+139+10;
}

@end
