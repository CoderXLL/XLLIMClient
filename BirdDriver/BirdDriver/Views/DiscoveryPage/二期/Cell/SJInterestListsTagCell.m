//
//  SJInterestListsTagCell.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/28.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJInterestListsTagCell.h"
#import "SJGradientLabel.h"

@interface SJInterestListsTagCell ()

@property (weak, nonatomic) IBOutlet SJGradientLabel *tagLabel;

@end

@implementation SJInterestListsTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setLabel:(NSString *)label
{
    _label = [label copy];
    self.tagLabel.descStr = label;
}

@end
