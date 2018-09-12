//
//  SJInterestListsController.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/27.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJInterestListsController.h"
#import "SJOtherInfoPageController.h"
#import "SJInterestListsCell.h"
#import "JAForumPresenter.h"

@interface SJInterestListsController ()

@property (nonatomic, strong) NSMutableDictionary *dataDict;

@end

@implementation SJInterestListsController
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"感兴趣的人";
    
    [self addRefreshView];
    [self requestInterestLists];
}

- (void)addRefreshView
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self.dataDict setValue:@"1" forKey:SJCurrentPage];
        NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
        [dataArray removeAllObjects];
        [self requestInterestLists];
    }];
    self.listView.mj_header = header;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        NSString *currentPage = [self.dataDict valueForKey:SJCurrentPage];
        [self.dataDict setValue:[NSString stringWithFormat:@"%zd", [currentPage integerValue]+1] forKey:SJCurrentPage];
        [self requestInterestLists];
    }];
    footer.hidden = YES;
    self.listView.mj_footer = footer;
}

- (void)requestInterestLists
{
    [SVProgressHUD show];
    NSString *currentPage = [self.dataDict valueForKey:SJCurrentPage];
    [SVProgressHUD show];
    [JAForumPresenter postQueryRouteCollectionPage:self.routeId isPaging:YES withCurrentPage:currentPage.integerValue withLimit:10 OrderBy:nil Sort:nil Result:^(JAInterestListModel * _Nullable model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (model.success)
            {
                [SVProgressHUD dismiss];
                NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
                [dataArray addObjectsFromArray:model.data.list];
                self.listView.mj_footer.hidden = (model.data.list.count < 10);
                self.listView.mj_header.hidden = kArrayIsEmpty(dataArray);
                [self.listView reloadData];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 96.0-27;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SJInterestListsCell *cell = [SJInterestListsCell xibCell:tableView];
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    cell.posModel = dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    JAUserAccountPosList *posModel = dataArray[indexPath.row];
    SJOtherInfoPageController *otherVC = [[SJOtherInfoPageController alloc] init];
    otherVC.userId = posModel.Id;
    otherVC.titleName = [NSString stringWithFormat:@"%@的个人主页", posModel.nickName];
    [self.navigationController pushViewController:otherVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
