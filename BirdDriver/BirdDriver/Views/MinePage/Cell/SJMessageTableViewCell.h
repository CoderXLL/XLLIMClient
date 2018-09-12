//
//  SJMessageTableViewCell.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/30.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JAMessageModel.h"


@interface SJMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *porImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


- (void)setMessageAction:(JAMessageModel *)model messageType:(JAMessageType)messageType;

@property (nonatomic, copy) void(^headBlock)(NSInteger);

@end
