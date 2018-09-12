//
//  JABBSModel.h
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/28.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"

@class JABbsDetailModel,JAUserAccountPosList;

@interface JABBSModel : JAResponseModel

@property (nonatomic, strong) JABbsDetailModel *detail;

@property (nonatomic, copy) NSString *praiseId;

@property (nonatomic, strong) NSArray<NSString *> *picAddList;

@property (nonatomic, copy) NSString *photoSrc;

@property (nonatomic, strong) NSArray<NSString *> *detailsLabelsList;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, copy) NSString *showImageUrl;

@property (nonatomic, strong) NSArray<NSNumber *> *userIdsList;

@property (nonatomic, strong) NSArray<JAUserAccountPosList *> *userAccountPOsList;

@property (nonatomic, assign) NSInteger collectionId;

@end

@interface JABbsDetailModel : NSObject

@property (nonatomic, copy) NSString *detailsMainLabel;

@property (nonatomic, assign) BOOL isDeleted;

@property (nonatomic, copy) NSString *deviceId;

@property (nonatomic, assign) JAPostsRunStatus runStatus;

@property (nonatomic, assign) NSInteger praises;

@property (nonatomic, assign) NSInteger pageviews;

@property (nonatomic, assign) NSInteger deviceType;

@property (nonatomic, copy) NSString *deviceName;

/**
 平均分
 */
@property (nonatomic, assign) NSInteger average;

@property (nonatomic, copy) NSString *titleKeywords;

@property (nonatomic, copy) NSString *detailsLabelsTypes;

@property (nonatomic, copy) NSString *describtion;

@property (nonatomic, assign) long long endTime;

@property (nonatomic, copy) NSString *detailsBasicInfo;

/**
 类型:1.帖子,2.活动
 */
@property (nonatomic, assign) NSInteger detailsType;

/**
 发帖人id
 */
@property (nonatomic, assign) NSInteger detailsUserId;

@property (nonatomic, assign) long long lastUpdateTime;

@property (nonatomic, assign) NSInteger openStatus;

@property (nonatomic, copy) NSString *textKeywords;

@property (nonatomic, assign) NSInteger Id;

/**
 帖子/活动图片地址，以英文逗号分隔
 */
@property (nonatomic, copy) NSString *imagesAddress;

@property (nonatomic, assign) NSInteger comments;

/**
 帖子/活动标题
 */
@property (nonatomic, copy) NSString *detailsName;

@property (nonatomic, assign) long long createTime;

@property (nonatomic, assign) NSInteger collections;

@property (nonatomic, copy) NSString *remark;

/**
 帖子/活动正文，可存正文文件地址或是正文内容
 */
@property (nonatomic, copy) NSString *detailsText;

@property (nonatomic, copy) NSString *detailsLabels;

@property (nonatomic, assign) long long startTime;

/**
 帖子最后评论时间 by焦飞翔 20180718
 */
@property (nonatomic, copy) NSString *finalWord;

@property (nonatomic, copy) NSString *finalCommentTime;

#pragma mark - custome properties
@property (nonatomic, assign) CGFloat titleCellHeight;
@property (nonatomic, assign) CGFloat detailCellHeight;
@property (nonatomic, copy) NSAttributedString *attributedString;

@end

@interface JAUserAccountPosList : NSObject

@property (nonatomic, assign) NSInteger Id;

/**
 昵称
 */
@property (nonatomic, copy) NSString *nickName;

/**
 头像
 */
@property (nonatomic, copy) NSString *photoSrc;

/**
 性别 0女 1男
 */
@property (nonatomic, assign) NSInteger sex;

/**
 用户标签
 */
@property (nonatomic, strong) NSArray<NSString *> *labelsList;

/**
 个性签名
 */
@property (nonatomic, copy) NSString *personalSign;

@end

