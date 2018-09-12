//
//  JARouteListModel.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/27.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"

@class  JARouteListDataModel, JARouteListItemModel, JAUserAccountPosList;
@interface JARouteListModel : JAResponseModel

@property (nonatomic, strong) JARouteListDataModel *data;

@end

@interface JARouteListDataModel : JAResponseModel

@property (nonatomic, strong) NSMutableArray <JARouteListItemModel *>*list;

@end

@interface JARouteListItemModel : JAResponseModel

/**
 ID
 */
@property (nonatomic, assign) NSInteger ID;

/**
 路线发起人ID
 */
@property (nonatomic, assign) NSInteger userId;

/**
 路线发起人昵称
 */
@property (nonatomic, copy) NSString *nickName;

/**
 路线发起人头像
 */
@property (nonatomic, copy) NSString *photoSrc;

/**
 路线标题
 */
@property (nonatomic, copy) NSString *title;

/**
 标题标签,新字段
 */
@property (nonatomic, copy) NSString *titleLabels;

/**
 轮播图片集合
 */
@property (nonatomic, strong) NSArray <NSString *>*pictureUrl;

/**
 标签
 */
@property (nonatomic, copy) NSString *labels;

/**
 浏览量
 */
@property (nonatomic, assign) NSInteger pageviews;

/**
 点赞数
 */
@property (nonatomic, assign) NSInteger praiseNum;

/**
 点赞ID
 */
@property (nonatomic, assign) NSInteger praiseId;

/**
 收藏数
 */
@property (nonatomic, assign) NSInteger collection;

/**
 收藏ID
 */
@property (nonatomic, assign) NSInteger collectionId;

/**
 相关用户集合
 */
@property (nonatomic, strong) NSMutableArray <JAUserAccountPosList *>*collectionUserList;

/**
 正文描述
 */
@property (nonatomic, copy) NSString *describtion;

/**
 正文
 */
@property (nonatomic, copy) NSString *content;

/**
 创建时间
 */
@property (nonatomic, assign) long long createTime;

#pragma mark - custome properties
@property (nonatomic, assign) NSInteger currentIndex;


@end
