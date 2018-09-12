//
//  SJMessageVC.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/30.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//
// 消息

#import "SJMessageVC.h"
#import "SJMessageTableViewCell.h"
#import "JAMessageListModel.h"

#import "SJOtherInfoPageController.h"
#import "SJFootprintDetailsController.h"
#import "SJNoteDetailController.h"
#import "SJChildCommentListViewController.h"
#import "SJOtherInfoPageController.h"
#import "SJNoteSubReplyController.h"
#import "SJCommentMessageTableViewCell.h"

#import "JABbsPresenter.h"
#import "JAForumPresenter.h"

@interface SJMessageVC ()<UITableViewDelegate,UITableViewDataSource, SJCommentMessageCellDelegate>

@property(nonatomic, strong, nonnull)SJNoDataFootView *footView;
@property(nonatomic,assign) NSInteger page;
@property(nonatomic,retain)JAMessageListModel *messageListModel;


@end

@implementation SJMessageVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = self.navTitle;
    
    self.tableViewStyle = UITableViewStylePlain;
    self.listView.separatorColor = HEXCOLOR(@"EEEEEE");
    [self.listView registerNib:[UINib nibWithNibName:@"SJMessageTableViewCell" bundle:nil]
        forCellReuseIdentifier:@"SJMessageTableViewCell"];
    [self.listView registerNib:[UINib nibWithNibName:@"SJCommentMessageTableViewCell" bundle:nil]
        forCellReuseIdentifier:@"SJCommentMessageTableViewCell"];
    self.listView.tableFooterView = self.footView ;
    self.listView.estimatedRowHeight = 70;
    self.listView.rowHeight = UITableViewAutomaticDimension;
    self.listView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self beginRefreshing];
    }];
    
    self.listView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self lodingMore];
    }];
    
    [self beginRefreshing];
}

-(void)getInfo:(NSInteger)page{
    [JAMessagePresenter postMessageList:self.messageType page:page Limit:20 Result:^(JAMessageListModel * _Nullable model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listView.mj_header endRefreshing];
            [self.listView.mj_footer endRefreshing];
            if (page == 1) {
                self.messageListModel = model;
            } else {
                NSMutableArray *array = [self.messageListModel.data.list mutableCopy];
                self.messageListModel = model;
                [array addObjectsFromArray:self.messageListModel.data.list];
                self.messageListModel.data.list = array;
            }
            if ([model.data.list count] < 20) {
                [self.listView.mj_footer endRefreshingWithNoMoreData];
            }
            self.listView.tableFooterView = self.footView;
            [self footViewRefresh:model.responseStatus.message];
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
        
    }
    [self footViewRefresh:nil];
    return _footView;
}

