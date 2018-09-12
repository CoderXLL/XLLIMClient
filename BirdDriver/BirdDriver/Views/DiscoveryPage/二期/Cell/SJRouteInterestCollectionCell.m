//
//  SJRouteInterestCollectionCell.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/23.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJRouteInterestCollectionCell.h"
#import "JABBSModel.h"

@interface SJRouteInterestCollectionCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation SJRouteInterestCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconView.layer.borderWidth = 2.0;
    self.iconView.layer.cornerRadius = 22.5;
}

- (void)setIsMore:(BOOL)isMore
{
    _isMore = isMore;
    self.iconView.image = isMore?[UIImage imageNamed:@"route_more"]:[UIImage imageNamed:@"default_portrait"];
    self.nameLabel.hidden = isMore;
    self.sexView.hidden = isMore;
    self.iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.iconView.layer.borderWidth = 0;
}

- (void)setPosModel:(JAUserAccountPosList *)posModel
{
    _posModel = posModel;
    self.nameLabel.text = posModel.nickName;
    [self.iconView sd_setImageWithURL:posModel.photoSrc.mj_url placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    self.iconView.layer.borderColor = (posModel.sex==0)?[UIColor colorWithHexString:@"F9739B" alpha:1].CGColor:[UIColor colorWithHexString:@"6EEBEE" alpha:1].CGColor;
    self.iconView.layer.borderWidth = 2.0;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
//    CGFloat nameWidth = [self.nameLabel sizeThatFits:CGSizeMake(MAXFLOAT, 20)].width;
//    self.nameWidthCons.constant = MIN(nameWidth, self.contentView.width-27+3);
}

@end
