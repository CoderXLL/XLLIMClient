//
//  CustomNullDataView.h
//  CherryFinancial
//
//  Created by zhangyong liu on 2017/7/18.
//  Copyright © 2017年 Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CustomNullDataViewClickBlock)(void);

@interface CustomNullDataView : UIView

@property (nonatomic,copy) NSString * _Nullable title;
@property (nonatomic,retain) UIImage * _Nullable image;
@property (nonatomic,copy) CustomNullDataViewClickBlock  _Nullable clickBlock;


/**
 显示无数据视图
 
 @param view 将要添加到的view
 @param replaceView 被替换的view
 */
- (void)showViewAddTo:(UIView * _Nonnull)view replaceView:(UIView *_Nullable)replaceView clickBlock:(CustomNullDataViewClickBlock _Nullable )clickBlock;


/**
 移除视图
 */
- (void)dismiss;
@end
