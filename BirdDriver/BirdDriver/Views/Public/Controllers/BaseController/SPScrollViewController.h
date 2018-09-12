//
//  SPScrollViewController.h
//  BirdDriver
//
//  Created by Soul.Geng on 17/3/25.
//  Copyright © 2017年 com.hexianghang. All rights reserved.
//

#import "BDViewController.h"

@interface SPScrollViewController : BDViewController<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scroll;

- (void)reLayoutSubviews;

@end
