//
//  SJCollectionActivityController.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/6/7.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJCollectionActivityController.h"
#import "SJDetailController.h"
#import "SJRouteDetailController.h"
#import "SJOtherInfoPageController.h"
#import "SJInterestListsController.h"
#import "SJMyCollectionNavView.h"
#import "SJNoDataFootView.h"
#import "JAForumPresenter.h"
#import "SJRouteListCell.h"

@interface SJCollectionActivityController () <SJRouteListCellDelegate>

@property (nonatomic, strong) NSMutableDictionary *dataDict;
@property (nonatomic, strong) SJNoDataFootView *noDataView;

@end

@implementation SJCollectionActivityController
static NSString *const SJCurrentPage = @"SJCurrentPage";
static NSString *const SJCurrentData = @"SJCurrentData";
static NSString *const SJFooterHiden = @"SJFooterHiden";

#pragma mark - lazy loading
- (NSMutableDictionary *)dataDict
{
    if (_dataDict == nil)
    {
        _dataDict = [NSMutableDictionary dictionary];
        [_dataDict setValue:@"1" forKey:SJCurrentPage];
        [_dataDict setValue:@"0" forKey:SJFooterHiden];
        [_dataDict setValue:[NSMutableArray array] forKey:SJCurrentData];
    }
    return _dataDict;
}

- (SJNoDataFootView *)noDataView
{
    if (_noDataView == nil)
    {
        _noDataView = [SJNoDataFootView createCellWithXib];
        _noDataView.backgroundColor = JMY_BG_COLOR;
        _noDataView.exceptionStyle = SJExceptionStyleNoData;
    }
    return _noDataView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.listView.contentInset = UIEdgeInsetsMake(0, 0, iPhoneX?64+34:64, 0);
    self.listView.separatorColor = [UIColor colorWithHexString:@"EEEEEE" alpha:1];
    [self addRefreshView];
    [self getRouteDataList];
}

- (void)addRefreshView
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self.dataDict setValue:@"1" forKey:SJCurrentPage];
        NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
        [dataArray removeAllObjects];
        [self getRouteDataList];
        
    }];
    self.listView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        NSString *currentPage = [self.dataDict valueForKey:SJCurrentPage];
        [self.dataDict setValue:[NSString stringWithFormat:@"%zd", [currentPage integerValue] + 1] forKey:SJCurrentPage];
        [self getRouteDataList];
    }];
    self.listView.mj_footer = footer;
}

- (void)getRouteDataList
{
    [SVProgressHUD show];
    NSString *currentPage = [self.dataDict valueForKey:SJCurrentPage];
    [JAForumPresenter postQueryMyCollectionRoutePage:YES withCurrentPage:currentPage.integerValue withLimit:10 OrderBy:nil Sort:nil Result:^(JARouteListModel * _Nullable model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (model.success)
            {
                NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
                [dataArray addObjectsFromArray:model.data.list];
                [self.listView reloadData];
                self.listView.mj_header.hidden = kArrayIsEmpty(dataArray);
                if (kArrayIsEmpty(dataArray)) {
                    self.noDataView.describeLabel.text = @"空空如也";
                    [self.view insertSubview:self.noDataView aboveSubview:self.listView];
                } else {
                    if (self.noDataView.superview) {
                        [self.noDataView removeFromSuperview];
                    }
                }
            } else {
                self.noDataView.describeLabel.text = model.responseStatus.message;
                [self.view insertSubview:self.noDataView aboveSubview:self.listView];
            }
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            self.listView.mj_footer.hidden = (model.data.list.count < 10);
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (kScreenWidth-2*kSJMargin)*170.0/345+90;
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
    //删除。。
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    JARouteListItemModel *itemModel = dataArray[indexPath.row];
    [JAForumPresenter postDeleteDetailCollection:itemModel.collectionId Result:^(JAResponseModel * _Nullable model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (model.success) {
                NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
                NSInteger index = [dataArray indexOfObject:itemModel];
                [dataArray removeObjectAtIndex:index];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                [self.listView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                if (kArrayIsEmpty(dataArray)) {
                    [self.view insertSubview:self.noDataView aboveSubview:self.listView];
                    self.listView.mj_header.hidden = YES;
                }
            } else {
                [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
            }
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        });
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SJRouteListCell *cell = [SJRouteListCell xibCell:tableView];
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    JARouteListItemModel *itemModel = dataArray[indexPath.row];
    cell.itemModel = itemModel;
    cell.delegate = self;
    cell.clickBlock = ^{
        SJRouteDetailController *detailVC = [[SJRouteDetailController alloc] init];
        detailVC.titleName = @"    ";
        detailVC.routeId = itemModel.ID;
        [self.navigationController pushViewController:detailVC animated:YES];
    };
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    JARouteListItemModel *itemModel = dataArray[indexPath.row];
    SJRouteDetailController *detailVC = [[SJRouteDetailController alloc] init];
    detailVC.titleName = @"    ";
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

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.noDataView.frame = CGRectMake(0, (self.view.height-200)*0.5-64, self.view.width, 200);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
