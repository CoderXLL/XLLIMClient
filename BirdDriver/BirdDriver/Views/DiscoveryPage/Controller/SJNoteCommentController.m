//
//  SJNoteCommentController.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/9.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJNoteCommentController.h"
#import "SJOtherInfoPageController.h"
#import "SJLoginController.h"
#import "SJReportController.h"
#import "SJNoteSubReplyController.h"
#import "SJNoteReplyCell.h"
#import "SJReplyView.h"
#import "JABbsPresenter.h"
#import "JAForumPresenter.h"

@interface SJNoteCommentController () <SJNoteReplyProtocol>

@property (nonatomic, strong) NSMutableDictionary *commentDict;

@end

@implementation SJNoteCommentController
static NSString *const SJCurrentPage = @"SJCurrentPage";
static NSString *const SJCurrentData = @"SJCurrentData";
static NSString *const SJFooterHiden = @"SJFooterHiden";

#pragma mark - lazy loading
- (NSMutableDictionary *)commentDict
{
    if (_commentDict == nil)
    {
        _commentDict = [NSMutableDictionary dictionary];
        [_commentDict setValue:@"1" forKey:SJCurrentPage];
        [_commentDict setValue:[NSMutableArray array] forKey:SJCurrentData];
        [_commentDict setValue:@"0" forKey:SJFooterHiden];
    }
    return _commentDict;
}

- (void)viewDidLoad {
    self.tableViewStyle = UITableViewStyleGrouped;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        self.listView.estimatedSectionHeaderHeight = 0;
        self.listView.estimatedSectionFooterHeight = 0;
        self.listView.estimatedRowHeight = 0;
        self.listView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //添加加载更多
    [self addRefreshView];
    [self getCommentList];
}

- (void)getCommentList
{
    NSString *currentPage = [self.commentDict valueForKey:SJCurrentPage];
    NSMutableArray *commentList = [self.commentDict valueForKey:SJCurrentData];
    [SVProgressHUD show];
    [JAForumPresenter postQueryCommentPage:YES withCurrentPage:[currentPage integerValue] withLimit:20 detailId:self.noteId OrderBy:nil Sort:@" desc" Result:^(JAPostCommentModel * _Nullable model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (model.success)
            {
                [commentList addObjectsFromArray:model.data.list];
                self.listView.mj_footer.hidden = (model.data.list.count < 20);
                [self.listView reloadData];
                [self.listView.mj_footer endRefreshing];
                [self.listView.mj_header endRefreshing];
                [SVProgressHUD dismiss];
            } else {
                [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            }
        });
    }];
}

- (void)addRefreshView
{
    __weak typeof(self)weakSelf = self;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        NSString *currentPage = [weakSelf.commentDict valueForKey:SJCurrentPage];
        [weakSelf.commentDict setValue:[NSString stringWithFormat:@"%zd", [currentPage integerValue]+1] forKey:SJCurrentPage];
        [weakSelf getCommentList];
    }];
    self.listView.mj_footer = footer;
    self.listView.mj_footer.hidden = YES;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf.commentDict setValue:@"1" forKey:SJCurrentPage];
        NSMutableArray *commentList = [weakSelf.commentDict valueForKey:SJCurrentData];
        [commentList removeAllObjects];
        [weakSelf getCommentList];
    }];
    self.listView.mj_header = header;
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *commentList = [self.commentDict valueForKey:SJCurrentData];
    return commentList.count;
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
    NSMutableArray *commentList = [self.commentDict valueForKey:SJCurrentData];
    JAPostCommentItemModel *commentModel = commentList[indexPath.row];
    return commentModel.cellHeight+34-10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *commentList = [self.commentDict valueForKey:SJCurrentData];
    JAPostCommentItemModel *commentModel = commentList[indexPath.row];
    SJNoteReplyCell *cell = [SJNoteReplyCell xibCell:tableView];
    cell.model = commentModel;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![self alertAction]) return;
    NSMutableArray *commentList = [self.commentDict valueForKey:SJCurrentData];
    JAPostCommentItemModel *commentModel = commentList[indexPath.row];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *replyAction = [UIAlertAction actionWithTitle:@"回复" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [self replyWithCommentModel:commentModel];
    }];
    UIAlertAction *reportAction = [UIAlertAction actionWithTitle:@"投诉" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        SJReportController *reportVC = [[SJReportController alloc] init];
        reportVC.reportSuccess = ^{
            
            NSMutableArray *commentList = [self.commentDict valueForKey:SJCurrentData];
            [commentList removeObject:commentModel];
            [self.listView reloadData];
            if (self.deleteBlock) {
                self.deleteBlock(commentModel.ID);
            }
        };
        reportVC.reportStyle = SJReportStyleReply;
        SJReportCommentModel *reportModel = [[SJReportCommentModel alloc] init];
        reportModel.replyId = commentModel.ID;
        reportModel.replyUserId = commentModel.userId;
        reportModel.replyUserName = commentModel.nickName;
        reportModel.replyContent = commentModel.content;
        reportVC.commentModel = reportModel;
        reportVC.commentModel = reportModel;
        [self.navigationController pushViewController:reportVC animated:YES];
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
        if (commentModel.userId != SPLocalInfo.userModel.Id) {
            [SVProgressHUD showInfoWithStatus:@"只能删除自己的评论哦~"];
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            return ;
        }
        [SVProgressHUD show];
        [JAForumPresenter postDeleteComment:commentModel.ID Result:^(JAResponseModel * _Nullable model) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (model.success) {
                    
                    [SVProgressHUD dismiss];
                    NSMutableArray *commentList = [self.commentDict valueForKey:SJCurrentData];
                    [commentList removeObject:commentModel];
                    [self.listView reloadData];
                } else {
                    [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                }
            });
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:replyAction];
    if (commentModel.userId == SPLocalInfo.userModel.Id) {
        [alertVC addAction:deleteAction];
    } else {
        [alertVC addAction:reportAction];
    }
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)replyWithCommentModel:(JAPostCommentItemModel *)commentModel
{
    SJReplyView *replyView = [SJReplyView replyViewWithPlaceHolder:[NSString stringWithFormat:@"回复%@:", commentModel.nickName] SendBlock:^(NSString *replyStr) {
        
        [JAForumPresenter postAddChildComment:self.noteId superCommentId:commentModel.ID content:replyStr imagesAddress:nil score:0 Result:^(JACommentVOModel * _Nullable model) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (model.success) {
                    
                    commentModel.commentVO = model;
                    commentModel.childCommentNum+=1;
                    NSMutableArray *commentList = [self.commentDict valueForKey:SJCurrentData];
                    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:[commentList indexOfObject:commentModel] inSection:0];
                    [self.listView reloadRowsAtIndexPaths:@[currentIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [SVProgressHUD showSuccessWithStatus:@"回复成功"];
                } else {
                    [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                }
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            });
        }];
    }];
    [replyView show];
}

