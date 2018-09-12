//
//  SJSegmentView.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/17.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "SJSegmentView.h"

@interface SJSegmentView ()<UIScrollViewDelegate>
/**
 *  configuration.
 */
{
    CGFloat _HeaderH;
    UIColor *_titleColor;
    UIColor *_titleSelectedColor;
    SJSegmentStyle _SegmentStyle;
    CGFloat _titleFont;
    CGFloat _titleSelectedFont;
}
/**
 *  The bottom red slider.
 */
@property (nonatomic, weak) UIView *slider;

@property (nonatomic, strong) NSMutableArray *titleWidthArray;

@property (nonatomic, weak) UIButton *selectedBtn;

@end

#define SJColorA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define SJScreenH [UIScreen mainScreen].bounds.size.height
#define SJScreenW [UIScreen mainScreen].bounds.size.width
@implementation SJSegmentView

#pragma mark - delayLoading
- (NSMutableArray *)titleWidthArray {
    if (!_titleWidthArray) {
        _titleWidthArray = [NSMutableArray new];
    }
    return _titleWidthArray;
}

#pragma mark - Initialization
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
//        self.layer.borderColor = SJColorA(204, 204, 204, 1).CGColor;
//        self.layer.borderWidth = 0.5;
        
        _HeaderH = frame.size.height;
        _SegmentStyle = SJSegmentStyleSlider;
        _titleColor = [UIColor colorWithHexString:@"888888" alpha:1];
        _titleSelectedColor = [UIColor colorWithHexString:@"2C344A" alpha:1];
        _titleFont = 14;
        _titleSelectedFont = 17;
    }
    return self;
}

- (void)setTitleArray:(NSArray<NSString *> *)titleArray {
    [self setTitleArray:titleArray withStyle:0];
}

- (void)setTitleArray:(NSArray<NSString *> *)titleArray withStyle:(SJSegmentStyle)style {
    [self setTitleArray:titleArray titleFont:0 titleColor:nil titleSelectedColor:nil withStyle:style];
}

- (void)setTitleArray:(NSArray<NSString *> *)titleArray
            titleFont:(CGFloat)font
           titleColor:(UIColor *)titleColor
   titleSelectedColor:(UIColor *)selectedColor
            withStyle:(SJSegmentStyle)style {
    
//    set style
    if (style != 0) {
        _SegmentStyle = style;
    }
    if (font != 0) {
        _titleFont = font;
    }
    if (titleColor) {
        _titleColor = titleColor;
    }
    if (selectedColor) {
        _titleSelectedColor = selectedColor;
    }
    
    if (style == SJSegmentStyleSlider) {
        UIView *slider = [[UIView alloc]init];
        slider.frame = CGRectMake(0, _HeaderH-3, 0, 3);
//        slider.backgroundColor = _titleSelectedColor;
        slider.backgroundColor = [UIColor colorWithHexString:@"FFBB04" alpha:1];
        [self addSubview:slider];
        self.slider = slider;
    }
    
    [self.titleWidthArray removeAllObjects];
    CGFloat totalWidth = 15;
    CGFloat btnSpace = 15;
    for (NSInteger i = 0; i<titleArray.count; i++) {
//        cache title width
        CGFloat titleWidth = [self widthOfTitle:titleArray[i] titleFont:_titleFont];
        [self.titleWidthArray addObject:[NSNumber numberWithFloat:titleWidth]];
//        creat button
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        CGFloat btnW = titleWidth+20;
        btn.frame =  CGRectMake(totalWidth, 0.5, btnW, _HeaderH-0.5-3);
        btn.contentMode = UIViewContentModeCenter;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.tag = i;
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:_titleColor forState:UIControlStateNormal];
        [btn setTitleColor:_titleSelectedColor forState:UIControlStateSelected];
        if (btn.selected) {
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:_titleSelectedFont];
        } else {
            btn.titleLabel.font = [UIFont systemFontOfSize:_titleFont];
        }
        [btn addTarget:self action:@selector(titleButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        totalWidth = totalWidth+btnW+btnSpace;

        if (i == 0) {
            btn.selected = YES;
            self.selectedBtn = btn;
            if (_SegmentStyle == SJSegmentStyleSlider) {
                self.slider.SJ_Width = titleWidth;
                self.slider.SJ_CenterX = btn.SJ_CenterX;
            }else if (_SegmentStyle == SJSegmentStyleZoom) {
                self.selectedBtn.transform = CGAffineTransformMakeScale(1.3, 1.3);
            }
        }
    }
    totalWidth = totalWidth+btnSpace;
    self.contentSize = CGSizeMake(totalWidth, 0);
}

