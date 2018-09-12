//
//  SJSearckUserTableViewCell.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/7/26.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJSearckUserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *porImgeView;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (weak, nonatomic) IBOutlet UILabel *attentionNum;
@property (weak, nonatomic) IBOutlet UILabel *fansNum;
@property (weak, nonatomic) IBOutlet UILabel *activityNum;


-(void)setUserInfo:(JAUserAccount *)model;


@end
