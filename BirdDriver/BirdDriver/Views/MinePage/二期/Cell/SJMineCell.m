//
//  SJMineCell.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJMineCell.h"

@implementation SJCellModel

@end

@interface SJMineCell ()

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation SJMineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - setter
- (void)setCellModel:(SJCellModel *)cellModel
{
    _cellModel = cellModel;
    self.descLabel.text = cellModel.title;
    self.iconView.image = [UIImage imageNamed:cellModel.iconName];
}

@end
