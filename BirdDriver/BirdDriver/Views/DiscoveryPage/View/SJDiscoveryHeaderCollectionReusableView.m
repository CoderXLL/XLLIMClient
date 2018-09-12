//
//  SJDiscoveryHeaderCollectionReusableView.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/18.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "SJDiscoveryHeaderCollectionReusableView.h"
#import "UIImage+ColorsImage.h"
#import "JABbsLabelModel.h"

@interface SJDiscoveryHeaderCollectionReusableView ()

@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UIButton *activitiesBtn;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;


@end

@implementation SJDiscoveryHeaderCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bannerImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick)];
    [self.bannerImageView addGestureRecognizer:tapGesture];
    
    self.bannerImageView.layer.masksToBounds = YES;
    self.activitiesBtn.layer.masksToBounds = YES;
    UIImage *backImage = [UIImage buttonImageFromColors:@[HEXCOLOR(@"7283B5"),HEXCOLOR(@"2C344A")] ByGradientType:uprightTolowLeft frame:self.activitiesBtn.bounds];
    [self.activitiesBtn setBackgroundImage:backImage forState:UIControlStateNormal];
}

- (void)setLabelModel:(JABbsLabelModel *)labelModel
{
    _labelModel = labelModel;
    [self.bannerImageView sd_setImageWithURL:labelModel.imagesAddress.mj_url placeholderImage:[UIImage imageNamed:@"default_picture"]];  // default_bannner
    self.descLabel.text = labelModel.describtion;
}

#pragma mark - event
- (void)tapGestureClick
{
    if (self.detailBlock) {
        self.detailBlock();
    }
}


@end
