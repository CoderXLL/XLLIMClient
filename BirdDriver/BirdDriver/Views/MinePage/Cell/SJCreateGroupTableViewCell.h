//
//  SJCreateGroupTableViewCell.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/25.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJStarView.h"
#import "JAActivityListModel.h"

@interface SJCreateGroupTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabe;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet SJStarView *starView;
@property (weak, nonatomic) IBOutlet UILabel *starValue;



-(void)setGroupActivity:(JAActivityModel *)model;


@end
