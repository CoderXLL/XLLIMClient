//
//  SJHomeFinancialCell.m
//  BirdDriver
//
//  Created by Soul on 2018/5/17.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "SJHomeFinancialCell.h"
#import "JABannerListModel.h"

@interface SJHomeFinancialCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@end

@implementation SJHomeFinancialCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 5.0;
    self.clipsToBounds = YES;
    self.bgView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgView.clipsToBounds = YES;
}

- (void)setBannerModel:(JABannerModel *)bannerModel
{
    _bannerModel = bannerModel;
//    self.titleLabel.text = bannerModel.bannerName;
    [self.bgView sd_setImageWithURL:bannerModel.picUrl.mj_url placeholderImage:[UIImage imageNamed:@"banner_bg_small_left"]];
}

@end
