//
//  SJNoDataFootView.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/29.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPCustomButtonView.h"

typedef NS_ENUM(NSInteger, SJExceptionStyle) {
    
    SJExceptionStyleNoData = 1000,
    SJExceptionStyleUnLogin,
    SJExceptionStyleNoNet
};

@interface SJNoDataFootView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet SPCustomButtonView *buttonView;

@property (nonatomic, assign) SJExceptionStyle exceptionStyle;
@property(nonatomic, assign)BOOL isShow;//是否显示按钮


+ (instancetype)createCellWithXib;

-(void)reloadView;

@end
