//
//  SJMineTableViewCell.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/16.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "SJMineTableViewCell.h"

@interface SJMineTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *topLine;
@property (weak, nonatomic) IBOutlet UILabel *shuLine;
@property (weak, nonatomic) IBOutlet UIView *circleView;

@property(nonatomic,retain)JATimeLineModel *timeLineModel;

@end

@implementation SJMineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.pictureImageView.layer.cornerRadius= 5.0;
    self.pictureImageView.clipsToBounds = YES;
}

-(void)deleteAction:(UIButton *)button{
    if (self.deleteModelBlock) {
        self.deleteModelBlock(self.timeLineModel);
    }
}

//重写选中与高亮状态子视图颜色
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.circleView.backgroundColor = [UIColor colorWithHexString:@"F7BC39" alpha:1.0];
    self.shuLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE" alpha:1.0];
    self.topLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE" alpha:1.0];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    self.circleView.backgroundColor = [UIColor colorWithHexString:@"F7BC39" alpha:1.0];
    self.shuLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE" alpha:1.0];
    self.topLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE" alpha:1.0];
}


- (void)setTimeModel:(JATimeLineModel *)model{
    self.timeLineModel = model;
    [self.deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    if (model.axisType == JAAxisTypePost) {
        self.typeLabel.text = @"发布了 帖子";
    } else if (model.axisType == JAAxisTypeActive){
        self.typeLabel.text = @"发布了 足迹";
    } else if (model.axisType == JAAxisTypePhoto){
        self.typeLabel.text = @"发布了 照片";
    }
    self.titleLabel.text = model.describtion;
    self.contentLabel.text = model.text;
    
    if ([model.picturesList count] > 0) {
        self.pictureImageViewWidth.constant = 85;
        [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:[model.picturesList firstObject]] placeholderImage:[UIImage imageNamed:@"default_picture"]];
    } else {
        self.pictureImageViewWidth.constant = 0;
        [self.pictureImageView setImage:[UIImage new]];
    }
    
//    NSString *timeString = [SPDateHandler getTimeLongStringFromTimestamp:model.createTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy MM月dd日 HH:mm";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(model.createTime/1000.0)];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    self.timeLabel.text = dateStr;
}

- (void)setIsTopLineHiden:(BOOL)isTopLineHiden
{
    _isTopLineHiden = isTopLineHiden;
    self.topLine.hidden = isTopLineHiden;
}


@end
