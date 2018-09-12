//
//  SJPersonInfoTableViewCell.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JAUserModel.h"

@interface SJPersonInfoTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;



@property (strong, nonatomic) JAUserModel *model;

@end

