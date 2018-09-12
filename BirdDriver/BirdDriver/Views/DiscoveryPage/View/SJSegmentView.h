//
//  SJSegmentView.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/17.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^titleChooseBlock)(int x);

typedef NS_ENUM(NSInteger, SJSegmentStyle) {
    /**
     * By default, there is a slider on the bottom.
     */
    SJSegmentStyleSlider = 0,
    /**
     * This flag will zoom the selected text label.
     */
    SJSegmentStyleZoom   = 1,
};

@interface SJSegmentView : UIScrollView

@property (nonatomic, copy) titleChooseBlock titleChooseReturn;
/**
 * Set segment titles and titleColor.
 *
 * @param titleArray The titles segment will show.
 */
- (void)setTitleArray:(NSArray<NSString *> *)titleArray;

/**
 * Set segment titles and titleColor.
 *
 * @param titleArray The titles segment will show.
 * @param style The segment style.
 */
- (void)setTitleArray:(NSArray<NSString *> *)titleArray withStyle:(SJSegmentStyle)style;

/**
 * Set segment titles and titleColor.
 *
 * @param titleArray The titles segment will show.
 * @param titleColor The normal title color.
 * @param selectedColor The selected title color.
 * @param style The segment style.
 */
- (void)setTitleArray:(NSArray<NSString *> *)titleArray
            titleFont:(CGFloat)font
           titleColor:(UIColor *)titleColor
   titleSelectedColor:(UIColor *)selectedColor
            withStyle:(SJSegmentStyle)style;

- (void)clickButtonWithIndex:(NSString *)index;

@end

@interface UIView (SJViewFrame)

@property (nonatomic, assign) CGFloat SJ_Width;

@property (nonatomic, assign) CGFloat SJ_Height;

@property (nonatomic, assign) CGFloat SJ_CenterX;

@property (nonatomic, assign) CGFloat SJ_CenterY;

@end
