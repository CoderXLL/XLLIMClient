//
//  SJCommentReportView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/18.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJCommentReportView : UIView

+ (instancetype)createCommentReportView:(void(^)(void))clickBlock;
- (void)showInLocation:(CGPoint)location;

@end
