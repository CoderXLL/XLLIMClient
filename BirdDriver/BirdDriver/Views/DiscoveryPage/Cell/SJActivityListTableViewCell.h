//
//  SJActivityListTableViewCell.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/28.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJStarView.h"
#import "JAActivityListModel.h"

@interface SJActivityListTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet SJStarView *starView;
@property (weak, nonatomic) IBOutlet UILabel *starValue;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UIButton *goodReputationBtn;
@property (weak, nonatomic) IBOutlet UIButton *hotBtn;


-(void)setActivityInfoAction:(JAActivityModel *)model;



@end
