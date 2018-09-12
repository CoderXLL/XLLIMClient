//
//  SJFootprintDetailsController.m
//  BirdDriver
//
//  Created by Soul on 2018/7/17.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//  足迹详情页面 原生版

#import "SJFootprintDetailsController.h"
#import "SJLoginController.h"
#import "SJReportIllegalController.h"
#import "SJActivityReviewViewController.h"
#import "SJActivitiesTeamViewController.h"
#import "SJBrowserController.h"
#import "SJOtherInfoPageController.h"
#import "SJComplaintsSuccessfullyViewController.h"
#import "SJReportController.h"
#import "SJActivityCommentListViewController.h"
#import "SJChildCommentListViewController.h"

#import "SJFootprintDetailsBriefCell.h"
#import "SJFootprintDetialsCommentCell.h"

#import "SJShareView.h"
#import "SJSheetView.h"
#import "SJCommentReportView.h"

#import "JABbsPresenter.h"

#import "NSString+XHLStringSize.h"
#import "UIImage+ColorsImage.h"

@interface SJFootprintDetailsController ()<SJReportIllegalDelegate>

@property (nonatomic, strong) UIButton *enjoyBtn;
@property (nonatomic, strong) UIButton *collectionBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIBarButtonItem *enjoyItem;
@property (nonatomic, strong) UIBarButtonItem *collectionItem;
@property (nonatomic, strong) UIBarButtonItem *deleteItem;

@property (strong, nonatomic) UIButton *btn_comment;

@property (assign,nonatomic) BOOL isReported;

@end

@implementation SJFootprintDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.titleName = @"足迹详情";
    
    UIBarButtonItem *enjoyItem = [[UIBarButtonItem alloc] initWithCustomView:self.enjoyBtn];
    self.enjoyItem = enjoyItem;
    UIBarButtonItem *collectionItem = [[UIBarButtonItem alloc] initWithCustomView:self.collectionBtn];
    self.collectionItem = collectionItem;
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithCustomView:self.deleteBtn];
    self.deleteItem = deleteItem;
    
    self.listView.backgroundColor = SP_WHITE_COLOR;
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 128)];
    if (iPhoneX) {
        [footer setFrame:CGRectMake(0, 0, kScreenWidth, 128)];
    }else{
        [footer setFrame:CGRectMake(0, 0, kScreenWidth, 68)];
    }
    self.listView.tableFooterView = footer;
    
    [self.listView registerNib:[UINib nibWithNibName:NSStringFromClass([SJFootprintDetailsBriefCell class]) bundle:nil]
        forCellReuseIdentifier:NSStringFromClass([SJFootprintDetailsBriefCell class])];
     [self.listView registerNib:[UINib nibWithNibName:NSStringFromClass([SJFootprintDetialsCommentCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([SJFootprintDetialsCommentCell class])];
    self.listView.rowHeight = UITableViewAutomaticDimension;
    
    [self.view addSubview:self.btn_comment];
    [self.btn_comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottomMargin);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(kScreenWidth - 30));
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO
                                             animated:NO];
    
    [self judgeIsReported];
    
    [self refreashActivityDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Tableview Datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0 == indexPath.section) {
        SJFootprintDetailsBriefCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SJFootprintDetailsBriefCell class])];
        if (cell == nil) {
            cell = [SJFootprintDetailsBriefCell xibCell:tableView];
        }

        cell.activityModel = self.activityModel?self.activityModel:nil;
        
        cell.showimgBlock = ^(NSArray *imagArr, NSInteger imgIndex) {
            SJBrowserController *vc = [SJBrowserController new];
            vc.fetchPhotoResults = [NSMutableArray arrayWithArray:imagArr];
            vc.currentIndex = imgIndex;
            vc.noEdit = YES;
            vc.titleName = @"查看大图";
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController showViewController:vc
                                                       sender:nil];
            });
        };
       
        cell.memberBlock = ^(NSInteger activityId) {
            [self openTeamActin];
        };
        
        cell.showUserinfoBlock = ^(NSInteger userId) {
            [self userInfoAction:userId];
        };

        cell.reportBlock = ^(NSInteger reportId) {
            [self reportAction:self.activityModel];
        };
        [cell layoutIfNeeded];
        
        return cell;
    }else if(1 == indexPath.section){
        SJFootprintDetialsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SJFootprintDetialsCommentCell class])];
        if (!cell) {
            cell = [SJFootprintDetialsCommentCell xibCell:tableView];
        }
        
        JACommentModel *currentComment = self.commentListModel.commentsList[indexPath.row];
        cell.commentModel = currentComment;
        cell.showUserinfoBlock = ^(NSInteger userId) {
            [self userInfoAction:userId];
        };
        cell.photoBlock = ^(NSArray *imageAddressArr, NSInteger currentPhotoIndex) {
            LogD(@"要查看评论%@地址中第%ld张图片",imageAddressArr,currentPhotoIndex);
            SJBrowserController *vc = [SJBrowserController new];
            vc.fetchPhotoResults = [NSMutableArray arrayWithArray:imageAddressArr];
            vc.currentIndex = currentPhotoIndex;
            vc.noEdit = YES;
            vc.titleName = @"查看大图";
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController showViewController:vc
                                                       sender:nil];
            });
        };
        cell.moreBlock = ^(JACommentModel *commentModel, CGPoint tempPoint) {
            SJActivityReviewViewController *activityReviewVC = [[SJActivityReviewViewController alloc] init];
            activityReviewVC.titleName = [NSString stringWithFormat:@"回复@%@ ",commentModel.nickName];
            activityReviewVC.activityId = self.activityId;
            activityReviewVC.authorId = self.activityModel.detail.detailsUserId;
            activityReviewVC.returnCommentModel = commentModel;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController showViewController:activityReviewVC
                                                       sender:nil];
            });
        };
        
        cell.commentMoreBlock = ^(NSInteger commentId, NSInteger commentUserId) {
            SJChildCommentListViewController *childCommentListVC = [[SJChildCommentListViewController alloc] init];
            childCommentListVC.titleName = @"更多评论";
            childCommentListVC.commentId = commentId;
            childCommentListVC.activityId = self.activityId;
            childCommentListVC.commentUserId = commentUserId;
            childCommentListVC.authorId = self.activityModel.detail.detailsUserId;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController showViewController:childCommentListVC
                                                       sender:nil];
            });
        };
        
        return cell;
    }else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

