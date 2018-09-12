//
//  SJNoteDetailController.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/16.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJNoteDetailController.h"
#import "SJBrowserController.h"
#import "SJLoginController.h"
#import "SJNoteCommentController.h"
#import "SJOtherInfoPageController.h"
#import "SJNoteSubReplyController.h"
#import "SJComplaintsSuccessfullyViewController.h"
#import "SJReportController.h"
#import "SJAttachment.h"
#import "JABbsPresenter.h"
#import "JAForumPresenter.h"
#import "SJHtmlTransfer.h"
#import "SJNoteTitleCell.h"
#import "SJDetailAttributedCell.h"
#import "SJDetailNoteCell.h"
#import "SJDetailNoteView.h"
#import "SJHomeHotUserRow.h"
#import "SJNoteCommentCell.h"
#import "SJNoteInputView.h"
#import "SJReplyView.h"
#import "SJShareView.h"
#import "SJSheetView.h"
#import "SJCommentReportView.h"
#import "UIImage+ColorsImage.h"
#import <WXApi.h>

@interface SJNoteDetailController () <SJHomeHotUserRowDelegate, SJNoteInputViewDelegate, SJDetailNoteViewDelegate, SJNoteReplyProtocol>
{
    //是否被我举报过
    BOOL _isReported;
}

@property (nonatomic, strong) JABBSModel *detailModel;
@property (nonatomic, weak) SJNoteInputView *noteInputView;
@property (nonatomic, weak) SJDetailNoteView *detailHeaderView;

@property (nonatomic, strong) UIButton *collectionBtn;
@property (nonatomic, strong) UIBarButtonItem *collectionItem;
@property (nonatomic, strong) UIBarButtonItem *moreItem;
@property (nonatomic, strong) UIBarButtonItem *deleteItem;

@property (nonatomic, strong) NSMutableDictionary *commentDict;

@end

@implementation SJNoteDetailController
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO
                                             animated:NO];
}

- (void)viewDidLoad {
    self.tableViewStyle = UITableViewStyleGrouped;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.titleName = @"帖子详情";
    [self setupSubViews];
 
    self.listView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    if (@available(iOS 11.0, *)) {
        self.listView.estimatedSectionHeaderHeight = 0;
        self.listView.estimatedSectionFooterHeight = 0;
        self.listView.estimatedRowHeight = 0;
        self.listView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self createNoteDetailHeader];
    //获取帖子详情
    [self getNoteDetails];
    //获取评论
    [self getCommentList];
    //此帖是否被我举报过
    [self judgeIsReported];
    //添加加载更多
//    [self addRefreshView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(judgeIsReported) name:kNotify_loginSuccess
                                               object:nil];
}

- (void)createNoteDetailHeader
{
    SJDetailNoteView *headerView = [SJDetailNoteView createCellWithXib];
    headerView.delegate = self;
    __weak typeof(self)weakSelf = self;
    headerView.userDetailBlock = ^(JABBSModel *detailModel) {
      
        SJOtherInfoPageController *anotherVC = [[SJOtherInfoPageController alloc] init];
        anotherVC.userId = detailModel.detail.detailsUserId;
        anotherVC.titleName = [NSString stringWithFormat:@"%@的个人主页", detailModel.nickName];
        [weakSelf.navigationController pushViewController:anotherVC animated:YES];
    };
    headerView.heightBlock = ^(CGFloat totalHeight) {
        
        weakSelf.detailHeaderView.height = totalHeight;
        [UIView setAnimationsEnabled:NO];
        [weakSelf.listView beginUpdates];
        [weakSelf.listView setTableHeaderView:weakSelf.detailHeaderView];
        [weakSelf.listView endUpdates];
        [UIView setAnimationsEnabled:YES];
    };
    self.listView.tableHeaderView = headerView;
    self.detailHeaderView = headerView;
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
}

//判断是否被举报过
- (void)judgeIsReported
{
    if ([SPLocalInfo hasBeenLogin]) {
        
        [JABbsPresenter postIsReported:self.noteId Result:^(JAIsReportedModel * _Nullable model) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                self->_isReported = model.reported;
            });
        }];
    }
}

