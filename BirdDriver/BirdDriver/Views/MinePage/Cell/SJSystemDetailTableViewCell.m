//
//  SJSystemDetailTableViewCell.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/8/24.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJSystemDetailTableViewCell.h"

@implementation SJSystemDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setSystemMessage:(JASystemModel *)model{
    self.messageTime.text = [SPDateHandler getTimeLongStringFromTimestamp:[model.createTime longLongValue]];
    self.messageTitle.text = model.messageTitle;
//    self.messageContent.text= model.messageContent;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.messageContent];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [model.messageContent length])];
    self.messageContent.attributedText = attributedString;
    [self.messageContent sizeToFit];

}

@end
