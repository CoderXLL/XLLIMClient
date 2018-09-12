//
//  SJDetailNoteCell.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/6.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SPBaseCell.h"

@protocol SJDetailNoteCellDelegate <NSObject>

- (void)didClickImageUrl:(NSString *)imageStr AllImageArr:(NSArray *)imageArr;

@end

@interface SJDetailNoteCell : SPBaseCell

/**
 htmlString
 */
@property (nonatomic, copy) NSString *htmlString;
@property (nonatomic, weak) id <SJDetailNoteCellDelegate> delegate;
@property (nonatomic, copy) void (^heightBlock)(CGFloat);

@end
