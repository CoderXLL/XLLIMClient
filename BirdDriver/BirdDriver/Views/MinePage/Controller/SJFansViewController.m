//
//  SJFansViewController.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/19.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//
// 粉丝列表

#import "SJFansViewController.h"
#import "SJConcernAndFansTableViewCell.h"
#import "SJOtherInfoPageController.h"
#import "JAUserPresenter.h"

@interface SJFansViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,retain)UITableView *mainTableView;
@property(strong, nonnull)SJNoDataFootView *footView;
@property(strong, nonnull)JAFansListModel *fansListModel;

@property(nonatomic, assign)NSInteger page;


@end

@implementation SJFansViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.mainTableView];
    self.page = 1;
    [self beginRefreshing];
}

-(void)getInfo{
    [JAUserPresenter postQueryFansListWithTargetUserId:self.userId WithPage:self.page WithLimit:20 Result:^(JAFansListModel * _Nullable model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mainTableView.mj_header endRefreshing];
            [self.mainTableView.mj_footer endRefreshing];
            if (self.page == 1) {
                 self.fansListModel = model;
            } else {
                NSMutableArray *array = [self.fansListModel.data.list mutableCopy];
                 self.fansListModel = model;
                [array addObjectsFromArray:self.fansListModel.data.list];
                self.fansListModel.data.list = array;
            }
            if (model.data.list.count < 20) {
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self footViewRefresh:model.responseStatus.message];
            [self.mainTableView reloadData];
        });
    }];
}

- (void)beginRefreshing {
    self.page = 1;
    [self getInfo];
}

- (void)lodingMore {
    self.page = self.page + 1;
    [self getInfo];
}


#pragma mark - mainTableView
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavBarHeight) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = HEXCOLOR(@"FFFFFF");
        [_mainTableView registerNib:[UINib nibWithNibName:@"SJConcernAndFansTableViewCell" bundle:nil] forCellReuseIdentifier:@"SJConcernAndFansTableViewCell"];
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
    if ([self.fansListModel.data.list count] > 0) {
        _mainTableView.tableFooterView = nil;
        if (!self.fansListModel.success) {
            [SVProgressHUD showInfoWithStatus:message];
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        }
    } else {
        if (self.fansListModel.success) {
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


- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SJConcernAndFansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SJConcernAndFansTableViewCell" forIndexPath:indexPath];
    cell.porImageView.layer.masksToBounds = YES;
    JAUserAccount *userModel = [self.fansListModel.data.list objectAtIndex:indexPath.row];
    [cell setUser:userModel];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SJOtherInfoPageController *anotherPageVC = [[SJOtherInfoPageController alloc] init];
    JAUserAccount *userModel = [self.fansListModel.data.list objectAtIndex:indexPath.row];
    anotherPageVC.userId = userModel.uid;
    anotherPageVC.titleName = @"";
    [self.navigationController pushViewController:anotherPageVC animated:YES];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fansListModel.data.list count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}




@end