- (void)clickButtonWithIndex:(NSString *)index
{
    UIButton *btn = [self.subviews objectAtIndex:index.integerValue+1];
    [self titleButtonSelected:btn];
}

//  button click
- (void)titleButtonSelected:(UIButton *)btn {
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    if (_SegmentStyle == SJSegmentStyleSlider) {
        NSNumber* sliderWidth = self.titleWidthArray[btn.tag];
        [UIView animateWithDuration:0.2 animations:^{
            self.slider.SJ_Width = sliderWidth.floatValue;
            self.slider.SJ_CenterX = btn.SJ_CenterX;
        }];
        for (UIView *subView in self.subviews) {
            
            if (![subView isKindOfClass:[UIButton class]]) continue;
            UIButton *currentBtn = (UIButton *)subView;
            currentBtn.titleLabel.font = [UIFont systemFontOfSize:_titleFont];
            if ([currentBtn isEqual:btn]) {
                currentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:_titleSelectedFont];
            }
        }
    }else if (_SegmentStyle == SJSegmentStyleZoom) {
        [UIView animateWithDuration:0.2 animations:^{
            self.selectedBtn.transform = CGAffineTransformIdentity;
            btn.transform = CGAffineTransformMakeScale(1.3, 1.3);
            
        }];
    }
    self.selectedBtn = btn;
    CGFloat offsetX = btn.SJ_CenterX - self.frame.size.width*0.5;
    if (offsetX<0) {
        offsetX = 0;
    }
    if (offsetX>self.contentSize.width-self.frame.size.width) {
        offsetX = self.contentSize.width-self.frame.size.width;
    }
    if (self.contentSize.width < self.frame.size.width) {
        offsetX = 0;
    }
    [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    if (self.titleChooseReturn) {
        self.titleChooseReturn(btn.tag);
    }
}
//  cache title width
- (CGFloat)widthOfTitle:(NSString *)title titleFont:(CGFloat)titleFont {
    CGSize titleSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, _HeaderH-3)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:titleFont] forKey:NSFontAttributeName]
                                            context:nil].size;
    return titleSize.width;
}

@end

@implementation UIView (SJViewFrame)

- (void)setSJ_Width:(CGFloat)SJ_Width {
    CGRect frame = self.frame;
    frame.size.width = SJ_Width;
    self.frame = frame;
}

- (CGFloat)SJ_Width {
    return self.frame.size.width;
}

- (void)setSJ_Height:(CGFloat)SJ_Height {
    CGRect frame = self.frame;
    frame.size.height = SJ_Height;
    self.frame = frame;
}

- (CGFloat)SJ_Height {
    return self.frame.size.height;
}

- (void)setSJ_CenterX:(CGFloat)SJ_CenterX {
    CGPoint center = self.center;
    center.x = SJ_CenterX;
    self.center = center;
}

- (CGFloat)SJ_CenterX {
    return self.center.x;
}

- (void)setSJ_CenterY:(CGFloat)SJ_CenterY {
    CGPoint center = self.center;
    center.y = SJ_CenterY;
    self.center = center;
}

- (CGFloat)SJ_CenterY {
    return self.center.y;
}
@end
