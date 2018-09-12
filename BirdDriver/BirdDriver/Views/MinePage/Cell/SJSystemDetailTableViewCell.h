//
//  SJSystemDetailTableViewCell.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/8/24.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJSystemMessageListModel.h"

@interface SJSystemDetailTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *messageTitle;
@property (weak, nonatomic) IBOutlet UILabel *messageTime;
@property (weak, nonatomic) IBOutlet UILabel *messageContent;


-(void)setSystemMessage:(JASystemModel *)model;


@end
