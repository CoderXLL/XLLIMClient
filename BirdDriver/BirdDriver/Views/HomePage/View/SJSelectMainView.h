//
//  SJSelectMainView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/6/7.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JARecommendDetailSpolistModel;

@interface SJSelectMainView : UIView

//推荐模型数组
@property (nonatomic, strong) NSArray <JARecommendDetailSpolistModel *>*recommendDetailsPOList;

@end
