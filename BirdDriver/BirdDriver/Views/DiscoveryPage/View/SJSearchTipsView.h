//
//  SJSearchTipsView.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/6/11.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SearchBlcok) (NSString *string);


@interface SJSearchTipsView : UIView

@property (nonatomic, strong) NSArray *tipsArray;
@property (nonatomic,copy)SearchBlcok searchBlock;




- (instancetype)initWithFrame:(CGRect)frame;

@end
