//
//  SJFootprintDetailsBriefCell.m
//  BirdDriver
//
//  Created by Soul on 2018/7/17.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJFootprintDetailsBriefCell.h"
#import "NSString+XHLStringSize.h"

@interface SJFootprintDetailsBriefCell()

@property (copy, nonatomic) NSString *briefStr;

@end

@implementation SJFootprintDetailsBriefCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.img_activityHead.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBriefStr:(NSString *)briefStr{
    self.tf_brief.text = briefStr;
    
    CGSize concentSize = [briefStr xhl_stringSizeWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:12]
                                                 maxWidth:(kScreenWidth - 30)];
    self.briefHeight.constant = concentSize.height + 10;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (IBAction)actionMember:(id)sender {
    LogD(@"点击了查看全部组员");
    if (self.memberBlock) {
        self.memberBlock(self.activityModel.detail.Id);
    }
}

- (IBAction)actionReport:(id)sender {
    LogD(@"点击了举报按钮");
    if (self.reportBlock) {
        self.reportBlock(self.activityModel.detail.Id);
    }
}

- (void)setActivityModel:(JABBSModel *)activityModel{
    _activityModel = activityModel;
    
    //作者名字
    if (activityModel.nickName) {
        [self.lbl_activityAuthor setTitle:activityModel.nickName forState:UIControlStateNormal];
    }
    
    //作者头像
    if (activityModel.photoSrc) {
        [self.img_activityHead sd_setImageWithURL:[NSURL URLWithString:activityModel.photoSrc]
                                 placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    }else{
        [self.img_activityHead setImage:[UIImage imageNamed:@"default_portrait"]];
    }
    
    //组员头像
    NSArray *headUserArr = activityModel.userAccountPOsList;
    if (headUserArr && headUserArr.count) {
          NSMutableArray *headImgArr = [NSMutableArray array];
        for (JAUserAccountPosList *user in headUserArr) {
            if (!kStringIsEmpty(user.photoSrc)) {
                [headImgArr addObject:user.photoSrc];
            }else{
                [headImgArr addObject:@"/"];
            }
        }
            [self refreashImageBox:headImgArr];
    }
    
    //足迹背景图
    if (activityModel.showImageUrl) {
        [self.img_activityShowImage sd_setImageWithURL:[NSURL URLWithString:activityModel.showImageUrl]];
    }
    
    //足迹标题
    if(activityModel.detail.detailsName){
        self.lbl_activityTitle.text = activityModel.detail.detailsName;
    }
    
    //足迹简介
     NSString *briefStr = @"";
    if (activityModel.detail.detailsText) {
        briefStr = self.activityModel?self.activityModel.detail.detailsText:@"";
    }
    self.tf_brief.text = briefStr;
    CGSize concentSize = [briefStr xhl_stringSizeWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14]
                                                 maxWidth:(kScreenWidth - 32)];
    self.briefHeight.constant = concentSize.height + 10;
    
    //评论数
    if (activityModel.detail.comments) {
        NSString *sum = [NSString stringWithFormat:@"%ld",activityModel.detail.comments?activityModel.detail.comments:0];
        self.lbl_commentSum.text = sum;
    } else {
        self.lbl_commentSum.text = @"0";
    }
    
    //评论时间
    if (activityModel.detail.finalWord) {
        self.lbl_lastCommentTime.text = activityModel.detail.finalWord;
    }else{
        self.lbl_commentSum.text = @"";
    }
}

- (IBAction)showShadowImgAction:(id)sender {
    NSArray *arr = @[];
    if (self.activityModel.showImageUrl) {
        arr = @[self.activityModel.showImageUrl];
    }
    
    if(self.showimgBlock && arr.count){
        self.showimgBlock(arr, 0);
    }
}

- (IBAction)showUserinfoAction:(id)sender {
    if (self.showUserinfoBlock) {
        self.showUserinfoBlock(self.activityModel.detail.detailsUserId);
    }
}



- (void)refreashImageBox:(NSArray *)imgArr{
    NSArray *btnArr = @[
                        self.img_memeber1,
                        self.img_memeber2,
                        self.img_memeber3,
                        self.img_memeber4
                        ];
    
    for (UIImageView *img in btnArr) {
        img.layer.borderColor = SP_WHITE_COLOR.CGColor;
        if (img.tag < imgArr.count) {
            [img setHidden:NO];
            NSString *str = imgArr[img.tag];
            if (str.length && (![str isEqualToString:@"/"])){
                [img sd_setImageWithURL:[NSURL URLWithString:str]];
            }
        }else{
            [img setHidden:YES];
        }
        
    }
}



@end
