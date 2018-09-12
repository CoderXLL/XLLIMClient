//
//  SJRouteInterestCollectionCell.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/23.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JAUserAccountPosList;
@interface SJRouteInterestCollectionCell : UICollectionViewCell

@property (nonatomic, assign) BOOL isMore;
@property (nonatomic, strong) JAUserAccountPosList *posModel;

@end
