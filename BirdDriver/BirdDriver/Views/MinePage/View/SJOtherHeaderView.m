//
//  SJOtherHeaderView.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/24.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJOtherHeaderView.h"

@interface SJOtherHeaderView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headTopCons;

@end

@implementation SJOtherHeaderView

+ (instancetype)createCellWithXib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SJOtherHeaderView" owner:nil options:nil] objectAtIndex:0];
}


- (void)awakeFromNib
{
    [super awakeFromNib];
   
    self.headTopCons.constant = kNavBarHeight+5; self.portraitImageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.portraitImageView.imageView.clipsToBounds = YES;
}


@end
