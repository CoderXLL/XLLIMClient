//
//  SJMineTableViewCell.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/16.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JATimeLineListModel.h"


typedef void(^deleteModelBlock) (JATimeLineModel *deleteModel);

@interface SJMineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//时间
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;//类型
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;//删除
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;//图片
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pictureImageViewWidth;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//帖子标题
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;//帖子内容
@property (nonatomic)deleteModelBlock deleteModelBlock;


-(void)setTimeModel:(JATimeLineModel *)model;

@property (nonatomic, assign) BOOL isTopLineHiden;

@end
