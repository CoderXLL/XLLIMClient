//
//  SJMineHeaderView.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/17.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJUserTagsView.h"

@interface SJHeaderItemModel : SPBaseModel

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *iconStr;

@end

@class SJHeaderItemModel, SJMineHeaderView;
@protocol SJMineHeaderViewDelegate <NSObject>

//选择的itemModel
- (void)didSelectedItemModel:(SJHeaderItemModel *)itemModel;
//点击部分区域进入设置界面
- (void)didClickBgView:(SJMineHeaderView *)headerView;
//点击头像
- (void)didClickPortraitImageView;

@end

@interface SJMineHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIButton *portraitImageView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//昵称
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;//个人描述
@property (weak, nonatomic) IBOutlet UILabel *concernLabel;//关注数
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;//粉丝数
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;//消息数

@property (weak, nonatomic) IBOutlet SJUserTagsView *tagListView;
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;//创建组
@property (weak, nonatomic) IBOutlet UIButton *genderAddressBtn;//性别地址
@property (weak, nonatomic) IBOutlet UIButton *concernBtn;
@property (weak, nonatomic) IBOutlet UIButton *fansBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIButton *groupBtn;


@property (nonatomic, weak) id<SJMineHeaderViewDelegate> delegate;
+ (instancetype)createCellWithXib;


- (void)getMessageNotReadCountWithGroup:(dispatch_group_t)group;

@end
