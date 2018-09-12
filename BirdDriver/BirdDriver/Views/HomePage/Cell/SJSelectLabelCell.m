//
//  SJSelectLabelCell.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/29.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJSelectLabelCell.h"
#import "JAActivityListModel.h"
#import "SJPostsCenterButton.h"

@interface SJSelectLabelCell ()

@property (weak, nonatomic) IBOutlet SJPostsCenterButton *infoBtn;

@end

@implementation SJSelectLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setActivityModel:(JAActivityModel *)activityModel
{
    _activityModel = activityModel;
    self.nameLabel.text = activityModel.detailsName;
    [self.pictureImageView sd_setImageWithURL:activityModel.imagesAddressList.firstObject.mj_url placeholderImage:[UIImage imageNamed:@"default_picture"]];
    self.infoBtn.titleStr = activityModel.nickName;
    if (kStringIsEmpty(activityModel.photoSrc)) {
        [self.infoBtn setImage:[UIImage imageNamed:@"default_portrait"] forState:UIControlStateDisabled];
    } else {
        [self.infoBtn sd_setImageWithURL:activityModel.photoSrc.mj_url forState:UIControlStateDisabled placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.bgView.layer.shadowColor = HEXCOLOR(@"000000").CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(2, 2);
    self.bgView.layer.shadowOpacity = 0.15;
    self.bgView.layer.shadowRadius = 3.0;
    self.pictureImageView.layer.masksToBounds = YES;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bgView.bounds);
    self.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
}

@end
