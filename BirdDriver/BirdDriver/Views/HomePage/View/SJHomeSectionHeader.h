//
//  SJHomeSectionHeader.h
//  BirdDriver
//
//  Created by Soul on 2018/5/17.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HomeHeaderSectionBlock)(void);

@interface SJHomeSectionHeader : UIView


@property (nonatomic,copy)HomeHeaderSectionBlock block;


- (void)factorySetViewWithTitle:(NSString *)title
                   WithBtnTitle:(NSString *)btnTitle
                   WithTapBlock:(HomeHeaderSectionBlock)block;

@end
