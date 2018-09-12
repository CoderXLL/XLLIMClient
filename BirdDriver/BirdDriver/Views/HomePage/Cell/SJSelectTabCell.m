//
//  SJSelectTabCell.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/6/7.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJSelectTabCell.h"
#import "JABbsLabelModel.h"

@interface SJSelectTabCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UILabel *hotLabel;

@end

@implementation SJSelectTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.hotLabel.layer.cornerRadius = 7.5;
    self.hotLabel.clipsToBounds = YES;
}

- (void)setLabelModel:(JABbsLabelModel *)labelModel
{
    _labelModel = labelModel;
    self.nameLabel.text = [labelModel.labelName stringByReplacingOccurrencesOfString:@"#" withString:@""];
    self.nameLabel.textColor = labelModel.isSelected?[UIColor colorWithHexString:@"2B3248" alpha:1]:[UIColor colorWithHexString:@"BDBDBD" alpha:1];
    self.selectView.hidden = !labelModel.isSelected;
}

@end
