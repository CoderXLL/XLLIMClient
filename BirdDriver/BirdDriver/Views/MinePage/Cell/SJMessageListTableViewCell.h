//
//  SJMessageListTableViewCell.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/8/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JAMessagePresenter.h"


@interface SJMessageListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *porImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *notReadNum;

@end
