//
//  SJAttributedView.h
//  BirdDriver
//
//  Created by liuzhangyong on 2018/7/13.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SJAttributedView;

@protocol SJAttributedViewDelegate <NSObject>

- (void)didEndEdit:(SJAttributedView *)attributedView;
- (void)didChangeEdit:(SJAttributedView *)attributedView;

@end

@interface SJAttributedView : UITextView

@property (nonatomic, weak) id <SJAttributedViewDelegate>attributeDelegate;

- (void)reloadHeight;

- (void)addAttributesImage:(UIImage *)image;
@property (nonatomic, copy) void(^heightBlock)(CGFloat);

@end
