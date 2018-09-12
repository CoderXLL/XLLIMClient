//
//  SJNoteController.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/21.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJNoteController.h"
#import "SJBuildNoteController.h"
#import "SJMyNoteCell.h"
#import "SJAlertView.h"
#import "SJNoDataFootView.h"
#import "SJDetailController.h"
#import "SJNoteDetailController.h"
#import "MJRefresh.h"
#import "JABbsPresenter.h"
#import "JAForumPresenter.h"

@interface SJNoteController () <SJMyNoteCellDelegate>

@property (nonatomic, strong) NSMutableDictionary *dataDict;
@property (nonatomic, strong) SJNoDataFootView *noDataView;

@end

@implementation SJNoteController
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
        [_dataDict setValue:[NSMutableArray array] forKey:SJCurrentData];
        [_dataDict setValue:@"0" forKey:SJFooterHiden];
    }
    return _dataDict;
}

- (SJNoDataFootView *)noDataView
{
    if (_noDataView == nil)
    {
        _noDataView = [SJNoDataFootView createCellWithXib];
        _noDataView.exceptionStyle = SJExceptionStyleNoData;
        _noDataView.backgroundColor = JMY_BG_COLOR;
    }
    return _noDataView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    
    self.tableViewStyle = UITableViewStyleGrouped;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self creatNavRightView];
    [self addRefreshView];
    [self getNoteList];
}

- (void)creatNavRightView
{
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect editFrame = editBtn.frame;
    editFrame.size = CGSizeMake(50, 35);
    editBtn.frame = editFrame;
    [editBtn setImage:[UIImage imageNamed:@"note_edit"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
}

- (void)addRefreshView
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataDict setValue:@"1" forKey:SJCurrentPage];
        [self.dataDict setValue:[NSMutableArray array] forKey:SJCurrentData];
        [self getNoteList];
        
    }];
    self.listView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        NSString *currentPage = [self.dataDict valueForKey:SJCurrentPage];
        [self.dataDict setValue:[NSString stringWithFormat:@"%zd", [currentPage integerValue] + 1] forKey:SJCurrentPage];
        [self getNoteList];
    }];
    self.listView.mj_footer = footer;
    self.listView.mj_footer.hidden = YES;
}

- (void)getNoteList
{
    [SVProgressHUD show];
    NSString *currentPage = [self.dataDict valueForKey:SJCurrentPage];
    NSInteger status = 0;
    if (!self.isMyPost) {
        status = 4;
    }
    [JABbsPresenter postQueryDetailsByUser:self.userId queryType:JADetailsTypePost status:status  IsPaging:YES WithCurrentPage:[currentPage integerValue] WithLimit:10 Result:^(JARecommendDetailSpolistModel * _Nullable model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (model.success)
            {
                NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
                [dataArray addObjectsFromArray:model.detailsPO.postsList];
                self.listView.mj_footer.hidden = (model.detailsPO.postsList.count < 10);
                self.listView.mj_header.hidden = kArrayIsEmpty(dataArray);
                if (kArrayIsEmpty(dataArray)) {
                    if (!self.noDataView.superview) {
                        self.noDataView.describeLabel.text = @"空空如也";
                        [self.view insertSubview:self.noDataView aboveSubview:self.listView];
                    }
                } else {
                    if (self.noDataView.superview) {
                        [self.noDataView removeFromSuperview];
                    }
                }
                [self.listView reloadData];
            } else {
                self.noDataView.describeLabel.text = model.responseStatus.message;
                [self.view insertSubview:self.noDataView aboveSubview:self.listView];
            }
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            [self endRefreshView];
        });
    }];
}

- (void)endRefreshView
{
    [self.listView.mj_header endRefreshing];
    [self.listView.mj_footer endRefreshing];
}

#pragma mark - EVENT
- (void)editBtnClick
{
    SJBuildNoteController *buildNoteVC = [[SJBuildNoteController alloc] init];
    buildNoteVC.titleName = @"发布帖子";
    buildNoteVC.buildSuccssBlock = ^{
      
        NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
        [dataArray removeAllObjects];
        [self.dataDict setValue:@"1" forKey:SJCurrentPage];
        [self getNoteList];
    };
    [self.navigationController pushViewController:buildNoteVC animated:YES];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    if (kArrayIsEmpty(dataArray)) {
        return 0.0001;
    }
    return 20.f;
}

//设置Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

//点击删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //调用接口
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    JAPostsModel *postsModel = dataArray[indexPath.row];
    [self deletePosts:postsModel];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
    headerView.backgroundColor = [UIColor whiteColor];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SJMyNoteCell *cell = [SJMyNoteCell xibCell:tableView];
    cell.delegate = self;
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    cell.postsModel = dataArray[indexPath.row];
    cell.isMineNote = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    JAPostsModel *postsModel = dataArray[indexPath.row];
    if (postsModel.runStatus == JAPostsRunStatusDraft) {
        
        SJBuildNoteController *buildNoteVC = [[SJBuildNoteController alloc] init];
        buildNoteVC.postsModel = postsModel;
        buildNoteVC.titleName = @"草稿";
        buildNoteVC.buildSuccssBlock = ^{
            
            NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
            [dataArray removeAllObjects];
            [self.dataDict setValue:@"1" forKey:SJCurrentPage];
            [self getNoteList];
        };
        [self.navigationController pushViewController:buildNoteVC animated:YES];
    } else {
//        SJDetailController *detailVC = [[SJDetailController alloc] init];
//        NSString *postDetail = [NSString stringWithFormat:@"%@/postingDetail?id=%zd", JA_SERVER_WEB, postsModel.ID];
//        detailVC.detailStr = postDetail;
//        detailVC.titleName = @"帖子详情";
        SJNoteDetailController *detailVC = [[SJNoteDetailController alloc] init];
        detailVC.noteId = postsModel.ID;
        detailVC.deleteBlock = ^{
            
            NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
            [dataArray removeAllObjects];
            [self.dataDict setValue:@"1" forKey:SJCurrentPage];
            [self getNoteList];
        };
        dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController showViewController:detailVC
                                               sender:nil];
    });
    }
}

#pragma mark - SJMyNoteCellDelegate
- (void)didLongPressed:(SJMyNoteCell *)noteCell
{
    
    return;
    NSIndexPath *indexPath = [self.listView indexPathForCell:noteCell];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        SJAlertModel *sureModel = [[SJAlertModel alloc] initWithTitle:@"确定" handler:^(id content) {
            
            JAPostsModel *postModel = noteCell.postsModel;
            [self deletePosts:postModel];
        }];
        SJAlertModel *cancelModel = [[SJAlertModel alloc] initWithTitle:@"取消" handler:nil];
        SJAlertView *alertView = [SJAlertView alertWithTitle:@"是否确定删除该帖子？" message:nil type:SJAlertShowTypeNormal alertModels:@[sureModel, cancelModel]];
        [alertView showAlertView];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:deleteAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)deletePosts:(JAPostsModel *)postModel
{
    [SVProgressHUD show];
    [JAForumPresenter postDeletePostById:postModel.ID Result:^(JAResponseModel * _Nullable model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (model.success)
            {
                NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
                NSInteger index = [dataArray indexOfObject:postModel];
                [dataArray removeObjectAtIndex:index];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                [self.listView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                if (kArrayIsEmpty(dataArray)) {
                    [self.view insertSubview:self.noDataView aboveSubview:self.listView];
                }
            } else {
                [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
            }
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        });
    }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.noDataView.frame = CGRectMake(0, (self.listView.height - 200)*0.5, self.listView.width, 200);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
