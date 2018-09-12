//
//  SJMyCollectionNavView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/21.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SJMyCollectionNavViewAction) {
    
    SJMyCollectionNavViewActionNote = 1000, //帖子
    SJMyCollectionNavViewActionActivity     //活动
};

@interface SJMyCollectionNavView : UIView



//帖子
@property (nonatomic, weak) UIButton *noteBtn;
//活动
@property (nonatomic, weak) UIButton *activityBtn;
//分割线
@property (nonatomic, weak) UIView *sepratorView;


@end