#pragma mark - SJNoteReplyProtocol
- (void)didClickMoreReply:(id)model
{
    if (![model isKindOfClass:[JAPostCommentItemModel class]])
        return;
    JAPostCommentItemModel *commentModel = (JAPostCommentItemModel *)model;
    SJNoteSubReplyController *subReplyVC = [[SJNoteSubReplyController alloc] init];
    subReplyVC.titleName = @"评论详情";
    subReplyVC.deleteBlock = ^(NSInteger commentId) {
        NSMutableArray *commentList = [self.commentDict valueForKey:SJCurrentData];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.ID == %d", commentId];
        NSArray *filterArray = [commentList filteredArrayUsingPredicate:predicate];
        if (!kArrayIsEmpty(filterArray)) {
            JACommentModel *currentModel = filterArray.firstObject;
            [commentList removeObject:currentModel];
            [self.listView reloadData];
        }
        if (self.deleteBlock) {
            self.deleteBlock(commentId);
        }
    };
    subReplyVC.superCommentModel = commentModel;
    [self.navigationController pushViewController:subReplyVC animated:YES];
}

- (void)didClickReply:(id)model
{
    if ([self alertAction]) {
        if (![model isKindOfClass:[JAPostCommentItemModel class]])
            return;
        JAPostCommentItemModel *commentModel = (JAPostCommentItemModel *)model;
        [self replyWithCommentModel:commentModel];
    }
}

- (void)didClickUserHead:(id)model
{
    if (![model isKindOfClass:[JAPostCommentItemModel class]])
        return;
    JAPostCommentItemModel *commentModel = (JAPostCommentItemModel *)model;
    SJOtherInfoPageController *anotherVC = [[SJOtherInfoPageController alloc] init];
    anotherVC.userId = commentModel.userId;
    anotherVC.titleName = [NSString stringWithFormat:@"%@的个人主页", commentModel.nickName];
    [self.navigationController pushViewController:anotherVC animated:YES];
}

-(BOOL)alertAction
{
    if (!SPLocalInfo.hasBeenLogin) {
        SJAlertModel *alertModel = [[SJAlertModel alloc] initWithTitle:@"确认" handler:^(id content) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_Login_Request
                                                                    object:nil];
        }];
        SJAlertModel *cancelModel = [[SJAlertModel alloc] initWithTitle:@"取消"
                                                                handler:^(id content) {
                                                                }];
        SJAlertView *alertView = [SJAlertView alertWithTitle:@"是否登录"
                                                     message:@""
                                                        type:SJAlertShowTypeNormal
                                                 alertModels:@[alertModel,cancelModel]];
        [alertView showAlertView];
        return NO;
    }
    return YES;
}

@end
