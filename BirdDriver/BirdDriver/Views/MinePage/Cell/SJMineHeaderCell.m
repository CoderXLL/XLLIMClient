//
//  SJMineHeaderCell.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/6/13.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJMineHeaderCell.h"
#import "SJMineHeaderView.h"

@interface SJMineHeaderCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation SJMineHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItemModel:(SJHeaderItemModel *)itemModel
{
    _itemModel = itemModel;
    self.iconView.image = [UIImage imageNamed:itemModel.iconStr];
    self.nameLabel.text = itemModel.titleStr;
}

@end
