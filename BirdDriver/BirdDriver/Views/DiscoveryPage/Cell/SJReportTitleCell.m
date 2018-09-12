//
//  SJReportTitleCell.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/18.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJReportTitleCell.h"
#import "JABBSModel.h"
#import "SJReportController.h"

@interface SJReportTitleCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation SJReportTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(id)model
{
    _model = model;
    if ([model isKindOfClass:[JABBSModel class]]) {
        JABBSModel *detailModel = (JABBSModel *)model;
        [self setDetailModel:detailModel];
    } else if ([model isKindOfClass:[SJReportCommentModel class]]) {
        SJReportCommentModel *commentModel = (SJReportCommentModel *)model;
        [self setCommentModel:commentModel];
    }
}

- (void)setCommentModel:(SJReportCommentModel *)commemtModel
{
    NSString *originStr = [NSString stringWithFormat:@"举报@%@的评论", commemtModel.replyUserName];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:originStr];
    [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"FFBB04" alpha:1.0]} range:[originStr rangeOfString:[NSString stringWithFormat:@"@%@", commemtModel.replyUserName]]];
    self.descLabel.attributedText = attr;
    self.contentLabel.text = [NSString stringWithFormat:@"%@：%@", commemtModel.replyUserName, commemtModel.replyContent];
}

- (void)setDetailModel:(JABBSModel *)detailModel
{
    NSString *originStr = [NSString stringWithFormat:@"举报@%@的帖子", detailModel.nickName];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:originStr];
    [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"FFBB04" alpha:1.0]} range:[originStr rangeOfString:[NSString stringWithFormat:@"@%@", detailModel.nickName]]];
    self.descLabel.attributedText = attr;
    
    self.contentLabel.text = detailModel.detail.detailsName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
