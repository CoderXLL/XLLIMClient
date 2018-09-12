//
//  SJNoteTitleCell.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/16.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJNoteTitleCell.h"
#import "JABBSModel.h"
#import "GBTagListView.h"

@interface SJNoteTitleCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eyeLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *phraseLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet GBTagListView *tagView;

@end

@implementation SJNoteTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tagView.deleteHide = YES;
    self.tagView.signalTagColor = [UIColor whiteColor];
    
    self.headBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headBtn.imageView.clipsToBounds = YES;
}

- (void)setDetailModel:(JABBSModel *)detailModel
{
    _detailModel = detailModel;
    self.titleLabel.text = detailModel.detail.detailsName;
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:detailModel.detail.createTime/1000.0];
    self.dateLabel.text = [NSString stringWithFormat:@"发布于%@", [SPDateHandler getTimeLongStringFromTimestamp:detailModel.detail.createTime]];
    [self.headBtn sd_setImageWithURL:detailModel.photoSrc.mj_url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    self.nameLabel.text = detailModel.nickName;
    self.eyeLabel.text = [NSString stringWithFormat:@"%zd", detailModel.detail.pageviews];
    self.collectionLabel.text = [NSString stringWithFormat:@"%zd", detailModel.detail.collections];
    self.phraseLabel.text = [NSString stringWithFormat:@"%zd", detailModel.detail.praises];
    self.messageLabel.text = [NSString stringWithFormat:@"%zd", detailModel.detail.comments];
    NSMutableArray *tagArray = [NSMutableArray arrayWithCapacity:detailModel.detailsLabelsList.count];
    for (NSString *tagStr in detailModel.detailsLabelsList) {
        NSString *dealedStr = [tagStr stringByReplacingOccurrencesOfString:@"#" withString:@""];
        [tagArray addObject:dealedStr];
    }
    [self.tagView setTagWithTagArray:tagArray];
}

- (IBAction)headBtnClick:(id)sender {
    if (self.userDetailBlock) {
        self.userDetailBlock(self.detailModel);
    }
}

- (void)dealloc
{
    LogD(@"zoula")
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
