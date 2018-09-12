//
//  SJSuffingCell.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/20.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJSuffingCell.h"

@interface SJSuffingCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeadCons;

@end

@implementation SJSuffingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = [imageUrl copy];
    [self.bannerImage sd_setImageWithURL:imageUrl.mj_url placeholderImage:[UIImage imageNamed:@"default_bannner"]];
}

- (void)setIsRadius:(BOOL)isRadius
{
    _isRadius = isRadius;
    self.imageLeadCons.constant = isRadius?15.0:0;
    self.bannerImage.layer.cornerRadius = isRadius?4.0:0;
    self.bannerImage.clipsToBounds = YES;
}

@end