- (void)footViewRefresh:(NSString *)message{
    if (message.length == 0) {
        message = @"获取中";
    }
    _footView.isShow = NO;
    _footView.imageView.image = [UIImage imageNamed:@"search_noData"];
    if ([self.messageListModel.data.list count] > 0) {
        self.listView.tableFooterView = nil;
        if (!self.messageListModel.success) {
            [SVProgressHUD showInfoWithStatus:message];
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        }
    } else {
        if (self.messageListModel.success) {
            _footView.describeLabel.text = @"空空如也";
        } else {
            _footView.describeLabel.text = message;
        }
        self.listView.tableFooterView = _footView;
    }
    [_footView reloadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(nonnull UITableView *)tableView
         cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (self.messageType == MessageTypeComment) {
        SJCommentMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SJCommentMessageTableViewCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        JAMessageModel *model = [self.messageListModel.data.list objectAtIndex:indexPath.row];
        cell.model = model;
        cell.delegate = self;
        return cell;
    }
    SJMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SJMessageTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
     cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    JAMessageModel *model = [self.messageListModel.data.list objectAtIndex:indexPath.row];
    [cell setMessageAction:model messageType:self.messageType];
    cell.headBlock = ^(NSInteger userId) {
       
        SJOtherInfoPageController *otherVC = [[SJOtherInfoPageController alloc] init];
        otherVC.userId = userId;
        [self.navigationController pushViewController:otherVC animated:YES];
    };
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messageListModel.data.list count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JAMessageModel *messageModel = [self.messageListModel.data.list objectAtIndex:indexPath.row];
    if (self.messageType == MessageTypeComment) {
        [self pushNoteChildController:messageModel.rootId postId:messageModel.postId];
    } else if (self.messageType == MessageTypeLike){
        [self pushToNoteController:messageModel.relevanceId];
    } else if (self.messageType == MessageTypeAttention){
        [self pushToFansController:messageModel];
    }
    
    
//    //点击进入详情
//    switch (messageModel.messageType) {
//        case 2://评论
//        {
//            LogD(@"跳转到帖子或者活动...");
//            [self pushNoteChildController:messageModel.relevanceId];
//            break;
//        }
//        case 3://点赞帖子
//        {
//            LogD(@"跳转到帖子或者活动...");
//
//            break;
//        }
//        case 4://关注
//        {
//            LogD(@"关注产生的消息...");
//
//             break;
//        }
//        case 5://点赞点评
//        {
//            LogD(@"跳转到帖子或者活动...");
//             [self pushActvityChildController:messageModel.relevanceId];
//            break;
//        }
//        case 6://回复
//        {
//            LogD(@"跳转到帖子或者活动...");
//            if (messageModel.messageSecType == 2) {
//                [self pushActvityChildController:messageModel.relevanceId];
//            }else{
//
//            }
//            break;
//        }
//        default:
//            break;
//    }
}

#pragma mark - SJCommentMessageCellDelegate
- (void)didClickBigHeadView:(NSInteger)userId
{
    SJOtherInfoPageController *otherVC = [[SJOtherInfoPageController alloc] init];
    otherVC.userId = userId;
    [self.navigationController pushViewController:otherVC animated:YES];
}

- (void)didClickSmallHeadView:(NSInteger)userId
{
    SJOtherInfoPageController *otherVC = [[SJOtherInfoPageController alloc] init];
    otherVC.userId = userId;
    [self.navigationController pushViewController:otherVC animated:YES];
}

- (void)didClickMainView:(NSInteger)postId
{
    SJNoteDetailController *detailVC = [[SJNoteDetailController alloc] init];
    detailVC.titleName = @"帖子详情";
    detailVC.noteId = postId;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)pushToFansController:(JAMessageModel *)messageModel{
    SJOtherInfoPageController *anotherPageVC = [[SJOtherInfoPageController alloc] init];
    anotherPageVC.userId = messageModel.sendUserId;
    anotherPageVC.titleName = @"";
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController showViewController:anotherPageVC
                                               sender:nil];
    });
}

- (void)pushToFootprintController:(NSInteger)activityId{
    //活动详情
    SJFootprintDetailsController *detailVC = [[SJFootprintDetailsController alloc] init];
    detailVC.activityId = activityId;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController showViewController:detailVC
                                               sender:nil];
    });
}

- (void)pushToNoteController:(NSInteger)noteId{
    //帖子详情
    SJNoteDetailController *detailVC = [[SJNoteDetailController alloc] init];
    detailVC.noteId = noteId;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController showViewController:detailVC
                                               sender:nil];
    });
}

-(void)pushActvityChildController:(NSInteger)commentID{
  //足迹子评论
    SJChildCommentListViewController *childCommentListVC = [[SJChildCommentListViewController alloc] init];
    childCommentListVC.titleName = @"评论详情";
    childCommentListVC.commentId = commentID;
    childCommentListVC.activityId = 0;
    childCommentListVC.commentUserId = 0;
    childCommentListVC.authorId = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController showViewController:childCommentListVC
                                               sender:nil];
    });
}

-(void)pushNoteChildController:(NSInteger)commentID postId:(NSInteger)postId {
    //帖子子评论
    SJNoteSubReplyController *subReplyVC = [[SJNoteSubReplyController alloc] init];
    subReplyVC.titleName = @"评论详情";
    JAPostCommentItemModel *model = [[JAPostCommentItemModel alloc] init];
    model.detailId = postId;
    model.ID = commentID;
    model.userId = 0;
    subReplyVC.superCommentModel = model;
    [self.navigationController pushViewController:subReplyVC animated:YES];
}



@end
