//
//  SJCommentListModel.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/16.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"
@class JACommentModel;

@interface JACommentListModel : JAResponseModel

@property (nonatomic, strong) NSMutableArray <JACommentModel *>*commentsList;

@end

@interface JACommentModel : SPBaseModel

@property (nonatomic, assign) NSInteger ID;

/**
 相关评论id
 */
@property (nonatomic, assign) NSInteger commentId;

/**
 评论内容
 */
@property (nonatomic, copy) NSString *commentText;

/**
 评论人id
 */
@property (nonatomic, assign) NSInteger commentUserId;

/**
 评论时间
 */
@property (nonatomic, assign) long long createTime;

/**
 帖子或活动id
 */
@property (nonatomic, assign) NSInteger detailsId;

/**
 图片地址，以，隔开
 */
@property (nonatomic, strong) NSArray <NSString *>*imagesAddressList;

/**
 被踩数
 */
@property (nonatomic, assign) NSInteger negative;

/**
 昵称
 */
@property (nonatomic, copy) NSString *nickName;

/**
 头像
 */
@property (nonatomic, copy) NSString *photoSrc;

/**
 点赞关联id，判断用户是否点赞该贴子/活动
 */
@property (nonatomic, assign) NSInteger praiseId;

/**
 被点赞数
 */
@property (nonatomic, assign) NSInteger praises;

/**
 所评分数
 */
@property (nonatomic, assign) float score;

/**
 子评论数
 */
@property (nonatomic, assign) NSInteger sonComments;

/**
 被回复人昵称
 */
@property (nonatomic, copy) NSString *replyNickName;

/**
 图片地址，以，隔开
 */
@property (nonatomic, strong) NSArray <NSString *>*imagesAddress;
@property (nonatomic, copy) NSString *lastUpdateTime;
@property (nonatomic, copy) NSString *remark;

/**
 回复人头像
 */
@property (nonatomic, copy) NSString *replyAvatar;

/**
 子评论实体类
 */
@property (nonatomic, strong) JACommentModel *childComment;

#pragma mark - custome properties
@property (nonatomic, assign) CGFloat cellHeight;

@end


