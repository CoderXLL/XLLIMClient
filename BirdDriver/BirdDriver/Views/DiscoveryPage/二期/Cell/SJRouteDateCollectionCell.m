//
//  SJRouteDateCollectionCell.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/9/11.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJRouteDateCollectionCell.h"

@implementation SJRouteDateCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.layer.cornerRadius = 4.0;
    self.clipsToBounds = YES;
}

@end
