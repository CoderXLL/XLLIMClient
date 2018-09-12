//
//  SJUserNavView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/23.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SJUserNavType) {
    
    SJUserNavViewMine = 1000, //我的
    SJUserNavViewOther        //他人
};

@class SJOtherNavView;
@protocol SJOtherNavViewDelegate <NSObject>

- (void)navView:(SJOtherNavView *)navView didClick:(BOOL)isBack;

@end

@interface SJOtherNavView : UIView

@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, assign) CGFloat bgAlpha;
@property (nonatomic, assign) SJUserNavType navType;

@property (nonatomic, weak) id <SJOtherNavViewDelegate> delegate;

@end

