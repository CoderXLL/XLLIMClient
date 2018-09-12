//
//  SJHomeHotUserRow.h
//  BirdDriver
//
//  Created by Soul on 2018/5/18.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "SPBaseCell.h"

@protocol SJHomeHotUserRowDelegate <NSObject>

- (void)didSelectedAccountModel:(id)userModel;

@end

@interface SJHomeHotUserRow : SPBaseCell

@property (nonatomic, strong) NSArray *hotUserList;
@property (nonatomic, weak) id <SJHomeHotUserRowDelegate> delegate;

@end
