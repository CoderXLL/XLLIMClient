//
//  SJUpdateTipView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/14.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//  

#import <UIKit/UIKit.h>

@interface SJUpdateTipView : UIView

+ (instancetype)getUpdateTipView:(NSString *)appStoreVersion touchBlock:(void(^)(void))touchBlock;
- (void)show;

@end
