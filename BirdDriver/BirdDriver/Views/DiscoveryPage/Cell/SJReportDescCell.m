//
//  SJReportDescCell.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/18.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJReportDescCell.h"
#import "SJReportChooseCell.h"

@interface SJReportDescCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation SJReportDescCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setChooseModel:(SJReportChooseModel *)chooseModel
{
    _chooseModel = chooseModel;
    self.iconView.image = chooseModel.isSelected?[UIImage imageNamed:@"report_sel"]:[UIImage imageNamed:@"report_nor"];
    self.descLabel.text = chooseModel.reason;
}

@end
