//
//  SJDetailAttributedCell.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/16.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SPBaseCell.h"
@class SJAttachment;

@interface SJDetailAttributedCell : SPBaseCell

@property (nonatomic, copy) NSAttributedString *attributedString;
@property (nonatomic, copy) void(^clickBlock)(NSArray <SJAttachment *>*, NSInteger);

+ (CGFloat)cellHeightWithAttributedString:(NSAttributedString *)attributedString;


@end
