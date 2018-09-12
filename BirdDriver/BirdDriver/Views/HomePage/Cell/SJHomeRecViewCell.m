//
//  SJHomeRecViewCell.m
//  BirdDriver
//
//  Created by Soul on 2018/5/17.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "SJHomeRecViewCell.h"
#import "JABannerListModel.h"

@interface SJHomeRecViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation SJHomeRecViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.pictureView.contentMode = UIViewContentModeScaleAspectFill;
    self.pictureView.clipsToBounds = YES;
}

- (void)setBannerModel:(JABannerModel *)bannerModel
{
    _bannerModel = bannerModel;
    self.nameLabel.text = bannerModel.bannerName;
    [self.pictureView sd_setImageWithURL:bannerModel.picUrl.mj_url placeholderImage:[UIImage imageNamed:@"default_bannner"]];
}

@end
