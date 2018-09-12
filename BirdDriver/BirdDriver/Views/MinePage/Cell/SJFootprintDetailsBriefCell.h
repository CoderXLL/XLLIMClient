//
//  SJFootprintDetailsBriefCell.h
//  BirdDriver
//
//  Created by Soul on 2018/7/17.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//
//  足迹详情简介部分

#import <UIKit/UIKit.h>
#import "JABBSModel.h"

typedef void(^FootprintReportBlock)(NSInteger reportId);
typedef void(^FootprintShowMemberBlock)(NSInteger activityId);
typedef void(^FootprintShowUserinfoBlock)(NSInteger userId);
typedef void(^FootprintShowImageBlock)(NSArray *imagArr,NSInteger imgIndex);

@interface SJFootprintDetailsBriefCell : SPBaseCell

/**
 点击了举报按钮
 */
@property (copy, nonatomic) FootprintReportBlock reportBlock;

/**
 点击了查看全部组员
 */
@property (copy, nonatomic) FootprintShowMemberBlock memberBlock;

/**
 点击了查看个人信息
 */
@property (copy, nonatomic) FootprintShowUserinfoBlock showUserinfoBlock;

/**
 点击了查看标题背景图
 */
@property (copy, nonatomic) FootprintShowImageBlock showimgBlock;

/**
 活动model
 */
@property (strong, nonatomic) JABBSModel *activityModel;

//===========UI层面========

/**
 适应简介行高的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *briefHeight;

/**
 简介正文View
 */
@property (weak, nonatomic) IBOutlet UITextView *tf_brief;

/**
 活动标题
 */
@property (weak, nonatomic) IBOutlet UILabel *lbl_activityTitle;

/**
 足迹宣传图
 */
@property (weak, nonatomic) IBOutlet UIImageView *img_activityShowImage;

/**
 足迹发布人头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *img_activityHead;

/**
 足迹发布作者
 */
@property (weak, nonatomic) IBOutlet UIButton *lbl_activityAuthor;

@property (weak, nonatomic) IBOutlet UIImageView *img_memeber1;
@property (weak, nonatomic) IBOutlet UIImageView *img_memeber2;
@property (weak, nonatomic) IBOutlet UIImageView *img_memeber3;
@property (weak, nonatomic) IBOutlet UIImageView *img_memeber4;

/**
 共x条评论
 */
@property (weak, nonatomic) IBOutlet UILabel *lbl_commentSum;

/**
 最后一条评论时间
 */
@property (weak, nonatomic) IBOutlet UILabel *lbl_lastCommentTime;

@end
