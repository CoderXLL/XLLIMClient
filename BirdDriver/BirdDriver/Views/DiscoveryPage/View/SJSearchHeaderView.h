//
//  SJSearchHeaderView.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/28.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJSearchHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;


+ (instancetype)createCellWithXib;

@end
