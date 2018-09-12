//
//  SJSystemMessageViewController.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/8/23.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJSystemMessageViewController.h"
#import "SJSystemMessageTableViewCell.h"
#import "JAMessagePresenter.h"
#import "SJDetailController.h"
#import "SJSystemDetailViewController.h"

@interface SJSystemMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong, nonnull)SJNoDataFootView *footView;
@property(nonatomic,assign) NSInteger page;
@property(nonatomic,retain)NSMutableArray  *messageListArray;

@end

@implementation SJSystemMessageViewController

- (NSMutableArray *)messageListArray
{
    if (_messageListArray == nil)
    {
        _messageListArray = [NSMutableArray array];
    }
    return _messageListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"鸟斯基小秘书";
    self.tableViewStyle = UITableViewStylePlain;
    self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listView.layoutMargins = UIEdgeInsetsMake(0, 15, 0, 0);
    self.listView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self beginRefreshing];
    }];
    self.listView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self lodingMore];
    }];
    
    [self beginRefreshing];
}

-(void)getInfo:(NSInteger)page{
    
    self.messageListArray = [[SJDataBase searchSystemMessage] mutableCopy];
    if (kArrayIsEmpty(self.messageListArray)) {
        if (!self.footView.superview) {
            [self.listView addSubview:self.footView];
            [self.listView reloadData];
        }
    } else {
        if (self.footView.superview) {
            [self.footView removeFromSuperview];
        }
    }
    
    NSString *messageID = [[NSUserDefaults standardUserDefaults] objectForKey:@"systemMessageId"];
    if ([messageID isKindOfClass:[NSString class]]) {
        if (kStringIsEmpty(messageID)) {
            messageID = @"";
        }
    } else {
        if (kObjectIsEmpty(messageID)) {
            messageID = @"";
        }
    }
    [JAMessagePresenter postQuerySystemMessage:[messageID integerValue] Page:page Limit:20 Result:^(SJSystemMessageListModel * _Nullable model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listView.mj_header endRefreshing];
            [self.listView.mj_footer endRefreshing];
            
            if (model.success && page == 1 && [model.data.list count] > 0 ) {
                JASystemModel *firstModel = [model.data.list firstObject];
                [[NSUserDefaults standardUserDefaults] setInteger:firstModel.ID forKey:@"systemMessageId"];
            }
            for (NSInteger i = model.data.list.count-1; i>=0;i--) {
                JASystemModel *systemModel = model.data.list[i];
               JASystemModel *searchModel =  [SJDataBase searchWithId:systemModel.ID];
                if (!searchModel) {
                    [SJDataBase insertWithModel:systemModel];
                    [self.messageListArray insertObject:systemModel atIndex:0];
                }
            }
            if (kArrayIsEmpty(model.data.list)) {
                [self.listView.mj_footer endRefreshingWithNoMoreData];
            } else {
                if (self.footView.superview) {
                    [self.footView removeFromSuperview];
                }
            }
            [self.listView reloadData];
        });
    }];
}

- (void)beginRefreshing {
    self.page = 1;
    [self getInfo:self.page];
}

- (void)lodingMore {
    [self getInfo:(self.page + 1)];
}

#pragma mark - footView
- (SJNoDataFootView *)footView{
    if (!_footView) {
        _footView = [SJNoDataFootView createCellWithXib];
        _footView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _footView.imageTopHeight.constant = _footView.frame.size.height/3;
        _footView.describeLabel.text = @"空空如也";
        
    }
    [self footViewRefresh:nil];
    return _footView;
}

- (void)footViewRefresh:(NSString *)message{
    _footView.isShow = NO;
    _footView.imageView.image = [UIImage imageNamed:@"search_noData"];
    if ([self.messageListArray count] > 0) {
        if (_footView.superview) {
            [_footView removeFromSuperview];
        }
    } else {
        if (!_footView.superview) {
            [self.view addSubview:_footView];
        }
    }
    [_footView reloadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JASystemModel *model = [self.messageListArray objectAtIndex:indexPath.row];
    return [SJSystemMessageTableViewCell cellHeightWithMessageModel:model];
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView
         cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString*cellID = [NSString stringWithFormat:@"SJSystemMessageTableViewCell-%zd", indexPath.row];
    SJSystemMessageTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell ==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SJSystemMessageTableViewCell class]) owner:nil options:nil] lastObject];
        //因为reuseIdentifier属性是readonly的，使用kvc赋值
        [cell setValue:cellID forKey:@"reuseIdentifier"];
    }
    JASystemModel *model = [self.messageListArray objectAtIndex:indexPath.row];
    [cell setSystemMessage:model];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messageListArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JASystemModel *model = [self.messageListArray objectAtIndex:indexPath.row];
//    if (!model.isRead) {
//        model.isRead = YES;
//        [SJDataBase updateWithModel:model messageId:model.ID];
//    }
    if (model.messageType == 2) {
        SJDetailController *detailVC = [[SJDetailController alloc] init];
        detailVC.titleName = @"详情";
        detailVC.detailStr = model.h5Link;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController showViewController:detailVC
                                                   sender:nil];
        });
    } else {
        SJSystemDetailViewController *systemDetailVC = [[SJSystemDetailViewController alloc] init];
        systemDetailVC.systemModel = model;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController showViewController:systemDetailVC
                                                   sender:nil];
        });
    }
}

@end
