//
//  JAPostCommentModel.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/9/3.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"

@class JAPostCommentDataModel;
@interface JAPostCommentModel : JAResponseModel

@property (nonatomic, strong) JAPostCommentDataModel *data;

@end

@class JAPostCommentItemModel;
@interface JAPostCommentDataModel : SPBaseModel

@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger startRow;
@property (nonatomic, assign) NSInteger endRow;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger prePage;
@property (nonatomic, assign) NSInteger nextPage;
@property (nonatomic, assign) BOOL isFirstPage;
@property (nonatomic, assign) BOOL isLastPage;
@property (nonatomic, assign) BOOL hasPreviousPage;
@property (nonatomic, assign) BOOL hasNextPage;
@property (nonatomic, assign) NSInteger navigatePages;
@property (nonatomic, strong) NSMutableArray <JAPostCommentItemModel *>*list;

@end

@class JACommentVOModel;
@interface JAPostCommentItemModel : JAResponseModel

/**
 评论Id
 */
@property (nonatomic, assign) NSInteger ID;

/**
 帖子Id
 */
@property (nonatomic, assign) NSInteger detailId;

/**
 评论人Id
 */
@property (nonatomic, assign) NSInteger userId;

/**
 评论人昵称
 */
@property (nonatomic, copy) NSString *nickName;

/**
 评论人头像
 */
@property (nonatomic, copy) NSString *photoSrc;

/**
 评论人性别 1男 0女
 */
@property (nonatomic, assign) NSInteger sex;

/**
 评论插图
 */
@property (nonatomic, copy) NSString *imagesAddress;

/**
 评论内容
 */
@property (nonatomic, copy) NSString *content;

/**
 评分
 */
@property (nonatomic, assign) NSInteger score;

/**
 评论点赞数
 */
@property (nonatomic, assign) NSInteger praiseNum;

/**
 评论被踩数
 */
@property (nonatomic, assign) NSInteger negativeNum;

/**
 直属子评论数
 */
@property (nonatomic, assign) NSInteger sonCommentNum;

/**
 评论时间
 */
@property (nonatomic, assign) long long createTime;

/**
 所有子评论数
 */
@property (nonatomic, assign) NSInteger childCommentNum;

/**
 子评论详情
 */
@property (nonatomic, strong) JACommentVOModel *commentVO;

@property (nonatomic, assign) CGFloat cellHeight;

@end

@interface JACommentVOModel : JAResponseModel

/**
 子评论内容
 */
@property (nonatomic, copy) NSString *content;

/**
 子评论时间戳
 */
@property (nonatomic, assign) long long createTime;

/**
 帖子Id
 */
@property (nonatomic, assign) NSInteger detailId;

/**
 这条评论Id
 */
@property (nonatomic, assign) NSInteger ID;

/**
 评论插图
 */
@property (nonatomic, copy) NSString *imagesAddress;

/**
 评论人昵称
 */
@property (nonatomic, copy) NSString *nickName;

/**
 评论人头像
 */
@property (nonatomic, copy) NSString *photoSrc;

/**
 评论人Id
 */
@property (nonatomic, assign) NSInteger userId;

/**
 被回复人Id
 */
@property (nonatomic, assign) NSInteger replyUserId;

/**
 被回复人昵称
 */
@property (nonatomic, copy) NSString *replyNickName;

/**
 评论人性别 0女 1男
 */
@property (nonatomic, assign) NSInteger sex;

/**
 父评论Id
 */
@property (nonatomic, assign) NSInteger superCommentId;

@property (nonatomic, assign) CGFloat cellHeight;

@end


