//
//  JARouteDetailModel.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/27.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"

@class JARouteListItemModel;
@interface JARouteDetailModel : JAResponseModel

@property (nonatomic, strong) JARouteListItemModel *routeVO;

@end
