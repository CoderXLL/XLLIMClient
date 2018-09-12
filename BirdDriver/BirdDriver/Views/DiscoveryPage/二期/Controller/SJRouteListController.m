//
//  SJRouteListController.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/20.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJRouteListController.h"
#import "SJRouteDetailController.h"
#import "SJOtherInfoPageController.h"
#import "SJInterestListsController.h"
#import "SJRouteListCell.h"
#import "SJNoDataFootView.h"
#import "JAForumPresenter.h"
#import "JABbsLabelModel.h"

@interface SJRouteListController () <SJRouteListCellDelegate>

@property (nonatomic, strong) SJNoDataFootView *noDataView;
@property (nonatomic, strong) NSMutableDictionary *dataDict;

@end

@implementation SJRouteListController
static NSString *const SJCurrentPage = @"SJCurrentPage";
static NSString *const SJCurrentData = @"SJCurrentData";
static NSString *const SJFooterHiden = @"SJFooterHiden";

#pragma mark - lazy loading
- (NSMutableDictionary *)dataDict {
    if (_dataDict == nil) {
        _dataDict = [NSMutableDictionary dictionary];
        [_dataDict setValue:@"1" forKey:SJCurrentPage];
        [_dataDict setValue:[NSMutableArray array] forKey:SJCurrentData];
        [_dataDict setValue:@"0" forKey:SJFooterHiden];
    }
    return _dataDict;
}

- (SJNoDataFootView *)noDataView {
    if (_noDataView == nil) {
        _noDataView = [SJNoDataFootView createCellWithXib];
        _noDataView.backgroundColor = JMY_BG_COLOR;
        _noDataView.frame = CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight-kNavBarHeight);
        _noDataView.exceptionStyle = SJExceptionStyleNoData;
    }
    return _noDataView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    self.tableViewStyle = UITableViewStyleGrouped;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"路线";
    self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addRefreshView];
    [self requestRouteLists];
}

- (void)addRefreshView
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self.dataDict setValue:@"1" forKey:SJCurrentPage];
        NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
        [dataArray removeAllObjects];
        [self requestRouteLists];
    }];
    self.listView.mj_header = header;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        NSString *currentPage = [self.dataDict valueForKey:SJCurrentPage];
        [self.dataDict setValue:[NSString stringWithFormat:@"%zd", [currentPage integerValue]+1] forKey:SJCurrentPage];
        [self requestRouteLists];
    }];
    footer.hidden = YES;
    self.listView.mj_footer = footer;
}


- (void)requestRouteLists
{
    [SVProgressHUD show];
    NSString *currentPage = [self.dataDict valueForKey:SJCurrentPage];
    [JAForumPresenter postQueryRouteListByLabels:self.labelModel.labelName isPaging:YES withCurrentPage:[currentPage integerValue] withLimit:10 sort:@" desc" Result:^(JARouteListModel * _Nullable model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (model.success) {
                
                [SVProgressHUD dismiss];
                NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
                [dataArray addObjectsFromArray:model.data.list];
                self.listView.mj_footer.hidden = (model.data.list.count < 10);
                self.listView.mj_header.hidden = kArrayIsEmpty(dataArray);
                [self.listView reloadData];
                if (kArrayIsEmpty(dataArray)) {
                    
                    [self.view insertSubview:self.noDataView aboveSubview:self.listView];
                } else {
                    if (self.noDataView.superview) {
                        [self.noDataView removeFromSuperview];
                    }
                }
            } else {
                [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            }
            [self endRefreshView];
        });
    }];
}

- (void)endRefreshView
{
    [self.listView.mj_header endRefreshing];
    [self.listView.mj_footer endRefreshing];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    return dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (kScreenWidth-2*kSJMargin)*170.0/345+135;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SJRouteListCell *cell = [SJRouteListCell xibCell:tableView];
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    JARouteListItemModel *itemModel = dataArray[indexPath.section];
    cell.itemModel = itemModel;
    cell.clickBlock = ^{
        SJRouteDetailController *detailVC = [[SJRouteDetailController alloc] init];
        detailVC.titleName = @"路线详情";
        detailVC.routeId = itemModel.ID;
        [self.navigationController pushViewController:detailVC animated:YES];
    };
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    JARouteListItemModel *itemModel = dataArray[indexPath.section];
    SJRouteDetailController *detailVC = [[SJRouteDetailController alloc] init];
    detailVC.titleName = @"路线详情";
    detailVC.routeId = itemModel.ID;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - SJRouteListCellDelegate
- (void)routeListCell:(SJRouteListCell *)cell didClickPosModel:(JAUserAccountPosList *)posModel
{
    if (posModel) {
        
        SJOtherInfoPageController *otherVC = [[SJOtherInfoPageController alloc] init];
        otherVC.userId = posModel.Id;
        otherVC.titleName = [NSString stringWithFormat:@"%@的个人主页", posModel.nickName];
        [self.navigationController pushViewController:otherVC animated:YES];
    } else {
        SJInterestListsController *listVC = [[SJInterestListsController alloc] init];
        listVC.routeId = cell.itemModel.ID;
        [self.navigationController pushViewController:listVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
