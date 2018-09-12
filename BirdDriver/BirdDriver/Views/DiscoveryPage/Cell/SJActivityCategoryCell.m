//
//  SJActivityCategoryCell.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/25.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJActivityCategoryCell.h"
#import "SJBuildNoteModel.h"

@interface SJActivityCategoryCell ()

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UIButton *arrowBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagLabelWidthCon;


@end

@implementation SJActivityCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tagLabel.layer.cornerRadius = 5;
    self.tagLabel.layer.borderWidth = 1.0;
    self.tagLabel.layer.borderColor = [UIColor colorWithHexString:@"CCCCCC" alpha:1].CGColor;
    self.tagLabel.textColor = [UIColor colorWithHexString:@"2B3248" alpha:1];
}

- (void)setMyTagModel:(JABbsLabelModel *)myTagModel
{
    _myTagModel = myTagModel;
    self.tagLabel.hidden = !myTagModel.isSelected;
    NSString *labelN = [myTagModel.labelName stringByReplacingOccurrencesOfString:@"#" withString:@""];
    self.tagLabel.text = labelN;
    CGSize tagSize = [labelN boundingRectWithSize:CGSizeMake(MAXFLOAT, 25) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SPFont(12.0)} context:nil].size;
    self.tagLabelWidthCon.constant = tagSize.width + 5;
}

- (void)setIsExpandStatus:(BOOL)isExpandStatus
{
    _isExpandStatus = isExpandStatus;
    if (isExpandStatus) {
        self.arrowBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    } else {
        self.arrowBtn.imageView.transform = CGAffineTransformIdentity;
    }
}

- (IBAction)expandBtnClick:(id)sender {
    
    if (self.expandBlock)
    {
        self.expandBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
