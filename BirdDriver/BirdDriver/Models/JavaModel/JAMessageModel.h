//
//  JAMessageModel.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/6/7.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"

typedef NS_ENUM(NSInteger, JAMessageType) {
    MessageTypeAll          =   0,      //全部
    MessageTypeMiss         =   1,      //世界小姐审核产生的消息
    MessageTypeComment      =   2,      //评论（帖子和足迹）
    MessageTypeLike         =   3,      //点赞帖子
    MessageTypeAttention    =   4,      //关注
    MessageTypeLikeComment  =   5,      //点赞足迹评论消息
    MessageTypeReplyComment  =   6,      //回复评论消息（帖子和足迹）
};

@interface JAMessageModel : JAResponseModel



@property(nonatomic,assign)long createTime;
/**
 标识
 **/
@property(nonatomic,assign)NSInteger Id;
@property(nonatomic,copy)NSString *message;//消息内容
@property(nonatomic,assign)NSInteger messageType;//消息类型 评论类型：0表示一级评论，1表示子评论，2表示回复
@property(nonatomic,copy)NSString *nickName;//昵称
@property(nonatomic,copy)NSString *photoSrc;//头像
@property(nonatomic,assign)BOOL readStatus;//已读标识
@property(nonatomic,assign)NSInteger sendUserId;


@property(nonatomic,assign)NSInteger nsjUserId;//鸟斯基用户id
//关联标识id，用于跳转到相关地方的标识
@property(nonatomic,assign)NSInteger relevanceId;
@property (nonatomic, assign) NSInteger rootId;
@property (nonatomic, assign) NSInteger postId;
//推送叫detailId
@property (nonatomic, assign) NSInteger detailId;
@property(nonatomic,copy)NSString *title;//标题


@property(nonatomic,copy)NSString *authorNickName;//发帖人昵称
@property(nonatomic,copy)NSString *authorPhotoSrc;//发帖人头像
@property(nonatomic,copy)NSString *authorResponseTime;//发帖人回复时间
@property(nonatomic,copy)NSString *detailsName;//标题名称
@property(nonatomic,copy)NSString *subclassReply;//子类回复
@property(nonatomic,copy)NSString *subclassReplyNicKName;//子类回复用户昵称
@property(nonatomic,copy)NSString *authorSex;//发帖人性别 0女 1男
@property(nonatomic,copy)NSString *sex;//正常回复帖子性别


@property(nonatomic,assign)BOOL isDeleted;//是否删除
@property(nonatomic,copy)NSString *lastUpdateTime;//最后更新时间
//自己添加的类型：1帖子2活动
@property(nonatomic,assign)NSInteger messageSecType;
@property(nonatomic,assign)NSInteger relevancePath;//关联标识路径，用于跳转到相关地方的标识

@end

@interface JATaskModel : JAResponseModel

@property(nonatomic,assign)NSInteger data;//未领取任务
@end
