//
//  SJCommentMessageTableViewCell.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/8/23.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJCommentMessageTableViewCell.h"

@implementation SJCommentMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.porImageView.layer.borderWidth = 2;
    self.porImageView.layer.masksToBounds = YES;
    self.mainPorImageView.layer.borderWidth = 2;
    self.mainPorImageView.layer.masksToBounds = YES;
    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick:)];
//    [self.bigView addGestureRecognizer:tapGesture];
    UITapGestureRecognizer *bigHeadGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigHeadGes:)];
    self.porImageView.userInteractionEnabled = YES;
    [self.porImageView addGestureRecognizer:bigHeadGes];
    
    UITapGestureRecognizer *smallHeadGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(smallHeadGes:)];
    self.mainPorImageView.userInteractionEnabled = YES;
    [self.mainPorImageView addGestureRecognizer:smallHeadGes];
    
    UITapGestureRecognizer *mainViewGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainViewGes:)];
    [self.mainView addGestureRecognizer:mainViewGes];
}

#pragma mark - event
- (void)bigHeadGes:(UIGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickBigHeadView:)])
    {
        [self.delegate didClickBigHeadView:self.model.sendUserId];
    }
}

- (void)mainViewGes:(UIGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickMainView:)])
    {
        [self.delegate didClickMainView:self.model.postId];
    }
}

- (void)smallHeadGes:(UIGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickSmallHeadView:)])
    {
        [self.delegate didClickSmallHeadView:self.model.nsjUserId];
    }
}

- (void)tapGestureClick:(UITapGestureRecognizer *)tapGesture
{
    
}


- (void)setModel:(JAMessageModel *)model
{
    _model = model;
    if ([model.sex isEqualToString:@"1"]) {
        self.porImageView.layer.borderColor = HEXCOLOR(@"6eebee").CGColor;
    } else {
       self.porImageView.layer.borderColor = HEXCOLOR(@"f9739b").CGColor;
    }
    [self.porImageView sd_setImageWithURL:[NSURL URLWithString:model.photoSrc] placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    self.nickName.text = model.nickName;
    self.timeLabel.text = [SPDateHandler getTimeLongStringFromTimestamp:model.createTime];
    
    if ([model.authorSex isEqualToString:@"1"]) {
        self.mainPorImageView.layer.borderColor = HEXCOLOR(@"6eebee").CGColor;
    } else {
        self.mainPorImageView.layer.borderColor = HEXCOLOR(@"f9739b").CGColor;
    } 
    [self.mainPorImageView sd_setImageWithURL:[NSURL URLWithString:model.authorPhotoSrc] placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    self.mainNickName.text = model.authorNickName;
    self.mainContent.text = model.detailsName;
    
    if (model.messageType == 2 || model.messageType == 1) {
        self.commentContent.attributedText = [self showContent:[NSString stringWithFormat:@"回复@%@：%@", model.subclassReplyNicKName, model.message] nickName:model.subclassReplyNicKName];
        self.returnContent.hidden = NO;
        self.returnContent.attributedText = [self showContent:[NSString stringWithFormat:@"@%@：%@",model.subclassReplyNicKName, model.subclassReply] nickName:model.subclassReplyNicKName];
        self.mainView.backgroundColor = [UIColor whiteColor];
        self.bigView.backgroundColor = HEXCOLOR(@"F6F7F8");
        self.mainTop.constant = 14.0f;
    } else {
        self.commentContent.text = model.message;
        self.returnContent.hidden = YES;
        self.bigView.backgroundColor = [UIColor whiteColor];
        self.mainView.backgroundColor = HEXCOLOR(@"F6F7F8");
        self.mainTop.constant = -14.0f;
    }
    
}

-(NSMutableAttributedString *)showContent:(NSString *)content nickName:(NSString *)nickName{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:content];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:14.0] range:[content rangeOfString:nickName]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];//调整行间距
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    return str;
}

@end