#pragma mark - Tableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if( 1 == section){
        //评论条数
        return self.commentListModel?self.commentListModel.commentsList.count:0;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.activityModel) {
            //动态Cell高度
            NSString *briefStr = self.activityModel?self.activityModel.detail.detailsText:@"";
            CGSize concentSize = [briefStr xhl_stringSizeWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14]
                                                         maxWidth:(kScreenWidth - 32)];
            
            return (420 + concentSize.height);
        }
        return 520.0f;
    }else{
        if (self.commentListModel&&self.commentListModel.commentsList.count) {
            //动态Cell高度
            JACommentModel *currentComment = self.commentListModel.commentsList[indexPath.row];
            //评论内容高度
            NSString *commentStr = currentComment.commentText;
            CGSize concentSize = [commentStr xhl_stringSizeWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14]
                                                           maxWidth:(kScreenWidth - 32)];
            //图片集高度
            CGFloat imgBoxHeight = 0;
            NSArray *imgArr = currentComment.imagesAddressList;
            if (imgArr&&imgArr.count) {
                imgBoxHeight = (kScreenWidth-30-40)/(4+25.0/66);
                //box高度=img高度=（屏款-间隔）÷个数
            }
            
            //回复高度
            CGFloat returnHeight = 0;
            if (currentComment.sonComments > 0) {
                CGSize returnConcentSize = [currentComment.childComment.commentText xhl_stringSizeWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14]
                                                                                           maxWidth:(kScreenWidth - 62)];
                
                //图片集高度
                CGFloat returnImgHeight = 0;
                NSArray *returnImgArr = currentComment.childComment.imagesAddressList;
                if (returnImgArr&&returnImgArr.count) {
                    returnImgHeight = (kScreenWidth-30-40)/(4+25.0/66);
                    //box高度=img高度=（屏款-间隔）÷个数
                }
                returnHeight =  returnConcentSize.height + returnImgHeight + 50;
            }
            
            CGFloat commentHeight = 150 + concentSize.height + imgBoxHeight + returnHeight;
            
            return commentHeight;
        }
        return 214.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (1 == section) {
        SPLabel *lbl_com = [[SPLabel alloc] initWithFrame:CGRectMake(0, 8, kScreenWidth, 30)];
        lbl_com.backgroundColor = SP_WHITE_COLOR;
        [lbl_com setTextColor:SJ_TITLE_COLOR];
        [lbl_com setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:15]];
        if (self.commentListModel&&self.commentListModel.commentsList.count) {
            [lbl_com setText:@"  相关评论  "];
        }else{
            [lbl_com setText:@"  暂无评论  "];
        }
        return lbl_com;
    }else{
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01f)];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (1 == section) {
        SPButton *more = [[SPButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        if ([self.commentListModel.commentsList count] < 5) {
            [more sp_setTitle:@"没有更多了..." titleColor:HEXCOLOR(@"212121") fontSize:12];
        } else {
            [more sp_setTitle:@"查看全部评论" titleColor:HEXCOLOR(@"BDBDBD") fontSize:14];
            [more addTarget:self action:@selector(openMoreCommentAction) forControlEvents:UIControlEventTouchUpInside];
        }
        return more;
    }else{
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10.0f)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (1 == section) {
        return 50.0f;
    }else{
         return 0.01f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (1 == section) {
        return 50.0f;
    }else{
        return 10.0f;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JACommentModel *currentComment = self.commentListModel.commentsList[indexPath.row];
    [self showAlertSelect:currentComment];
}

#pragma mark - Lazy
#pragma mark - 分享
- (UIButton *)enjoyBtn{
    if (!_enjoyBtn) {
        _enjoyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _enjoyBtn.size = CGSizeMake(50, 30);
        [_enjoyBtn setImage:[UIImage imageNamed:@"detail_more"] forState:UIControlStateNormal];
        [_enjoyBtn addTarget:self action:@selector(enjoyBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_enjoyBtn setHidden:NO];
    }
    return _enjoyBtn;
}

- (void)enjoyBtnClick
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
    
    SJSheetView *sheetView = [SJSheetView sheetViewWithSheetModels:[WXApi isWXAppInstalled]?@[circleModel, friendModel, reportModel]:@[reportModel] ClickBlock:^(SJSheetViewActionType actionType) {
        switch (actionType) {
            case SJSheetViewActionTypeReport:
                {
                    LogD(@"点击了足迹详情里的举报...");
                    [self reportAction:self.activityModel];
                }
                break;
            case SJSheetViewActionTypeCircle:
            case SJSheetViewActionTypeFriend:
            {
                WXMediaMessage *message = [WXMediaMessage message];
                //分享活动
                [[NSUserDefaults standardUserDefaults] setValue:@"4" forKey:kSJSharePageKey];
                [[NSUserDefaults standardUserDefaults] setValue:@(self.activityId) forKey:kSJShareDetailsIdKey];
                message.title = self.activityModel.detail.detailsName;
                message.description = @"鸟斯基，玩到青春浪漫时~";
                UIImage *iconImage = [UIImage dealImage:[UIImage imageNamed:@"default_portrait"] scaleToSize:CGSizeMake(80, 80)];
                NSData *iconData = UIImagePNGRepresentation(iconImage);
                [message setThumbData:iconData];
                NSArray *imageArr = [self.activityModel.detail.imagesAddress componentsSeparatedByString:@","];
                NSString *firstUrl = imageArr.firstObject;
                if (!kStringIsEmpty(firstUrl)) {
                    
                    NSData *imageData = [NSData dataWithContentsOfURL:firstUrl.mj_url];
                    UIImage *realImage = [UIImage dealImage:[UIImage imageWithData:imageData] scaleToSize:CGSizeMake(80, 80)];
                    [message setThumbData:UIImagePNGRepresentation(realImage)];
                }
                WXWebpageObject *ext = [WXWebpageObject object];
                ext.webpageUrl = [NSString stringWithFormat:@"%@/activityDetail?id=%zd", JA_SERVER_WEB, self.activityModel.detail.Id];
                message.mediaObject = ext;
                SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
                req.bText = NO;
                req.message = message;
                req.scene = actionType==SJSheetViewActionTypeCircle?WXSceneTimeline:WXSceneSession;
                [WXApi sendReq:req];
            }
                break;
                
            default:
                break;
        }

    }];
    [sheetView show];
}

- (UIButton *)deleteBtn
{
    if (_deleteBtn == nil)
    {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.size = CGSizeMake(50, 30);
        [_deleteBtn setImage:[UIImage imageNamed:@"detail_delete"]
                        forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (void)deleteBtnClick
{
    [SVProgressHUD show];
    [JABbsPresenter postUpdateDetails:self.activityModel.detail.Id
                            runStatus:self.activityModel.detail.runStatus
                          detailsName:self.activityModel.detail.detailsName  detailsLabels:[self.activityModel.detailsLabelsList componentsJoinedByString:@","] detailText:nil imageAddresses:nil detailsUserId:self.activityModel.detail.detailsUserId detailsType:JADetailsTypeActivity isDeleted:YES Result:^(JAResponseModel * _Nullable model) {
                              
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

#pragma mark - 收藏
- (UIButton *)collectionBtn{
    if (!_collectionBtn) {
        _collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectionBtn.size = CGSizeMake(50, 30);
        [_collectionBtn setImage:[UIImage imageNamed:@"activity_collection_nor"]
                        forState:UIControlStateNormal];
        [_collectionBtn setImage:[UIImage imageNamed:@"activity_collection_sel"]
                        forState:UIControlStateSelected];
        [_collectionBtn addTarget:self
                           action:@selector(collectionBtnClick)
                 forControlEvents:UIControlEventTouchUpInside];
        [_collectionBtn setSelected:NO];
        [_collectionBtn setHidden:NO];
    }
    return _collectionBtn;
}

- (void)collectionBtnClick
{
    if (!SPLocalInfo.hasBeenLogin) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_Login_Request
                                                                object:nil];
        return;
    }
    
    if (self.collectionBtn.selected) {
        //取消收藏
        [SVProgressHUD show];
        [JABbsPresenter postUpdateCollection:self.activityModel.collectionId
                                    detailId:self.activityId
                                   isDeleted:YES
                                      Result:^(JAResponseModel * _Nullable model) {

            dispatch_async(dispatch_get_main_queue(), ^{
                if (model.success) {
                    self.collectionBtn.selected = NO;
                    [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];
                } else {
                    [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                }
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            });
        }];
    } else {
        [SVProgressHUD show];
        //收藏
        [JABbsPresenter postAddCollection:self.activityId
                          WithDetailsType:JADetailsTypeActivity
                                   Result:^(JAAddCollectionModel * _Nullable model) {
       dispatch_async(dispatch_get_main_queue(), ^{
           if (model.success) {
               self.activityModel.collectionId = model.collectionId;
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

#pragma mark - 写点评
- (UIButton *)btn_comment{
    if (!_btn_comment) {
        _btn_comment = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_comment setBackgroundImage:[UIImage imageNamed:@"default_btn_bg"]
                                forState:UIControlStateNormal];
        [_btn_comment setTitleColor:[UIColor colorWithRed:255/255.0 green:187.002/255.0 blue:4.00095/255.0 alpha:1]
                           forState:UIControlStateNormal];
        [_btn_comment setTitle:@"我要写点评" forState:UIControlStateNormal];
        [_btn_comment.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:15]];
        [_btn_comment setTitleEdgeInsets:UIEdgeInsetsMake(-8, 0, 8, 0)];
        [_btn_comment addTarget:self
                         action:@selector(actionComment)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_comment;
}

- (void)actionComment{
    SJActivityReviewViewController *activityReviewVC = [[SJActivityReviewViewController alloc] init];
    activityReviewVC.titleName = self.activityModel.detail.detailsName;
    activityReviewVC.activityId = self.activityId;
    activityReviewVC.authorId = self.activityModel.detail.detailsUserId;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController showViewController:activityReviewVC
                                               sender:nil];
    });
}

#pragma mark - 全部组员
- (void)openTeamActin{
    SJActivitiesTeamViewController *activityTeamVC = [[SJActivitiesTeamViewController alloc] init];
    activityTeamVC.titleName = @"全部组员";
    activityTeamVC.activityId = self.activityId;
    [self.navigationController pushViewController:activityTeamVC animated:YES];
}

#pragma mark - 个人详情
- (void)userInfoAction:(NSInteger)userid{
    SJOtherInfoPageController *anotherPageVC = [[SJOtherInfoPageController alloc] init];
    anotherPageVC.userId = userid;
    anotherPageVC.titleName = @"用户详情";
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController showViewController:anotherPageVC
                                               sender:nil];
    });
}

#pragma mark - 举报

//判断是否被举报过
- (void)judgeIsReported
{
    if ([SPLocalInfo hasBeenLogin]) {
        [JABbsPresenter postIsReported:self.activityId
                                Result:^(JAIsReportedModel * _Nullable model) {

            dispatch_async(dispatch_get_main_queue(), ^{
                self.isReported = model.reported;
            });
        }];
    }
}


/**
 举报动作

 @param activityModel 被举报的帖子
 */
- (void)reportAction:(JABBSModel *)activityModel{
    LogD(@"点击了足迹详情里的举报...");
    
    if (![self alertAction]) return ;
    if (self.isReported) {
        SJComplaintsSuccessfullyViewController *successVC = [[SJComplaintsSuccessfullyViewController alloc] init];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController showViewController:successVC sender:nil];
        });
    } else {
        if (self.activityModel.detail.detailsUserId == SPLocalInfo.userModel.Id) {
            
            [SVProgressHUD showInfoWithStatus:@"您不能举报自己的帖子"];
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            return;
        }
        //举报
        SJReportIllegalController *vc = [[SJReportIllegalController alloc] initWithNibName:@"SJReportIllegalController" bundle:nil];
        vc.delegate = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController showViewController:vc sender:nil];
            vc.activityModel = activityModel;
        });
    }
}

- (BOOL)alertAction
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
        SJAlertView *alertView = [SJAlertView alertWithTitle:@"是否登录" message:@"" type:SJAlertShowTypeNormal alertModels:@[alertModel,cancelModel]];
        [alertView showAlertView];
        return NO;
    }
    return YES;
}

- (void)didReportSuccessful{
    self.isReported = YES;
}

#pragma mark - Set Model
- (void)setActivityId:(NSInteger)activityId{
    _activityId = activityId;
    
    //生成分享链接
    NSString *postDetail = [NSString stringWithFormat:@"%@/activityDetail?id=%zd", JA_SERVER_WEB, activityId];
    self.detailStr = postDetail;
    [self refreashActivityDetails];
}

- (void)refreashActivityDetails{
    if (self.activityId) {
        //请求活动详情，并刷新UI
        [JABbsPresenter postQueryDetails:self.activityId
                                  Result:^(JABBSModel * _Nullable model) {
                                      if(model.success){
                                          self.activityModel = model;
                                      }else{
                                          NSString *msg = [NSString stringWithFormat:@"获取活动详情失败\n%@ ",model.responseStatus.message];
                                          [SVProgressHUD showErrorWithStatus:msg];
                                          [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default*1.5];
                                      }
                                  }];
        //请求相关评论集合，并刷新UI
        [JABbsPresenter postQueryCommentsList:self.activityId
                                     IsPaging:YES
                              WithCurrentPage:0
                                    WithLimit:5
                                     WithSort:@"desc"
                                       Result:^(JACommentListModel * _Nullable model) {
                                           if(model.success){
                                               self.commentListModel = model;
                                           }else{
                                               NSString *msg = [NSString stringWithFormat:@"获取评论列表失败\n%@ ",model.responseStatus.message];
                                               [SVProgressHUD showErrorWithStatus:msg];
                                               [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default*1.5];
                                           }
                                       }];
    }else{
        //请求失败
        LogD(@"无法刷新足迹详情失败");
    }
}

- (void)setActivityModel:(JABBSModel *)activityModel{
    _activityModel = activityModel;
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.listView beginUpdates];
//        [self.listView reloadSections:[NSIndexSet indexSetWithIndex:0]
//                      withRowAnimation:UITableViewRowAnimationFade];
        self.navigationItem.rightBarButtonItems = (activityModel.detail.detailsUserId == SPLocalInfo.userModel.Id)?@[self.enjoyItem, self.deleteItem]:@[self.enjoyItem, self.collectionItem];
        [self.listView reloadData];
//        [self.listView endUpdates];
        
        
        //是否已经收藏
        if(activityModel.collectionId){
            [self.collectionBtn setSelected:YES];
        }else{
            [self.collectionBtn setSelected:NO];
        }
    });
}

