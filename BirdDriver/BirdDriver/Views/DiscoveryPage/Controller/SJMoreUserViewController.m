//
//  SJMoreUserViewController.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/7/27.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJMoreUserViewController.h"
#import "SJSearckUserTableViewCell.h"
#import "JABbsPresenter.h"
#import "SJOtherInfoPageController.h"

@interface SJMoreUserViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonnull) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (strong, nonnull) SJNoDataFootView *footView;

@property (nonatomic, assign) NSInteger page;

@end

@implementation SJMoreUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.mainTableView];
    self.page = 1;
    [self beginRefreshing];
}

- (void)beginRefreshing {
    self.page = 1;
    [self getSearchUser:self.searchString];
}

- (void)lodingMore {
    self.page ++ ;
    [self getSearchUser:self.searchString];
}

#pragma mark - 搜索结果mainTableView
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavBarHeight) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = HEXCOLOR(@"FFFFFF");
        [_mainTableView registerNib:[UINib nibWithNibName:@"SJSearckUserTableViewCell" bundle:nil] forCellReuseIdentifier:@"SJSearckUserTableViewCell"];
        _mainTableView.separatorStyle = UITableViewCellEditingStyleNone;
        _mainTableView.tableFooterView = self.footView;
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self beginRefreshing];
        }];
        _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self lodingMore];
        }];
    }
    return _mainTableView;
}

#pragma mark - footView
-(SJNoDataFootView *)footView{
    if (!_footView) {
        _footView = [SJNoDataFootView createCellWithXib];
        _footView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavBarHeight);
        _footView.imageTopHeight.constant = (kScreenHeight - kNavBarHeight)/3;
    }
    [self footViewRefresh:nil];
    return _footView;
}

-(void)footViewRefresh:(NSString *)message{
    if (message.length == 0) {
        message = @"获取中";
    }
    _footView.isShow = NO;
    _footView.imageView.image = [UIImage imageNamed:@"search_noData"];
    if ([self.searchArray count] > 0) {
        _mainTableView.tableFooterView = nil;
        if (![message isEqualToString:@"响应成功"]) {
            [SVProgressHUD showInfoWithStatus:message];
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        }
    } else {
        if ([message isEqualToString:@"响应成功"]) {
            _footView.describeLabel.text = @"空空如也";
        } else {
            _footView.describeLabel.text = message;
        }
        _mainTableView.tableFooterView = _footView;
    }
    [_footView reloadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView
- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SJSearckUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SJSearckUserTableViewCell" forIndexPath:indexPath];
    JAUserAccount *model = [self.searchArray objectAtIndex:indexPath.row];
    [cell setUserInfo:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JAUserAccount *model = [self.searchArray objectAtIndex:indexPath.row];
    
    SJOtherInfoPageController *anotherPageVC = [[SJOtherInfoPageController alloc] init];
    anotherPageVC.userId = model.Id;
    anotherPageVC.titleName = @"";
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController showViewController:anotherPageVC
                                               sender:nil];
    });
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

#pragma mark - 搜索相关活动
-(void)getSearchUser:(NSString *)string{
    [JABbsPresenter postqueryUserByNickName:string IsPaging:YES WithCurrentPage:self.page WithLimit:10 Result:^(JAUserListModel * _Nullable model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mainTableView.mj_header endRefreshing];
            [self.mainTableView.mj_footer endRefreshing];
            if (self.page == 1) {
                self.searchArray = [model.data.list mutableCopy];
            } else {
                [self.searchArray addObjectsFromArray:model.data.list];
            }
            if ([model.data.list count] < 10) {
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self footViewRefresh:model.responseStatus.message];
            [self.mainTableView reloadData];
        });
    }];
}
@end
