//
//  JAActivityListModel.h
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/31.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"

@class JAActivityModel,JAPostsModel;

@interface JAActivityListModel : JAResponseModel

/**
 活动集合Model
 */
@property (nonatomic, strong) NSArray<JAActivityModel *> *activitysList;

/**
 帖子集合Model
 */
@property (nonatomic, strong) NSArray<JAPostsModel *> *postsList;

@end

/**
 鸟斯基 活动Model
 */
@interface JAActivityModel : JAResponseModel

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) NSInteger collectionId;

@property (nonatomic, assign) NSInteger detailsUserId;

@property (nonatomic, copy) NSString *detailsLabels;

@property (nonatomic, copy) NSString *detailsName;

@property (nonatomic, assign) NSInteger collections;

@property (nonatomic, strong) NSArray<NSString *> *imagesAddressList;

@property (nonatomic, assign) NSInteger praises;

@property (nonatomic, assign) long long createTime;

@property (nonatomic, copy) NSString *describtion;

@property (nonatomic, copy) NSString *photoSrc;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, assign) NSInteger comments;

@property (nonatomic, assign) NSInteger pageviews;

@property (nonatomic, strong) NSNumber *average;

#pragma mark - 自定义字段
// 是否为我收藏的活动
@property (nonatomic, assign) BOOL isMyCollection;
// 轮播滚到哪一页
@property (nonatomic, assign) NSInteger currentIndex;

@end

/**
 鸟斯基 帖子Model
 */

@interface JAPostsModel : JAResponseModel

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) NSInteger detailsUserId;

@property (nonatomic, copy) NSString *detailsLabels;

@property (nonatomic, copy) NSString *detailsName;

@property (nonatomic, assign) NSInteger collections;

@property (nonatomic, strong) NSArray<NSString *> *imagesAddressList;

@property (nonatomic, assign) NSInteger praises;

@property (nonatomic, assign) long long createTime;

@property (nonatomic, copy) NSString *describtion;

@property (nonatomic, copy) NSString *photoSrc;

@property (nonatomic, assign) NSInteger pageviews;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, strong) NSNumber *average;

@property (nonatomic, strong) NSNumber *praisesId;

@property (nonatomic, assign) JAPostsRunStatus runStatus;


#pragma mark - 自定义属性
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) CGFloat imageHeight;

//纯文本高度
@property (nonatomic, assign) CGFloat waterTextHeight;

@end
