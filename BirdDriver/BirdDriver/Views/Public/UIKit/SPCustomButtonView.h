//
//  CustomButtonView.h
//  CherryFinancial
//
//  Created by polo on 2017/7/5.
//  Copyright © 2017年 Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPCustomButtonView : UIView

typedef void(^customButtonClickBlock)(UIButton *button);


@property (nonatomic,retain) NSString *customBtnTitle;

@property (nonatomic,retain) UIColor *customBtnTitleColor;

@property (nonatomic,retain) NSArray *customBtnGradientColors;

@property (nonatomic,retain) UIColor *customBtnBackgroudColor;

@property (nonatomic,retain) UIImage *customBtnBackgroudImage;

@property (nonatomic,assign) float cornerRadius;

@property (nonatomic,assign) BOOL customBtnEnable;

@property (nonatomic,strong) UIButton *customBtn;

@property (nonatomic,copy) void(^customButtonClickBlock)(UIButton *button);

- (void)customButtonClick:(customButtonClickBlock)customButtonClickBlock;


@end
