//
//  SJDiscoveryHeaderCollectionReusableView.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/18.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JABbsLabelModel;

@interface SJDiscoveryHeaderCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) JABbsLabelModel *labelModel;
@property (nonatomic, copy) void(^detailBlock)(void);


@end
