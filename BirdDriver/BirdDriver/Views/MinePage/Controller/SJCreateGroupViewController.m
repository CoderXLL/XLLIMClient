//
//  SJCreateGroupViewController.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/25.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//
// 创建组列表

#import "SJCreateGroupViewController.h"
#import "SJCreateGroupTableViewCell.h"
#import "JABbsPresenter.h"
#import "SJDetailController.h"
#import "SJFootprintDetailsController.h"

@interface SJCreateGroupViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,retain)UITableView *mainTableView;
@property(strong, nonnull)SJNoDataFootView *footView;

@property(strong, nonnull)NSMutableArray *listModelArray;

@property(nonatomic,assign)NSInteger page;

@end

@implementation SJCreateGroupViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.mainTableView];
    [self beginRefreshing];
}


-(void)getCreateGroupInfo:(NSInteger)page{
    [JABbsPresenter postQueryDetailsByUser:self.userId queryType:JADetailsTypeActivity status:0  IsPaging:YES WithCurrentPage:page WithLimit:20 Result:^(JARecommendDetailSpolistModel * _Nullable model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mainTableView.mj_header endRefreshing];
            [self.mainTableView.mj_footer endRefreshing];
            if (page == 1) {
                self.listModelArray = [model.detailsPO.activitysList mutableCopy];
            } else {
                [self.listModelArray addObjectsFromArray:model.detailsPO.activitysList];
            }
            if (!(model.detailsPO.activitysList.count < 20)) {
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self footViewRefresh:model.responseStatus.message];
            [self.mainTableView reloadData];
        });
    }];
}

- (void)beginRefreshing {
    self.page = 1;
    [self getCreateGroupInfo:self.page];
}

- (void)lodingMore {
    self.page ++;
    [self getCreateGroupInfo:self.page];
}

#pragma mark - mainTableView
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavBarHeight) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = HEXCOLOR(@"FFFFFF");
        [_mainTableView registerNib:[UINib nibWithNibName:@"SJCreateGroupTableViewCell" bundle:nil] forCellReuseIdentifier:@"SJCreateGroupTableViewCell"];
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
    if ([self.listModelArray count] > 0) {
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    JAActivityModel *model = [self.listModelArray objectAtIndex:indexPath.row];
    [self deleteAction:model];
}


- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SJCreateGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SJCreateGroupTableViewCell" forIndexPath:indexPath];
    JAActivityModel *model = [self.listModelArray objectAtIndex:indexPath.row];
    [cell setGroupActivity:model];
    
//    if (self.userId  == SPLocalInfo.userModel.Id) {
//        UILongPressGestureRecognizer * longPressGesture =   [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
//        [cell addGestureRecognizer:longPressGesture];
//    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JAActivityModel *model = [self.listModelArray objectAtIndex:indexPath.row];
    
    SJFootprintDetailsController *detailVC = [[SJFootprintDetailsController alloc] init];
    detailVC.titleName = model.detailsName;
    detailVC.deleteBlock = ^{
        self.page = 1;
        [self.listModelArray removeAllObjects];
        [self getCreateGroupInfo:self.page];
    };
    detailVC.activityId = model.ID;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController showViewController:detailVC
                                               sender:nil];
    });
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listModelArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115;
}


- (void)cellLongPress:(UIGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [recognizer locationInView:self.mainTableView];
        NSIndexPath * indexPath =[self.mainTableView indexPathForRowAtPoint:location];
        SJCreateGroupTableViewCell *cell = (SJCreateGroupTableViewCell *)recognizer.view;
        [cell becomeFirstResponder];
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            SJAlertModel *sureModel = [[SJAlertModel alloc] initWithTitle:@"确定" handler:^(id content) {
                JAActivityModel *model = [self.listModelArray objectAtIndex:indexPath.row];
                [self deleteAction:model];
            }];
            SJAlertModel *cancelModel = [[SJAlertModel alloc] initWithTitle:@"取消" handler:nil];
            SJAlertView *alertView = [SJAlertView alertWithTitle:@"是否确定删除该活动？" message:nil type:SJAlertShowTypeNormal alertModels:@[sureModel, cancelModel]];
            [alertView showAlertView];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:deleteAction];
        [alertVC addAction:cancelAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}

-(void)deleteAction:(JAActivityModel *)activityModel {
    [JABbsPresenter postUpdateDetails:activityModel.ID runStatus:JAPostsRunStatusAuditSucceed  detailsName:activityModel.detailsName detailsLabels:activityModel.detailsLabels detailText:activityModel.describtion imageAddresses:[activityModel.imagesAddressList firstObject] detailsUserId:activityModel.detailsUserId detailsType:JADetailsTypeActivity isDeleted:YES Result:^(JAResponseModel * _Nullable model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (model.success) {
                [self.listModelArray removeObject:activityModel];
            } else {
                [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            }
            [self.mainTableView reloadData];
        });
    }];
}


@end
