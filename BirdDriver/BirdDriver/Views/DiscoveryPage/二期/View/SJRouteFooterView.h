//
//  SJRouteFooterView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/21.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJRouteFooterView : UIView

+ (instancetype)createCellWithXib;
@property (nonatomic, copy) NSString *htmlStr;
@property (nonatomic, copy) void(^heightBlock)(CGFloat);

@end
