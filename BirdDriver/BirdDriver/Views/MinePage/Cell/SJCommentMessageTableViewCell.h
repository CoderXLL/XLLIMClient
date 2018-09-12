//
//  SJCommentMessageTableViewCell.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/8/23.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JAMessageListModel.h"

@protocol SJCommentMessageCellDelegate <NSObject>

//进入帖子详情
- (void)didClickBigView:(NSInteger)detailId;
//点击上方大头像
- (void)didClickBigHeadView:(NSInteger)userId;
//点击下方小头像
- (void)didClickSmallHeadView:(NSInteger)userId;
//点击进入帖子详情
- (void)didClickMainView:(NSInteger)postId;

@end

@interface SJCommentMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *porImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentContent;

@property (weak, nonatomic) IBOutlet UIView *bigView;

@property (weak, nonatomic) IBOutlet UILabel *returnContent;

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *mainPorImageView;
@property (weak, nonatomic) IBOutlet UILabel *mainNickName;
@property (weak, nonatomic) IBOutlet UILabel *mainContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainTop;
@property (nonatomic, weak) id <SJCommentMessageCellDelegate> delegate;

@property (nonatomic, strong) JAMessageModel *model;

@end
