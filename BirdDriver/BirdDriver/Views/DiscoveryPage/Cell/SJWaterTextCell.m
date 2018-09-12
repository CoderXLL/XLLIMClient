//
//  SJWaterTextCell.m
//  BirdDriver
//
//  Created by liuzhangyong on 2018/7/31.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJWaterTextCell.h"
#import "JAActivityListModel.h"

@interface SJWaterTextCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UIButton *likeNumBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation SJWaterTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgView.layer.cornerRadius = 8.0;
    self.bgView.clipsToBounds = YES;
    self.headView.layer.cornerRadius = 12.5;
    self.headView.clipsToBounds = YES;
    //2B3248
    self.contentView.layer.shadowColor = [UIColor colorWithHexString:@"000000" alpha:1.0].CGColor;
    self.contentView.layer.shadowOffset = CGSizeMake(1, 1);
    self.contentView.layer.shadowOpacity = 0.25;
    self.contentView.layer.shadowRadius = 2.5;
    [self.likeNumBtn addTarget:self action:@selector(likeNumBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setPostModel:(JAPostsModel *)postModel
{
    [super setPostModel:postModel];
    
    self.titleLabel.text = postModel.detailsName;
    self.detailLabel.text = postModel.describtion;
    [self.headView sd_setImageWithURL:postModel.photoSrc.mj_url placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    self.nameLabel.text = postModel.nickName;
    [self.likeNumBtn setTitle:[NSString stringWithFormat:@"%ld", (long)postModel.praises] forState:UIControlStateNormal];
    self.likeNumBtn.selected = postModel.praisesId;
    
    CGFloat labelHeight = [self.titleLabel sizeThatFits:CGSizeMake(self.titleLabel.width, MAXFLOAT)].height+[self.detailLabel sizeThatFits:CGSizeMake(self.detailLabel.width, MAXFLOAT)].height;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSetupImageSize:)])
    {
        if (ABS(postModel.waterTextHeight - (labelHeight+70)) > 0.00001) {
            postModel.waterTextHeight = labelHeight+70;
            [self.delegate didSetupImageSize:postModel];
        }
    }
}

- (void)likeNumBtnClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickLikeBtn:)])
    {
        [self.delegate didClickLikeBtn:self.postModel];
    }
}

@end
