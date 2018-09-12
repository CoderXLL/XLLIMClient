//
//  SPListViewController.h
//  BirdDriver
//
//  Created by Soul on 17/3/25.
//  Copyright © 2017年 Zhejiang Guoshi Oucheng Asset Management Co., Ltd. All rights reserved.
//

#import "BDViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "SPViewController.h"

//#warning - 这个地方把基类改成了SPViewController
@interface SPListViewController : SPViewController <UITableViewDelegate,UITableViewDataSource>

/**
 子控制器可更改类型
 */
@property (nonatomic, assign) UITableViewStyle tableViewStyle;

@property (strong, nonatomic) UITableView *listView;

@end