- (void)setCommentListModel:(JACommentListModel *)commentListModel{
    _commentListModel = commentListModel;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.listView reloadSections:[NSIndexSet indexSetWithIndex:1]
                     withRowAnimation:UITableViewRowAnimationNone];
    });
}
//全部评论
-(void)openMoreCommentAction{
    SJActivityCommentListViewController *activityCommentListVC = [[SJActivityCommentListViewController alloc] init];
    activityCommentListVC.titleName = @"全部评论";
    activityCommentListVC.activityId = self.activityId;
    activityCommentListVC.activityModel = self.activityModel;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController showViewController:activityCommentListVC
                                               sender:nil];
    });
}

-(void)showAlertSelect:(JACommentModel *)commentModel{
    if (![self alertAction]) return ;
     UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *replyAction = [UIAlertAction actionWithTitle:@"回复" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        SJActivityReviewViewController *activityReviewVC = [[SJActivityReviewViewController alloc] init];
        activityReviewVC.titleName = [NSString stringWithFormat:@"回复@%@ ",commentModel.nickName];
        activityReviewVC.activityId = self.activityId;
        activityReviewVC.authorId = self.activityModel.detail.detailsUserId;
        activityReviewVC.returnCommentModel = commentModel;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController showViewController:activityReviewVC
                                                   sender:nil];
        });
    }];
    [replyAction setValue:SJ_TITLE_COLOR forKey:@"titleTextColor"];
    [actionSheet addAction:replyAction];
    if (commentModel.commentUserId == SPLocalInfo.userModel.Id) {
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [JABbsPresenter postDeleteComment:commentModel.ID Result:^(JAResponseModel * _Nullable model) {
                if(model.success){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.activityModel.detail.comments -= 1;
                        [self.commentListModel.commentsList removeObject:commentModel];
                        [self.listView reloadData];
                    });
                }else{
                    NSString *msg = [NSString stringWithFormat:@"删除评论失败\n%@ ",model.responseStatus.message];
                    [SVProgressHUD showInfoWithStatus:msg];
                }
            }];
        }];
        [deleteAction setValue:SJ_TITLE_COLOR forKey:@"titleTextColor"];
        [actionSheet addAction:deleteAction];
    } else {
        UIAlertAction *reportAction = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SJReportController *reportVC = [[SJReportController alloc] init];
            reportVC.reportSuccess = ^{
                self.activityModel.detail.comments -= 1;
                [self.commentListModel.commentsList removeObject:commentModel];
                [self.listView reloadData];
            };
            reportVC.reportStyle = SJReportStyleReply;
            reportVC.commentModel = commentModel;
            [self.navigationController pushViewController:reportVC animated:YES];
        }];
        [reportAction setValue:SJ_TITLE_COLOR forKey:@"titleTextColor"];
        [actionSheet addAction:reportAction];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
         LogD(@"点击了取消");
    }];
    
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

@end
