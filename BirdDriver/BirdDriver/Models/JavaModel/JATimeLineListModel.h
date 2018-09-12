//
//  JATimeLineListModel.h
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/31.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"

@class JATimeLineModel;

typedef NS_ENUM(NSInteger, JAAxisType){
    JAAxisTypePost      = 1,   //发帖
    JAAxisTypeActive    = 2,   //发起活动
    JAAxisTypePhoto     = 3    //上传图片
};

@interface JATimeLineListModel : JAResponseModel

@property (nonatomic, strong) NSMutableArray<JATimeLineModel *> *timeAxisPOList;

@end

@interface JATimeLineModel : JAResponseModel

/**
 图集
 */
@property (nonatomic, strong) NSArray<NSString *> *picturesList;

/**
 用户操作功能相关id
 */
@property (nonatomic, assign) NSInteger detailsId;

/**
 ID
 */
@property (nonatomic, assign) NSInteger ID;

/**
 相关用户id
 */
@property (nonatomic, assign) NSInteger axisUserId;

/**
 时间轴类型：1：发帖，2：发起活动，3：上传图片
 */
@property (nonatomic, assign) JAAxisType axisType;

/**
 正文
 */
@property (nonatomic, copy) NSString *text;

/**
 信息生成时间
 */
@property (nonatomic, assign) long long createTime;

/**
 标题&&简介
 */
@property (nonatomic, copy) NSString *describtion;

@end

