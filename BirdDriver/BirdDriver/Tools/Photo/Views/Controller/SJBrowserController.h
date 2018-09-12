//
//  SJBrowserController.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/24.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//  相册查看器

#import "SPViewController.h"
@class SJPhotoModel, JAPhotoModel;

@interface SJBrowserController : SPViewController

//当前图片的位置
@property (nonatomic, assign) NSInteger currentIndex;
//所有图片集合
@property (nonatomic, strong) NSMutableArray *fetchPhotoResults;
//图集ID
@property (nonatomic, assign) NSInteger lasID;
//是否不可以编辑 YES 不可编辑  NO可编辑
@property (nonatomic, assign) BOOL noEdit;

@property (nonatomic, copy) void (^deleteBlock)(JAPhotoModel *);

@end
