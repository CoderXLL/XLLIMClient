//
//  SJStartReviewTableViewCell.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/7/18.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJStartReviewTableViewCell : UITableViewCell

@property (strong,nonatomic) UIView *v_addcomment;


@property(strong,nonatomic) IBOutlet UIView *v_star;
@property(strong,nonatomic) IBOutlet UILabel *v_count;


@property (weak, nonatomic) IBOutlet UIView *whiteView;


@property(strong,nonatomic) IBOutlet UIImageView *img_star1;
@property(strong,nonatomic) IBOutlet UIImageView *img_star2;
@property(strong,nonatomic) IBOutlet UIImageView *img_star3;
@property(strong,nonatomic) IBOutlet UIImageView *img_star4;
@property(strong,nonatomic) IBOutlet UIImageView *img_star5;

@property NSInteger count;
@property BOOL canAddStar;

@end
