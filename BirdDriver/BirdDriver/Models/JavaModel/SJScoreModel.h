//
//  SJScoreModel.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/8/10.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SPBaseModel.h"

@interface SJScoreModel : SPBaseModel

/**
 评论类型，默认为0，以前接口不用改。如果是回复需要加上relpyUserId和commentType为1
 */
@property (nonatomic, assign) NSInteger commentType;
/**
 信息生成时间
 */
@property (nonatomic, assign) long long createTime;
/**
 帖子或活动id
 */
@property (nonatomic, assign) NSInteger detailsId;
/**
 评价
 */
@property (nonatomic, copy) NSString *evaluate;

@property (nonatomic, assign) NSInteger Id;

/**
 评价图片地址集
 */
@property (nonatomic, strong) NSArray <NSString *>*imagesAddressList;

/**
 父评分ID
 */
@property (nonatomic, copy) NSString *parentCommentId;
/**
 被回复者ID
 */
@property (nonatomic, copy) NSString *relpyUserId;

/**
 备注说明
 */
@property (nonatomic, copy) NSString *remark;

/**
 评分
 */
@property (nonatomic, assign) NSInteger score;
/**
 评分人id
 */
@property (nonatomic, copy) NSString *scoreUserId;

@end
