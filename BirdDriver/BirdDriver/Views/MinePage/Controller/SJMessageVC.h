//
//  SJMessageVC.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/30.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SPViewController.h"
#import "JAMessagePresenter.h"

@interface SJMessageVC : SPListViewController


@property(nonatomic, assign)JAMessageType messageType;

@property (nonatomic,copy)NSString *navTitle;

@end
