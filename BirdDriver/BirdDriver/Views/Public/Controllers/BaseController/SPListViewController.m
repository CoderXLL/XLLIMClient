//
//  SPListViewController.m
//  BirdDriver
//
//  Created by Soul on 17/3/25.
//  Copyright © 2017年 Zhejiang Guoshi Oucheng Asset Management Co., Ltd. All rights reserved.
//

#import "SPListViewController.h"
#import "MJRefresh.h"

@interface SPListViewController ()

@end

@implementation SPListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                 style:self.tableViewStyle];
    self.listView.backgroundColor = JMY_BG_COLOR;
    self.listView.delegate = self;
    self.listView.dataSource = self;
    self.listView.estimatedRowHeight = UITableViewAutomaticDimension;
    self.listView.estimatedSectionFooterHeight = 0;
    self.listView.estimatedSectionHeaderHeight = 0;

    // Do any additional setup after loading the view.
    [self.view addSubview:self.listView];
    if (@available(iOS 11.0, *)) {
        self.listView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view/**.mas_topMargin*/);
        make.bottom.equalTo(self.view/**.mas_bottomMargin*/);
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellReuseIdentifier = NSStringFromClass([self class]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellReuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//==iOS11之后 设置tableView高度需要实现view的协议，单纯的height不起作用

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01f)];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10.0f)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

@end
