//
//  SJOtherHeaderView.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/24.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SJUserTagsView;
@interface SJOtherHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIButton *portraitImageView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//昵称
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;//个人描述
@property (weak, nonatomic) IBOutlet SJUserTagsView *tagListView;

@property (weak, nonatomic) IBOutlet UILabel *concernLabel;//关注数
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;//粉丝数
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;//创建组
@property (weak, nonatomic) IBOutlet UILabel *postLabel;//创建组


@property (weak, nonatomic) IBOutlet UIButton *genderAddressBtn;//性别地址
@property (weak, nonatomic) IBOutlet UIButton *concernBtn;
@property (weak, nonatomic) IBOutlet UIButton *fansBtn;
@property (weak, nonatomic) IBOutlet UIButton *groupBtn;
@property (weak, nonatomic) IBOutlet UIButton *postBtn;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;//关注

+ (instancetype)createCellWithXib;

@end
