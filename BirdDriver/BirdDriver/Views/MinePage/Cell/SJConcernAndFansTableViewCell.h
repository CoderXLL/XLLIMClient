//
//  SJConcernAndFansTableViewCell.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/19.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJConcernAndFansTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *porImageView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//昵称
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;//个性签名
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;//性别
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;//关注/取消关注/相互关注


-(void)setUser:(JAUserAccount *)userModel;

@end