- (void)setupSubViews
{
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.size = CGSizeMake(50, 30);
    [moreBtn setImage:[UIImage imageNamed:@"detail_more"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    self.moreItem = moreItem;
    
    self.collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.collectionBtn.size = CGSizeMake(50, 30);
    [self.collectionBtn setImage:[UIImage imageNamed:@"activity_collection_nor"] forState:UIControlStateNormal];
    [self.collectionBtn setImage:[UIImage imageNamed:@"activity_collection_sel"] forState:UIControlStateSelected];
    [self.collectionBtn addTarget:self action:@selector(collectionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *collectionItem = [[UIBarButtonItem alloc] initWithCustomView:self.collectionBtn];
    self.collectionItem = collectionItem;
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.size = CGSizeMake(50, 30);
    [deleteBtn setImage:[UIImage imageNamed:@"detail_delete"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithCustomView:deleteBtn];
    self.deleteItem = deleteItem;
    
    [self.view addSubview:self.noteInputView];
    [self.noteInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottomMargin);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
}

#pragma mark - event
- (void)deleteBtnClick
{
    [SVProgressHUD show];
    [JAForumPresenter postDeletePostById:self.detailModel.detail.Id Result:^(JAResponseModel * _Nullable model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (model.success) {
                [SVProgressHUD dismiss];
                if (self.deleteBlock) {
                    self.deleteBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            }
        });
    }];
}

- (void)moreItemClick
{
    SJSheetModel *circleModel = [[SJSheetModel alloc] init];
    circleModel.name = @"朋友圈";
    circleModel.actionType = SJSheetViewActionTypeCircle;
    circleModel.imageStr = @"more_circle";
    
    SJSheetModel *friendModel = [[SJSheetModel alloc] init];
    friendModel.name = @"微信好友";
    friendModel.actionType = SJSheetViewActionTypeFriend;
    friendModel.imageStr = @"more_friend";
    
    SJSheetModel *reportModel = [[SJSheetModel alloc] init];
    reportModel.name = @"举报";
    reportModel.actionType = SJSheetViewActionTypeReport;
    reportModel.imageStr = @"more_report";
    
    SJSheetView *sheetView = [SJSheetView sheetViewWithSheetModels:[WXApi isWXAppInstalled]?@[circleModel, friendModel, reportModel]:@[reportModel]
                                                        ClickBlock:^(SJSheetViewActionType actionType) {
        
        switch (actionType) {
            case SJSheetViewActionTypeCircle:
            case SJSheetViewActionTypeFriend:
            {
                WXMediaMessage *message = [WXMediaMessage message];
                //分享帖子
                [[NSUserDefaults standardUserDefaults] setValue:@"3" forKey:kSJSharePageKey];
                [[NSUserDefaults standardUserDefaults] setValue:@(self.noteId) forKey:kSJShareDetailsIdKey];
                message.title = self.detailModel.detail.detailsName;
                message.description = @"上车，鸟斯基带你飞";
                UIImage *iconImage = [UIImage dealImage:[UIImage imageNamed:@"default_portrait"] scaleToSize:CGSizeMake(80, 80)];
                NSData *iconData = UIImagePNGRepresentation(iconImage);
                [message setThumbData:iconData];
                NSArray *imageArr = [self.detailModel.detail.imagesAddress componentsSeparatedByString:@","];
                if (!kArrayIsEmpty(imageArr)) {
                    
                    NSString *pictureAddress = imageArr.firstObject;
                    NSData *imageData = [NSData dataWithContentsOfURL:pictureAddress.mj_url];
                    UIImage *realImage = [UIImage dealImage:[UIImage imageWithData:imageData] scaleToSize:CGSizeMake(80, 80)];
                    [message setThumbData:UIImagePNGRepresentation(realImage)];
                }
                WXWebpageObject *ext = [WXWebpageObject object];
                ext.webpageUrl = [NSString stringWithFormat:@"%@/postingDetail?id=%zd", JA_SERVER_WEB, self.noteId];
                message.mediaObject = ext;
                SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
                req.bText = NO;
                req.message = message;
                req.scene = actionType==SJSheetViewActionTypeCircle?WXSceneTimeline:WXSceneSession;
                [WXApi sendReq:req];
            }
                break;
            case SJSheetViewActionTypeReport:
            {
                if (![self alertAction]) return ;
                if (self->_isReported) {
                    
                    SJComplaintsSuccessfullyViewController *successVC = [[SJComplaintsSuccessfullyViewController alloc] init];
                    [self.navigationController pushViewController:successVC animated:YES];
                } else {
                    if (self.detailModel.detail.detailsUserId == SPLocalInfo.userModel.Id) {
                        
                        [SVProgressHUD showInfoWithStatus:@"您不能举报自己的帖子"];
                        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                        return;
                    }
                    //举报
                    SJReportController *reportVC = [[SJReportController alloc] init];
                    reportVC.reportStyle = SJReportStyleNote;
                    reportVC.detailModel = self.detailModel;
                    reportVC.reportSuccess = ^{
                      
                        self->_isReported = YES;
                    };
                    [self.navigationController pushViewController:reportVC animated:YES];
                }
            }
                break;
                
            default:
                break;
        }
    }];
    [sheetView show];
}

- (void)collectionBtnClick
{
    if (![self alertAction]) return;
    if (self.collectionBtn.selected) {
        
        //取消收藏
        [SVProgressHUD show];
        [JABbsPresenter postUpdateCollection:self.detailModel.collectionId
                                    detailId:self.noteId
                                   isDeleted:YES
                                      Result:^(JAResponseModel * _Nullable model) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (model.success) {
                    self.collectionBtn.selected = NO;
                    self.detailModel.detail.collections -= 1;
                    self.detailHeaderView.detailModel = self.detailModel;
                    [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];
                } else {
                    [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                }
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            });
        }];
    } else {
        
        //收藏
        [SVProgressHUD show];
//        [JAForumPresenter postAddDetailCollection:self.noteId Result:^(JAAddCollectionModel * _Nullable model) {
//
//        }]
        [JABbsPresenter postAddCollection:self.noteId
                          WithDetailsType:JADetailsTypePost
                                   Result:^(JAAddCollectionModel * _Nullable model) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (model.success) {
                    self.detailModel.collectionId = model.collectionId;
                    self.detailModel.detail.collections += 1;
                    self.detailHeaderView.detailModel = self.detailModel;
                    self.collectionBtn.selected = YES;
                    [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
                } else {
                    [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                }
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            });
        }];
    }
}

-(BOOL)alertAction
{
    if (!SPLocalInfo.hasBeenLogin) {
        SJAlertModel *alertModel = [[SJAlertModel alloc] initWithTitle:@"确认"
                                                               handler:^(id content) {
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

- (void)getCommentList
{
    NSString *currentPage = [self.commentDict valueForKey:SJCurrentPage];
    NSMutableArray *commentList = [self.commentDict valueForKey:SJCurrentData];
    [JAForumPresenter postQueryCommentPage:YES withCurrentPage:[currentPage integerValue] withLimit:5 detailId:self.noteId OrderBy:nil Sort:@" desc" Result:^(JAPostCommentModel * _Nullable model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (model.success)
            {
                [commentList addObjectsFromArray:model.data.list];
                [self.listView reloadData];
            }
        });
    }];
}

- (void)getNoteDetails
{
    [SVProgressHUD show];
    [JABbsPresenter postQueryDetails:self.noteId
                              Result:^(JABBSModel * _Nullable model) {
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (model.success)
            {
                self.navigationItem.rightBarButtonItems = (model.detail.detailsUserId == SPLocalInfo.userModel.Id)?@[self.moreItem, self.deleteItem]:@[self.moreItem, self.collectionItem];
                self.detailModel = model;
                self.noteInputView.detailModel = self.detailModel;
                self.collectionBtn.selected = self.detailModel.collectionId;
                self.detailHeaderView.detailModel = self.detailModel;
                [self.listView reloadData];
            } else {
                [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
            }
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        });
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   if (section == 0) {
        return 1;
    }
    NSMutableArray *commentList = [self.commentDict valueForKey:SJCurrentData];
    if (kArrayIsEmpty(commentList)) {
        return 1;
    }
    return commentList.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        NSMutableArray *commentList = [self.commentDict valueForKey:SJCurrentData];
        if (!kArrayIsEmpty(commentList)) {
            
            UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45.0)];
            footView.backgroundColor = [UIColor whiteColor];
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:footView.bounds];
            tipLabel.textAlignment = NSTextAlignmentCenter;
            tipLabel.textColor = [UIColor colorWithHexString:@"212121" alpha:1];
            tipLabel.font = SPFont(12.0);
            tipLabel.text = @"没有更多了...";
            tipLabel.hidden = (commentList.count>=5);
            [footView addSubview:tipLabel];
            
            UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            moreBtn.frame = footView.bounds;
            moreBtn.backgroundColor = [UIColor whiteColor];
            [moreBtn setTitleColor:[UIColor colorWithHexString:@"BDBDBD" alpha:1] forState:UIControlStateNormal];
            moreBtn.titleLabel.font = SPFont(14.0);
            [moreBtn setTitle:@"查看全部评论" forState:UIControlStateNormal];
            [moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
            moreBtn.hidden = (commentList.count<5);
            [footView addSubview:moreBtn];
            return footView;
        }
    }
    return nil;
}

- (void)moreBtnClick
{
    SJNoteCommentController *commentVC = [[SJNoteCommentController alloc] init];
    commentVC.titleName = @"全部评论";
    commentVC.deleteBlock = ^(NSInteger commentId) {
        
        self.detailModel.detail.comments -= 1;
        NSMutableArray *commentList = [self.commentDict valueForKey:SJCurrentData];
        [commentList removeAllObjects];
        [self getCommentList];
        self.detailHeaderView.detailModel = self.detailModel;
    };
    commentVC.noteId = self.noteId;
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 120, 44)];
        descLabel.textAlignment = NSTextAlignmentLeft;
        descLabel.font = SPFont(15.0);
        descLabel.textColor = [UIColor colorWithHexString:@"2B3248" alpha:1.0];
        descLabel.text = @"相关用户";
        [headerView addSubview:descLabel];
        return headerView;
    } else if (section == 1) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 120, 44)];
        descLabel.textAlignment = NSTextAlignmentLeft;
        descLabel.font = SPFont(15.0);
        descLabel.textColor = [UIColor colorWithHexString:@"2B3248" alpha:1.0];
        descLabel.text = @"相关评论";
        [headerView addSubview:descLabel];
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        return kArrayIsEmpty(self.detailModel.userAccountPOsList)?170:131.f;
    }
    NSMutableArray *commentList = [self.commentDict valueForKey:SJCurrentData];
    if (kArrayIsEmpty(commentList)) {
        return 70.0;
    }    
    JAPostCommentItemModel *commentModel = commentList[indexPath.row];
    return commentModel.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        NSMutableArray *commentList = [self.commentDict valueForKey:SJCurrentData];
        if (!kArrayIsEmpty(commentList)) {
            return 45.0;
        }
    }
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1)
    {
        return 44.0;
    }
    return 0.0001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if (section == 0)
    {
        SJHomeHotUserRow *cell = [SJHomeHotUserRow xibCell:tableView];
        cell.hotUserList = self.detailModel.userAccountPOsList;
        cell.delegate = self;
        return cell;
    }
    NSMutableArray *commentList = [self.commentDict valueForKey:SJCurrentData];
    if (kArrayIsEmpty(commentList)) {
        SPBaseCell *cell = [SPBaseCell cell:tableView];
        cell.textLabel.text = @"暂无评论";
        cell.textLabel.font = SPFont(13.0);
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.contentView.backgroundColor = JMY_BG_COLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    SJNoteCommentCell *cell = [SJNoteCommentCell xibCell:tableView];
    JAPostCommentItemModel *commentModel = commentList[indexPath.row];
    cell.commentModel = commentModel;
    cell.floorCount = indexPath.row+1;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section != 1) return;
    if (![self alertAction]) return;
    NSMutableArray *commentList = [self.commentDict valueForKey:SJCurrentData];
    if (kArrayIsEmpty(commentList)) return;
    JAPostCommentItemModel *commentModel = commentList[indexPath.row];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *replyAction = [UIAlertAction actionWithTitle:@"回复" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        SJReplyView *replyView = [SJReplyView replyViewWithPlaceHolder:[NSString stringWithFormat:@"回复%@:", commentModel.nickName] SendBlock:^(NSString *replyStr) {
            
            [JAForumPresenter postAddChildComment:self.noteId superCommentId:commentModel.ID content:replyStr imagesAddress:nil score:0 Result:^(JACommentVOModel * _Nullable model) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (model.success) {
                        
                        commentModel.commentVO = model;
                        commentModel.childCommentNum+=1;
                        [self.listView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                        [SVProgressHUD showSuccessWithStatus:@"回复成功"];
                    } else {
                        [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                    }
                    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                });
            }];
        }];
        [replyView show];
    }];
    UIAlertAction *reportAction = [UIAlertAction actionWithTitle:@"投诉" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if (![self alertAction]) return ;
        
        if (SPLocalInfo.userModel.Id == commentModel.userId) {
            
            [SVProgressHUD showInfoWithStatus:@"您不能投诉自己的评论"];
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            return;
        }
        SJReportController *reportVC = [[SJReportController alloc] init];
        reportVC.reportSuccess = ^{
            
            self.detailModel.detail.comments -= 1;
            NSMutableArray *commentList = [self.commentDict valueForKey:SJCurrentData];
            [commentList removeAllObjects];
            [self getCommentList];
            self.detailHeaderView.detailModel = self.detailModel;
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
                    self.detailModel.detail.comments -= 1;
                    NSMutableArray *commentList = [self.commentDict valueForKey:SJCurrentData];
                    [commentList removeAllObjects];
                    [self getCommentList];
                    self.detailHeaderView.detailModel = self.detailModel;
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
- (void)didClickMoreReply:(id)model
{
    if (![model isKindOfClass:[JAPostCommentItemModel class]])
        return;
    JAPostCommentItemModel *commentModel = (JAPostCommentItemModel *)model;
    SJNoteSubReplyController *subReplyVC = [[SJNoteSubReplyController alloc] init];
    subReplyVC.titleName = @"评论详情";
    subReplyVC.deleteBlock = ^(NSInteger commentId) {
        self.detailModel.detail.comments -= 1;
        NSMutableArray *commentList = [self.commentDict valueForKey:SJCurrentData];
        [commentList removeAllObjects];
        [self getCommentList];
        self.detailHeaderView.detailModel = self.detailModel;
    };
    subReplyVC.superCommentModel = commentModel;
    [self.navigationController pushViewController:subReplyVC animated:YES];
}

- (void)didClickUserHead:(id)model
{
    if (![model isKindOfClass:[JAPostCommentItemModel class]])
        return;
    JAPostCommentItemModel *commentModel = (JAPostCommentItemModel *)model;
    SJOtherInfoPageController *anotherVC = [[SJOtherInfoPageController alloc] init];
    anotherVC.userId = commentModel.userId;
    [self.navigationController pushViewController:anotherVC animated:YES];
}

- (void)noteCommentModel:(id)model didClickReportBtn:(CGPoint)currentPoint
{
    if (![model isKindOfClass:[JAPostCommentItemModel class]])
        return;
    JAPostCommentItemModel *commentModel = (JAPostCommentItemModel *)model;
    SJCommentReportView *reportView = [SJCommentReportView createCommentReportView:^{
        
        if (![self alertAction]) return ;
        
        if (SPLocalInfo.userModel.Id == commentModel.userId) {
            
            [SVProgressHUD showInfoWithStatus:@"您不能投诉自己的评论"];
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            return;
        }
        SJReportController *reportVC = [[SJReportController alloc] init];
        reportVC.reportSuccess = ^{
            
            self.detailModel.detail.comments -= 1;
            NSMutableArray *commentList = [self.commentDict valueForKey:SJCurrentData];
            [commentList removeObject:commentModel];
            [self.listView reloadData];
            self.detailHeaderView.detailModel = self.detailModel;
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
    [reportView showInLocation:currentPoint];
}

#pragma mark - SJDetailNoteViewDelegate
- (void)didClickImageUrl:(NSString *)imageStr AllImageArr:(NSArray *)imageArr
{
    SJBrowserController *browserVC = [[SJBrowserController alloc] init];
    NSMutableArray *fetchPhotoResults = [imageArr mutableCopy];
    browserVC.fetchPhotoResults = fetchPhotoResults;
    browserVC.noEdit = YES;
    browserVC.currentIndex = [imageArr indexOfObject:imageStr];
    [self.navigationController pushViewController:browserVC animated:YES];
}

#pragma mark - SJHomeHotUserRowDelegate
- (void)didSelectedAccountModel:(id)userModel
{
    JAUserAccountPosList *posModel = (JAUserAccountPosList *)userModel;
    SJOtherInfoPageController *anotherVC = [[SJOtherInfoPageController alloc] init];
    anotherVC.userId = posModel.Id;
    anotherVC.titleName = [NSString stringWithFormat:@"%@的个人主页", posModel.nickName];
    [self.navigationController pushViewController:anotherVC animated:YES];
}

#pragma mark - SJNoteInputViewDelegate
- (void)didPraiseWithIsCancel:(BOOL)isCancel ResultBlock:(void(^)(BOOL))resultBlock
{
    if (![self alertAction]) return;
    if (isCancel) {
        
        [SVProgressHUD show];
        [JABbsPresenter postUpdatePraiseType:JADetailsTypePost
                                   detailsId:self.noteId
                                    praiseId:self.detailModel.praiseId.integerValue
                                   isDeleted:NO
                                      Result:^(JAUpdatePraiseModel * _Nullable model) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (resultBlock) {
                    resultBlock(model.success);
                }
                if (model.success) {
                    self.detailModel.detail.praises -= 1;
                    self.detailHeaderView.detailModel = self.detailModel;
                    //发送取消点赞通知
                    NSDictionary *info = @{
                                           @"detailsId":@(model.detailsId),
                                           @"praisesId":[NSNull null]
                                           };
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_notePraise object:@(NO) userInfo:info];
                }
                [SVProgressHUD dismiss];
            });
        }];
        
    } else {
        
        [SVProgressHUD show];
        [JABbsPresenter postAddPraise:JADetailsTypePost WithDetailsId:self.noteId Result:^(JAAddPraiseModel * _Nullable model) {
            
            self.detailModel.praiseId = [NSString stringWithFormat:@"%zd", model.praisesRelationId];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (resultBlock) {
                    resultBlock(model.success);
                }
                if (model.success) {
                    self.detailModel.detail.praises += 1;
                    self.detailHeaderView.detailModel = self.detailModel;
                    //发送点赞通知
                    NSDictionary *info = @{
                                           @"detailsId":@(model.detailsId),
                                           @"praisesId":@(model.praisesRelationId)
                                           };
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_notePraise object:@(YES) userInfo:info];
                    [SVProgressHUD dismiss];
                } else {
                    [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                }
            });
        }];
    }
}

