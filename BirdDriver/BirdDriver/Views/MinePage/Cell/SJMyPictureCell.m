//
//  SJMyPictureCell.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/24.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJMyPictureCell.h"
#import "JAAtlasListModel.h"

@interface SJMyPictureCell ()

@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIImageView *placeHolderView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameWidthCons;


@end

@implementation SJMyPictureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.coverView.layer.cornerRadius = 5.0;
    self.coverView.clipsToBounds = YES;
}

- (void)setLasModel:(JAAtlasModel *)lasModel
{
    _lasModel = lasModel;
    self.nameLabel.text = lasModel.atlasName;
    self.selectView.hidden = (lasModel.showType != SJMyPictureShowTypeEdit);
    [self.placeHolderView sd_setImageWithURL:lasModel.coverImage.mj_url placeholderImage:[UIImage imageNamed:@"default_picture"]];
    self.selectView.image = lasModel.selected?[UIImage imageNamed:@"photo_selected"]:[UIImage imageNamed:@"photo_unSelect"];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    self.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);

    self.layer.shadowColor = [UIColor colorWithHexString:@"2B3248" alpha:1.0].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, -0.5);
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOpacity = 0.35;
    self.layer.masksToBounds = NO;
    CGFloat nameWidth = [self.nameLabel sizeThatFits:CGSizeMake(MAXFLOAT, 20)].width;
    self.nameWidthCons.constant = MIN(nameWidth, self.width - 5 - 10 - 20);
}

@end
