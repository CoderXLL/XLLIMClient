//
//  SJMessageTableViewCell.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/30.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJMessageTableViewCell.h"
#import "JAMessagePresenter.h"
#import "JABbsPresenter.h"

@interface SJMessageTableViewCell ()

@property (nonatomic, strong) JAMessageModel *msgModel;

@end

@implementation SJMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick:)];
    self.porImageView.userInteractionEnabled = YES;
    [self.porImageView addGestureRecognizer:tapGesture];
}

- (void)tapGestureClick:(UIGestureRecognizer *)gesture
{
    if (self.headBlock) {
        self.headBlock(self.msgModel.sendUserId);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessageAction:(JAMessageModel *)model messageType:(JAMessageType)messageType{
    
    self.msgModel = model;
    self.porImageView.layer.borderWidth = 2;
    self.porImageView.layer.masksToBounds = YES;
    if ([model.sex isEqualToString:@"1"]) {
        self.porImageView.layer.borderColor = HEXCOLOR(@"6EEBEE").CGColor;
    } else {
        self.porImageView.layer.borderColor = HEXCOLOR(@"F9739B").CGColor;
    }
    self.nameLabel.textColor = SJ_TITLE_COLOR;
    [self.porImageView sd_setImageWithURL:[NSURL URLWithString:model.photoSrc]
                         placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    self.timeLabel.text = [SPDateHandler getTimeLongStringFromTimestamp:model.createTime];
    self.nameLabel.text = model.message;
    if (model.messageType == MessageTypeAttention) {// 关注4
        [self showLabelName:model.nickName message:[NSString stringWithFormat:@"%@ %@", model.nickName , model.message] title: @""];
    }else if (model.messageType == MessageTypeLike){//点赞
        if (model.title.length == 0) {
            model.title = @"";
        }
        [self showLabelName:model.nickName message:[NSString stringWithFormat:@"%@ %@", model.nickName , model.message] title: model.title];
    }
}

-(void)showLabelName:(NSString *)nickName message:(NSString *)message title:(NSString *)title{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:message];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Medium" size:15.0] range:[message rangeOfString:nickName]];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Medium" size:15.0] range:[message rangeOfString:title]];
    self.nameLabel.attributedText = str;
}



@end
