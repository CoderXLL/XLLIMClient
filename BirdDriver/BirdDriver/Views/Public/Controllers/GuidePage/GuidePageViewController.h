//
//  GuidePageViewController.h
//  GuidePage
//
//  Created by 宋明月 on 2018/1/5.
//  Copyright © 2018年 宋明月. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GuidePageBlock)(void);


@interface GuidePageViewController : UIViewController

@property (copy, nonatomic) GuidePageBlock guidePageBlock;

/**
 *  引导页初始化
 *
 *  @param imageArray           引导页图片
 *  @param containsButtons      包含Button
 *  @param containsPageControl  包含PageControl
 */
- (instancetype)initWithImageArray:(NSArray *)imageArray
                   containsButtons:(BOOL)containsButtons
               containsPageControl:(BOOL)containsPageControl;
/**
 *  设置PageControl样式
 *
 *  @param currentColor       PageControl当前圆点颜色
 *  @param pageColor          PageControl默认圆点颜色
 *  @param pagecontrolBottom  PageControl距离下屏幕距离
 */
-(void)setPageControlStyleWithCurrentPageTintColor:(UIColor *)currentColor
                                         pageColor:(UIColor *)pageColor
                                 pagecontrolBottom:(CGFloat)pagecontrolBottom;
/**
 *  设置Button文字样式
 *
 *  @param title       按钮文字
 *  @param titleColor  文字颜色
 *  @param bgColor     按钮背景颜色
 */
-(void)setButtonStyleWithTitle:(NSString *)title
                    titleColor:(UIColor *)titleColor
                       BgColor:(UIColor *)bgColor;
/**
 *  设置Button图片样式
 *
 *  @param buttonImage      文字图片
 */
-(void)setButtonStyleWithButtonImage:(UIImage *)buttonImage;

/**
 *  设置Button尺寸样式
 *
 *  @param cornerRadius 按钮圆角
 *  @param height       按钮高度
 *  @param width        按钮宽度
 *  @param bottom       按钮距离下屏幕距离
 */
-(void)setButtonStyleWithCornerRadius:(CGFloat)cornerRadius
                               height:(CGFloat)height
                                width:(CGFloat)width
                               bottom:(CGFloat)bottom;



@end
