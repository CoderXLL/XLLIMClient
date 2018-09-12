//
//  SJRouteDetailController.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/21.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJRouteDetailController.h"
#import "SJInterestListsController.h"
#import "SJOtherInfoPageController.h"
#import "SJSuffingView.h"
#import "SJAlertView.h"
#import "SJRouteHeaderView.h"
#import "SJRouteNavView.h"
#import "SJRouteFooterView.h"
#import "SJRouteTitleCell.h"
#import "SJRouteDateCell.h"
#import "SJJoinRouteCell.h"
#import "SJRouteIntroduceCell.h"
#import "SJRouteTravelCell.h"
#import "SJRouteArrangeCell.h"
#import "SJRouteCommentCell.h"
#import "SJRouteAnswerCell.h"
#import "SJRouteInterestCell.h"
#import "SJRouteDescHeadView.h"
#import "SJRouteBottomView.h"
#import "JAForumPresenter.h"
#import "JABBSModel.h"
#import "JANotificationConstant.h"
#import <WXApi.h>
#import "SJShareView.h"
#import "UIImage+ColorsImage.h"

#define SJIsUseDescHead(section) (section==3||section ==5|| section==6||section==7||section==8)
#define SJSuffingHeight (kScreenWidth*220.0/375.0)

@interface SJRouteDetailController () <SJRouteInterestCellDelegate>
{
    UIStatusBarStyle _currentBarStyle;
    BOOL _isWebLoaded;
}

@property (nonatomic, strong) JARouteDetailModel *detailModel;

@property (nonatomic, strong) SJRouteFooterView *routeFootView;
@property (nonatomic, strong) SJRouteBottomView *routeBottomView;
@property (nonatomic, weak) SJRouteHeaderView *routeHeadView;
@property (nonatomic, weak) SJRouteNavView *navView;

@property (nonatomic, strong) UIButton *interestBtn;

@end

@implementation SJRouteDetailController

