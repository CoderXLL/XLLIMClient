//
//  SJAddPictureCell.m
//  BirdDriver
//
//  Created by liuzhangyong on 2018/7/31.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJAddPictureCell.h"

@interface SJAddPictureCell ()

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation SJAddPictureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)setDescStr:(NSString *)descStr
{
    _descStr = [descStr copy];
    self.descLabel.text = descStr;
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
}

@end