- (void)didSendComment:(NSString *)commentText ResultBlock:(void (^)(BOOL))resultBlock
{
    if (![self alertAction]) {
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        if (resultBlock) {
            resultBlock(NO);
        }
        return;
    }
    if (kStringIsEmpty(commentText)) {
        [SVProgressHUD showErrorWithStatus:@"评论不能为空"];
        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        if (resultBlock) {
            resultBlock(NO);
        }
        return;
    }
    [JAForumPresenter postAddComment:self.noteId content:commentText imagesAddress:nil score:0 Result:^(JAPostCommentItemModel * _Nullable model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (resultBlock) {
                resultBlock(model.success);
            }
            if (model.success) {
                
                NSMutableArray *commentList = [self.commentDict valueForKey:SJCurrentData];
                [commentList insertObject:model atIndex:0];
                self.detailModel.detail.comments += 1;
                self.detailHeaderView.detailModel = self.detailModel;
                [self.listView reloadData];
                [self.listView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                [SVProgressHUD showSuccessWithStatus:@"发送成功"];
            } else {
                [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
            }
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        });
    }];
}

- (void)dealloc
{
    LogD(@"我走啦")
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (SJNoteInputView *)noteInputView{
    if (!_noteInputView) {
        _noteInputView = [SJNoteInputView createCellWithXib];
        _noteInputView.delegate = self;
    }
    
    return _noteInputView;
}

@end