#pragma mark - lazy loading
- (UIButton *)interestBtn
{
    if (_interestBtn == nil)
    {
        _interestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat bottomMargin = iPhoneX?78:44;
        _interestBtn.frame = CGRectMake(kScreenWidth-124, kScreenHeight-52-bottomMargin, 124, 52);
        [_interestBtn setImage:[UIImage imageNamed:@"route_interest_normal"] forState:UIControlStateNormal];
        [_interestBtn setImage:[UIImage imageNamed:@"route_interest_selected"] forState:UIControlStateSelected];
        [_interestBtn addTarget:self action:@selector(interestBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _interestBtn;
}

- (SJRouteFooterView *)routeFootView
{
    if (_routeFootView == nil)
    {
        _routeFootView = [SJRouteFooterView createCellWithXib];
        _routeFootView.size = CGSizeMake(kScreenWidth, 70);
        __weak typeof(_routeFootView)weakFootView = _routeFootView;
        __weak typeof(self)weakSelf = self;
        _routeFootView.heightBlock = ^(CGFloat totalHeight) {
            
            weakFootView.height = totalHeight;
            self->_isWebLoaded = YES;
            [weakSelf.listView reloadData];
            //        [self.listView beginUpdates];
            //        weakFooterView.height = totalHeight;
            //        [self.listView setTableFooterView:weakFooterView];
            //        [self.listView endUpdates];
        };
    }
    return _routeFootView;
}

- (SJRouteBottomView *)routeBottomView
{
    if (_routeBottomView == nil)
    {
        _routeBottomView = [SJRouteBottomView createCellWithXib];
        _routeBottomView.frame = CGRectMake(0, kScreenHeight-55, kScreenWidth, 55);
    }
    return _routeBottomView;
}

#pragma mark - event
- (void)interestBtnClick
{
    if (![self alertAction]) return;
    if (self.interestBtn.selected) {//取消收藏
        
        [SVProgressHUD show];
        [JAForumPresenter postDeleteDetailCollection:self.detailModel.routeVO.collectionId Result:^(JAResponseModel * _Nullable model) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if (model.success) {
                    self.interestBtn.selected = NO;
                    [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];
                   
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.Id != %d", SPLocalInfo.userModel.Id]; [self.detailModel.routeVO.collectionUserList filterUsingPredicate:predicate];
                    self.detailModel.routeVO.collection-=1;
                    [self.listView reloadData];
                } else {
                    [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                }
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            });
        }];
        
    } else {//收藏
        
        [SVProgressHUD show];
        [JAForumPresenter postAddDetailCollection:self.routeId Result:^(JAAddCollectionModel * _Nullable model) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (model.success) {
                    self.interestBtn.selected = YES;
                    [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
                    self.detailModel.routeVO.collectionId = model.collectionId;
                    JAUserAccountPosList *posModel = [[JAUserAccountPosList alloc] init];
                    posModel.sex = SPLocalInfo.userModel.sex.integerValue;
                    posModel.nickName = SPLocalInfo.userModel.nickName;
                    posModel.Id = SPLocalInfo.userModel.Id;
                    posModel.photoSrc = SPLocalInfo.userModel.avatarUrl;
                [self.detailModel.routeVO.collectionUserList addObject:posModel];
                    self.detailModel.routeVO.collection+=1;
                    [self.listView reloadData];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:_currentBarStyle animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     _currentBarStyle = [UIApplication sharedApplication].statusBarStyle;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewDidLoad {
    self.tableViewStyle = UITableViewStyleGrouped;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _currentBarStyle = UIStatusBarStyleLightContent;
    SJRouteHeaderView *routeHeadView = [SJRouteHeaderView createCellWithXib];
    routeHeadView.frame = CGRectMake(0, 0, kScreenWidth, SJSuffingHeight);
    [self.listView addSubview:routeHeadView];
    self.routeHeadView = routeHeadView;
    
    SJRouteNavView *navView = [[SJRouteNavView alloc] init];
    navView.clickBlock = ^(BOOL isPop) {
        
        if (isPop) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            
            if (![self alertAction]) return ;
            SJShareView *shareView = [SJShareView createCellWithXib];
            shareView.clickBlock = ^(SJShareViewActionType actionType) {
                
                if ([WXApi isWXAppInstalled]) {
                    
                    WXMediaMessage *message = [WXMediaMessage message];
                    message.title = [NSString stringWithFormat:@"%@分享了路线", [SPLocalInfo.userModel getShowNickName]];
                    message.description = self.detailModel.routeVO.title;
                    UIImage *iconImage = [UIImage dealImage:[UIImage imageNamed:@"default_bannner"] scaleToSize:CGSizeMake(80, 80)];
                    NSData *iconData = UIImagePNGRepresentation(iconImage);
                    [message setThumbData:iconData];
                    if (!kStringIsEmpty(self.detailModel.routeVO.pictureUrl.firstObject)) {
                        
                        NSData *imageData = [NSData dataWithContentsOfURL:self.detailModel.routeVO.pictureUrl.firstObject.mj_url];
                        UIImage *realImage = [UIImage dealImage:[UIImage imageWithData:imageData] scaleToSize:CGSizeMake(80, 80)];
                        [message setThumbData:UIImagePNGRepresentation(realImage)];
                    }
                    WXWebpageObject *ext = [WXWebpageObject object];
                    ext.webpageUrl = [NSString stringWithFormat:@"%@/activityDetail?id=%zd", JA_SERVER_WEB, self.routeId];
                    message.mediaObject = ext;
                    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
                    req.bText = NO;
                    req.message = message;
                    req.scene = actionType==SJShareViewActionTypeCircle?WXSceneTimeline:WXSceneSession;
                    [WXApi sendReq:req];
                } else {
                    [SVProgressHUD showInfoWithStatus:@"检查是否安装微信"];
                    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                }
            };
            [shareView show];
        }
    };
    [self.view addSubview:navView];
    self.navView = navView;
    [self.view addSubview:self.interestBtn];
    [self.view addSubview:self.routeBottomView];
    self.listView.contentInset = UIEdgeInsetsMake(routeHeadView.height, 0, iPhoneX?34+self.routeBottomView.height:self.routeBottomView.height, 0);
    
    [self requestDetailData];
}

- (void)requestDetailData
{
    [SVProgressHUD show];
    [JAForumPresenter postQueryRouteDetail:self.routeId Result:^(JARouteDetailModel * _Nullable model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (model.success) {
                
                [SVProgressHUD dismiss];
                self.detailModel = model;
                self.interestBtn.selected = model.routeVO.collectionId;
                self.routeFootView.htmlStr = model.routeVO.content;
                self.routeHeadView.itemModel = model.routeVO;
                [self.listView reloadData];
            } else {
                [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            }
        });
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if (kArrayIsEmpty(self.detailModel.routeVO.collectionUserList))
//    {
//        return 2;
//    }
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 5) {  //行程安排
        return 6;
    } else if (section == 8) { //评论
        return 3;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return [self.detailModel.routeVO.title boundingRectWithSize:CGSizeMake(kScreenWidth-2*kSJMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SPFont(14.0)} context:nil].size.height+100;
    } else if (indexPath.section == 1) {
        return 125.f;
    } else if (indexPath.section == 2) {
        return _isWebLoaded?204.f:0;
//        return 140.f;
    } else if (indexPath.section == 3) {//路线介绍
        return _isWebLoaded?134.f:0;
    } else if (indexPath.section == 4) {//行程路线图
        return _isWebLoaded?384.f:0;
    } else if (indexPath.section == 5) {//行程安排
        return _isWebLoaded?80.f:0;
    } else if (indexPath.section == 8) {//评论
        return _isWebLoaded?134.f:0;
    } else if (indexPath.section == 9) {//问答
        return _isWebLoaded?175.f:0;
    }
    return _isWebLoaded?134.0:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 4) {
        return self.routeFootView.height;
    } else if (SJIsUseDescHead(section)) {
        return 55.f;
    }
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 4) {
        return self.routeFootView;
    } else if (SJIsUseDescHead(section)) {
        
        SJRouteDescHeadView *headView = [[SJRouteDescHeadView alloc] init];
        headView.descType = section;
        return headView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    footerView.backgroundColor = JMY_BG_COLOR;
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        SJRouteTitleCell *cell = [SJRouteTitleCell xibCell:tableView];
        cell.itemModel = self.detailModel.routeVO;
        return cell;
    } else if (indexPath.section == 1) {
        SJRouteDateCell *cell = [SJRouteDateCell xibCell:tableView];
        return cell;
    } else if (indexPath.section == 2) {
        
        SJJoinRouteCell *cell = [SJJoinRouteCell xibCell:tableView];
        return cell;
//        SJRouteInterestCell *cell = [SJRouteInterestCell cell:tableView];
//        cell.itemModel = self.detailModel.routeVO;
//        cell.delegate = self;
//        return cell;
    } else if (indexPath.section == 3) {
        SJRouteIntroduceCell *cell = [SJRouteIntroduceCell xibCell:tableView];
        return cell;
    } else if (indexPath.section == 4) {
        SJRouteTravelCell *cell = [SJRouteTravelCell xibCell:tableView];
        return cell;
    } else if (indexPath.section == 5) {
        SJRouteArrangeCell *cell = [SJRouteArrangeCell xibCell:tableView];
        return cell;
    } else if (indexPath.section == 6) {
        
        SPBaseCell *cell = [SPBaseCell cell:tableView];
        cell.textLabel.text = @"鸟斯基SPECIAL";
        return cell;
    } else if (indexPath.section == 7) {
        
        SPBaseCell *cell = [SPBaseCell cell:tableView];
        cell.textLabel.text = @"其他";
        return cell;
    } else if (indexPath.section == 8) {
        SJRouteCommentCell *cell = [SJRouteCommentCell xibCell:tableView];
        return cell;
    }
    SJRouteAnswerCell *cell = [SJRouteAnswerCell xibCell:tableView];
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![scrollView isEqual:self.listView]) return;
    LogD(@"~~~%lf---", scrollView.contentOffset.y)
    LogD(@"***%lf***", -(SJSuffingHeight))
    //往下
    if (scrollView.contentOffset.y < -(SJSuffingHeight))
    {
        LogD(@"固定")
        self.routeHeadView.y = scrollView.contentOffset.y;
        self.routeHeadView.height = -scrollView.contentOffset.y;
    } else { //往上
        
        LogD(@"往上")
        self.routeHeadView.y = -(SJSuffingHeight);
    }
    CGFloat bgAlpha = (scrollView.contentOffset.y+SJSuffingHeight) / (SJSuffingHeight-kNavBarHeight);
    self.navView.bgAlpha = bgAlpha;
    //防止viewwilldis已调用，还会执行此方法
    if (self.navigationController.navigationBarHidden) {
        [[UIApplication sharedApplication] setStatusBarStyle:(bgAlpha <= 0.4)?UIStatusBarStyleLightContent:UIStatusBarStyleDefault animated:YES];
    }
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_routeScrollUnEnable object:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_routeScrollEnable object:nil];
}

#pragma mark - SJRouteInterestCellDelegate
- (void)routeInterestCell:(SJRouteInterestCell *)cell didClickAccount:(JAUserAccountPosList *)posModel
{
    if (!posModel) {
        SJInterestListsController *listVC = [[SJInterestListsController alloc] init];
        listVC.routeId = self.routeId;
        [self.navigationController pushViewController:listVC animated:YES];
    } else {
        
        SJOtherInfoPageController *otherVC = [[SJOtherInfoPageController alloc] init];
        otherVC.userId = posModel.Id;
        otherVC.titleName = [NSString stringWithFormat:@"%@的个人主页", posModel.nickName];
        [self.navigationController pushViewController:otherVC animated:YES];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.navView.frame = CGRectMake(0, 0, self.view.width, kNavBarHeight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
