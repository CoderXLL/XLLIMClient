//
//  SJPicturesController.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/24.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//  子图册

#import "SPViewController.h"
@class JAAtlasModel;

@interface SJPicturesController : SPViewController

//是否能添加图片
@property (nonatomic, assign) BOOL canAddPhoto;
@property (nonatomic, strong) JAAtlasModel *lasModel;
@property (nonatomic, copy) void(^updateCoverBlock)(NSInteger atlasId, NSString *newCover);

@end
