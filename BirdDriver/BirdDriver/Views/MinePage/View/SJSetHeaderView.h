//
//  SJSetHeaderView.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/19.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJSetHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIButton *setBtn;
@property (weak, nonatomic) IBOutlet UIImageView *porImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *genderAddressBtn;



+ (instancetype)createCellWithXib;


@end
