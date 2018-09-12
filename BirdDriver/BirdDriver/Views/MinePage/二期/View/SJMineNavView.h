//
//  SJMineNavView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/24.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SJMineNavView;
@protocol SJMineNavViewDelegate <NSObject>

//点击设置
- (void)didClickSetBtn:(SJMineNavView *)navView;
//点击转发
- (void)didClickPostBtn:(SJMineNavView *)navView;

@end

@interface SJMineNavView : UIView

@property (nonatomic, assign) CGFloat bgAlpha;
@property (nonatomic, weak) id <SJMineNavViewDelegate> delegate;

@end
