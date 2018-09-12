//
//  SJSystemDetailViewController.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/8/24.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJSystemDetailViewController.h"
#import "SJSystemDetailTableViewCell.h"

@interface SJSystemDetailViewController ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation SJSystemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息详情";
    self.tableViewStyle = UITableViewStylePlain;
    self.listView.backgroundColor = [UIColor whiteColor];
    self.listView.allowsSelection = NO;
    [self.listView registerNib:[UINib nibWithNibName:@"SJSystemDetailTableViewCell" bundle:nil]
        forCellReuseIdentifier:@"SJSystemDetailTableViewCell"];
    self.listView.estimatedRowHeight = 70;
    self.listView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(nonnull UITableView *)tableView
         cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SJSystemDetailTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"SJSystemDetailTableViewCell" forIndexPath:indexPath];
    [cell setSystemMessage:self.systemModel];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

@end
