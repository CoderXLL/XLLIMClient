//
//  SJRouteDescHeadView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/9/11.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SJRouteDescType) {
    
    SJRouteDescTypeIntroduce = 3, //路线介绍
    SJRouteDescTypeArrange = 5,   //行程安排
    SJRouteDescTypeSepcial = 6,   //鸟斯基special
    SJRouteDescTypeOther = 7,     //其他
    SJRouteDescTypeComment = 8    //热门评论
};

@interface SJRouteDescHeadView : UIView

@property (nonatomic, assign) SJRouteDescType descType;

@end
