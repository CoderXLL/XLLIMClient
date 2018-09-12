//
//  SJPhotosController.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SPViewController.h"
#import "SJPhotoProtocol.h"
@class SJPhotoModel;

@interface SJPhotosController : SPViewController

@property (nonatomic, weak) id <SJPhotoProtocol> delegate;
/**
 已选中的图片集
 */
@property (nonatomic, strong) NSMutableArray <SJPhotoModel *>*selectedAssets;

/**
 最大限制数
 */
@property (nonatomic, assign) NSUInteger maximumLimit;

/**
 是否是头像
 */
@property (nonatomic, assign) BOOL isHead;

@end
