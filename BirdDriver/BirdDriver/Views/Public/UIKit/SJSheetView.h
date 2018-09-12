//
//  SJSheetView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/18.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SJSheetViewActionType) {
    
    SJSheetViewActionTypeCircle = 1000, //朋友圈
    SJSheetViewActionTypeFriend,        //好友
    SJSheetViewActionTypeReport,        //举报
    SJSheetViewActionTypeUnBlock,       //拉黑
    SJSheetViewActionTypeBlocked        //已拉黑
};

@interface SJSheetModel : SPBaseModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imageStr;
@property (nonatomic, assign) SJSheetViewActionType actionType;

@end

@interface SJSheetView : UIView

+ (instancetype)sheetViewWithSheetModels:(NSArray <SJSheetModel *>*)sheetModels ClickBlock:(void(^)(SJSheetViewActionType))clickBlock;

- (void)show;

@end
