//
//  SJFootprintDetialsCommentCell.h
//  BirdDriver
//
//  Created by Soul on 2018/7/17.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JACommentListModel.h"

typedef void(^CommentShowPhotoBlock)(NSArray *imageAddressArr,NSInteger currentPhotoIndex);
//typedef void(^CommentClickLikeBlock)(NSInteger commentId);
typedef void(^CommentShowUserinfoBlock)(NSInteger userId);
typedef void(^CommentMoreBlock)(NSInteger commentId,NSInteger commentUserId);

@interface SJFootprintDetialsCommentCell : SPBaseCell

/**
 当前评论对应的Model
 */
@property (strong, nonatomic) JACommentModel *commentModel;

/**
 点击。。。更多回调
 */
@property (nonatomic, copy) void(^moreBlock)(JACommentModel *, CGPoint);

/**
 点击查看图片回调，参数返回当前照片位于组中的第几个
 */
@property (copy, nonatomic) CommentShowPhotoBlock photoBlock;
//@property (copy, nonatomic) CommentClickLikeBlock likeBlock;
/**
 点击了查看个人信息
 */
@property (copy, nonatomic) CommentShowUserinfoBlock showUserinfoBlock;

/**
 点击了更多子评论
 */
@property (copy, nonatomic) CommentMoreBlock commentMoreBlock;

/**
 评论内容高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageboxHegiht;

@property (weak, nonatomic) IBOutlet UIImageView *img_authHead;
@property (weak, nonatomic) IBOutlet UIButton *btn_authName;
@property (weak, nonatomic) IBOutlet UITextView *tv_commentDes;
@property (weak, nonatomic) IBOutlet UILabel *lbl_creatTime;
@property (weak, nonatomic) IBOutlet UIButton *btn_like;

@property (weak, nonatomic) IBOutlet UIView *v_imgBox;
@property (weak, nonatomic) IBOutlet UIButton *btn_showImg_0;
@property (weak, nonatomic) IBOutlet UIButton *btn_showImg_1;
@property (weak, nonatomic) IBOutlet UIButton *btn_showImg_2;
@property (weak, nonatomic) IBOutlet UIButton *btn_showImg_3;
@property (weak, nonatomic) IBOutlet UIButton *btn_showImg_4;

@property (weak, nonatomic) IBOutlet UILabel *lbl_score;
@property (weak, nonatomic) IBOutlet UIImageView *img_star_1;
@property (weak, nonatomic) IBOutlet UIImageView *img_star_2;
@property (weak, nonatomic) IBOutlet UIImageView *img_star_3;
@property (weak, nonatomic) IBOutlet UIImageView *img_star_4;
@property (weak, nonatomic) IBOutlet UIImageView *img_star_5;


//评论回复
@property (weak, nonatomic) IBOutlet UIView *returnView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *returnViewheight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *returnViewTop;

@property (weak, nonatomic) IBOutlet UITextView *returnContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *returnContentHeight;
@property (weak, nonatomic) IBOutlet UIView *returnImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *returnImageHeight;
@property (weak, nonatomic) IBOutlet UIButton *returnImage_1;
@property (weak, nonatomic) IBOutlet UIButton *returnImage_2;
@property (weak, nonatomic) IBOutlet UIButton *returnImage_3;
@property (weak, nonatomic) IBOutlet UIButton *returnImage_4;
@property (weak, nonatomic) IBOutlet UIButton *returnImage_5;
@property (weak, nonatomic) IBOutlet UIButton *returnMoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *ReturnContentBtn;

@end
