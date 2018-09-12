//
//  SJSheetCell.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/18.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJSheetCell.h"
#import "SJSheetView.h"

@interface SJSheetCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation SJSheetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSheetModel:(SJSheetModel *)sheetModel
{
    _sheetModel = sheetModel;
    if (sheetModel.actionType == SJSheetViewActionTypeBlocked) {
        self.descLabel.textColor = [UIColor colorWithHexString:@"BDBDBD" alpha:1.0];
    } else {
        self.descLabel.textColor = [UIColor colorWithHexString:@"2B3248" alpha:1.0];
    }
    self.descLabel.text = sheetModel.name;
    self.iconView.image = [UIImage imageNamed:sheetModel.imageStr];
}

@end
