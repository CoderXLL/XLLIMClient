//
//  SJNoteSubReplyController.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/9.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJNoteSubReplyController.h"
#import "SJLoginController.h"
#import "SJOtherInfoPageController.h"
#import "SJReportController.h"
#import "JABbsPresenter.h"
#import "JAForumPresenter.h"
#import "SJNoteReplyCell.h"
#import "SJReplyView.h"

@interface SJNoteSubReplyController () <SJNoteReplyProtocol>

@property (nonatomic, strong) NSMutableDictionary *commentDict;

@end

@implementation SJNoteSubReplyController
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self getChildCommentLists];
    [self addRefreshView];
}

- (void)getChildCommentLists
{
    NSString *currentPage = [self.commentDict valueForKey:SJCurrentPage];
    NSMutableArray *commentList = [self.commentDict valueForKey:SJCurrentData];
    [SVProgressHUD show];
    [JAForumPresenter postQueryCommentDetailPage:YES withCurrentPage:[currentPage integerValue] withLimit:20 commentId:self.superCommentModel.ID OrderBy:nil Sort:@" desc" Result:^(JAPostChildCommentModel * _Nullable model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (model.success) {
                
                if ([currentPage isEqualToString:@"1"])
                {
                    if (!kObjectIsEmpty(model.superComment)) {
                        [commentList addObject:model.superComment];
                    }
                }
                [commentList addObjectsFromArray:model.data.list];
                self.listView.mj_footer.hidden = (model.data.list.count < 20);
                [self.listView reloadData];
                [SVProgressHUD dismiss];
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

- (void)addRefreshView
{
    __weak typeof(self)weakSelf = self;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        NSString *currentPage = [weakSelf.commentDict valueForKey:SJCurrentPage];
        [weakSelf.commentDict setValue:[NSString stringWithFormat:@"%zd", [currentPage integerValue]+1] forKey:SJCurrentPage];
        [weakSelf getChildCommentLists];
    }];
    self.listView.mj_footer = footer;
    self.listView.mj_footer.hidden = YES;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf.commentDict setValue:@"1" forKey:SJCurrentPage];
        NSMutableArray *commentList = [weakSelf.commentDict valueForKey:SJCurrentData];
        [commentList removeAllObjects];
        [weakSelf getChildCommentLists];
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
    JACommentVOModel *detailModel = commentList[indexPath.row];
    return detailModel.cellHeight+34-10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *commentList = [self.commentDict valueForKey:SJCurrentData];
    JACommentVOModel *commentModel = commentList[indexPath.row];
    SJNoteReplyCell *cell = [SJNoteReplyCell xibCell:tableView];
    cell.model = commentModel;
    cell.delegate = self;
    cell.isChildComment = (indexPath.row != 0);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![self alertAction]) return;
    NSMutableArray *commentList = [self.commentDict valueForKey:SJCurrentData];
    JACommentVOModel *commentModel = commentList[indexPath.row];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *replyAction = [UIAlertAction actionWithTitle:@"回复" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [self replyWithCommentModel:commentModel];
    }];
    UIAlertAction *reportAction = [UIAlertAction actionWithTitle:@"投诉" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        SJReportController *reportVC = [[SJReportController alloc] init];
        reportVC.reportSuccess = ^{
            
            NSMutableArray *commentList = [self.commentDict valueForKey:SJCurrentData];
            if ([commentList containsObject:commentModel]) {
                [commentList removeObject:commentModel];
            }
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
                    if ([commentList containsObject:commentModel]) {
                        [commentList removeObject:commentModel];
                    }
                    [self.listView reloadData];
                    if (commentModel.ID == self.superCommentModel.ID) {
                        if (self.deleteBlock) {
                            self.deleteBlock(commentModel.ID);
                        }
                        [self.navigationController popViewControllerAnimated:YES];
                    }
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

#pragma mark - SJNoteReplyProtocol
- (void)didClickReply:(id)model
{
    if ([self alertAction]) {
        if (![model isKindOfClass:[JACommentVOModel class]]) return;
        JACommentVOModel *commentModel = (JACommentVOModel *)model;
        [self replyWithCommentModel:commentModel];
    }
}

- (void)didClickUserHead:(id)model
{
    if (![model isKindOfClass:[JACommentVOModel class]]) return;
    JACommentVOModel *commentModel = (JACommentVOModel *)model;
    SJOtherInfoPageController *anotherVC = [[SJOtherInfoPageController alloc] init];
    anotherVC.userId = commentModel.userId;
    [self.navigationController pushViewController:anotherVC animated:YES];
}

- (void)replyWithCommentModel:(JACommentVOModel *)commentModel
{
    SJReplyView *replyView = [SJReplyView replyViewWithPlaceHolder:[NSString stringWithFormat:@"回复%@:", commentModel.nickName] SendBlock:^(NSString *replyStr) {
        
        if (self.superCommentModel.ID == commentModel.ID) { //添加子评论
            
            [JAForumPresenter postAddChildComment:commentModel.detailId superCommentId:self.superCommentModel.ID content:replyStr imagesAddress:nil score:0 Result:^(JACommentVOModel * _Nullable model) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (model.success) {
                        
                        NSMutableArray *commentList = [self.commentDict valueForKey:SJCurrentData];
                        if (commentList.count > 1) {
                            [commentList insertObject:model atIndex:1];
                        }
                        [self.listView reloadData];
                        [SVProgressHUD showSuccessWithStatus:@"回复成功"];
                    } else {
                        [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                    }
                    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                });
            }];
        } else { //添加回复
            
            [JAForumPresenter postAddReply:commentModel.detailId superCommentId:commentModel.ID replyUserId:commentModel.userId content:replyStr imagesAddress:nil score:0 Result:^(JACommentVOModel * _Nullable model) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (model.success) {
                        
                        NSMutableArray *commentList = [self.commentDict valueForKey:SJCurrentData];
                        if (commentList.count > 1) {
                            [commentList insertObject:model atIndex:1];
                        }
                        [self.listView reloadData];
                        [SVProgressHUD showSuccessWithStatus:@"回复成功"];
                    } else {
                        [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                    }
                    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                });
            }];
        }
    }];
    [replyView show];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
