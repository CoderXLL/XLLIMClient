//
//  SJShareView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/6/26.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WXApi.h>

typedef NS_ENUM(NSInteger, SJShareViewActionType) {
    
    SJShareViewActionTypeCircle,  //朋友圈
    SJShareViewActionTypeFriend   //好友
};

@interface SJShareView : UIView

@property (nonatomic, copy) void(^clickBlock)(SJShareViewActionType actionType);
+ (instancetype)createCellWithXib;
- (void)show;

@end
