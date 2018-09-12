//
//  SJRouteTitleCell.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/23.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJRouteTitleCell.h"
#import "JARouteListModel.h"

@interface SJRouteTitleCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *seenLabel;

@end

@implementation SJRouteTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - setter
- (void)setItemModel:(JARouteListItemModel *)itemModel
{
    _itemModel = itemModel;
    self.titleLabel.text = itemModel.title;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月dd日";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(itemModel.createTime/1000.0)];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    self.timeLabel.text = [NSString stringWithFormat:@"发布于：%@", dateStr];
    
    if (itemModel.pageviews < 10000) {
        self.seenLabel.text = [NSString stringWithFormat:@"%zd", itemModel.pageviews];
    } else {
        CGFloat pageNum = itemModel.pageviews*1.0/10000;
        self.seenLabel.text = [NSString stringWithFormat:@"%.1fW", pageNum];
    }
}

@end
