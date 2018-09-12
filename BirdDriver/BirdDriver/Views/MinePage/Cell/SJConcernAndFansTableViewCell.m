//
//  SJConcernAndFansTableViewCell.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/19.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "SJConcernAndFansTableViewCell.h"
#import "JAUserPresenter.h"

@interface SJConcernAndFansTableViewCell ()

@property(strong, nonnull)JAUserAccount *model;

@end

@implementation SJConcernAndFansTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUser:(JAUserAccount *)userModel{
    self.model = userModel;
    [self.actionBtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];

    
    [self.porImageView sd_setImageWithURL:[NSURL URLWithString:userModel.imageAddress] placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    //昵称
    self.nameLabel.text = [userModel getShowNickName];
    
    self.signatureLabel.text = userModel.personalSign;
    self.porImageView.layer.borderWidth = 2.0;
    //性别0是女，1是男
    if ([userModel.sex isEqualToString:@"1"]) {//男
        self.porImageView.layer.borderColor = [UIColor colorWithHexString:@"6EEBEE" alpha:1].CGColor;
//        [self.genderImageView setImage:[UIImage imageNamed:@"mine_man"]];
    } else {//女
//        [self.genderImageView setImage:[UIImage imageNamed:@"mine_woman"]];
        self.porImageView.layer.borderColor = [UIColor colorWithHexString:@"F9739B" alpha:1].CGColor;
    }
    if (userModel.attentionType == AttentionTypeEachOtherConcern) {
        [self.actionBtn setImage:[UIImage imageNamed:@"attention_eachOther"]  forState:UIControlStateNormal];
    } else if (userModel.attentionType == AttentionTypeNotConcern){
        [self.actionBtn setImage:[UIImage imageNamed:@"attention"]  forState:UIControlStateNormal];
    } else if (userModel.attentionType == AttentionTypeConcern){
        [self.actionBtn setImage:[UIImage imageNamed:@"attention_cancel"]  forState:UIControlStateNormal];
    }
}


#pragma mark - 关注/取消关注/相互关注
-(void)action:(UIButton *)button{
    if (self.model.attentionType == AttentionTypeEachOtherConcern || self.model.attentionType ==AttentionTypeConcern ) {
        [self cancelConcernAction:self.model];
    } else if (self.model.attentionType == AttentionTypeNotConcern){
        [self concernAction:self.model];
    }
}

-(void)concernAction:(JAUserAccount *)user {
    [JAUserPresenter postAttentionUser:user.uid Result:^(JAAttentionUserModel * _Nullable model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (model.success) {
                if (model.focused) {
                    user.attentionType = AttentionTypeEachOtherConcern;
                } else {
                    user.attentionType = AttentionTypeConcern;
                }
            } else {
                [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            }
            [self setUser:user];
        });
    }];
}

-(void)cancelConcernAction:(JAUserAccount *)user  {
    [JAUserPresenter postCancelAttentionUser:user.uid Result:^(JAResponseModel * _Nullable model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (model.success) {
                user.attentionType = AttentionTypeNotConcern;
            } else {
                [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            }
            [self setUser:user];
        });
    }];
}


@end
