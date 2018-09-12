//
//  SJSearchNoDataView.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/29.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBTagListView.h"

@interface SJSearchNoDataView : UIView


@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet GBTagListView *labelView;

+ (instancetype)createCellWithXib;


@end
