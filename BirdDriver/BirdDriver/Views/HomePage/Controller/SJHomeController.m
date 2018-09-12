//
//  SJHomeController.m
//  BirdDriver
//
//  Created by Soul on 2018/5/16.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "SJHomeController.h"
#import "SJDetailController.h"
#import "SJOtherInfoPageController.h"
#import "SJHomeSectionHeader.h"
#import "JABannerPresenter.h"
#import "JABbsPresenter.h"
#import "JAUserPresenter.h"
#import "JAUserListModel.h"
#import "JAMessagePresenter.h"
#import "SJMessageListViewController.h"
#import "SJLoginController.h"
#import "SJFootprintDetailsController.h"
#import "SJNoteDetailController.h"
#import "SJNoDataFootView.h"

#import "SJBannerView.h"
#import "SJHomeRecViewRow.h"
#import "SJHomeFinancialRow.h"
#import "SJHomeHotUserRow.h"
#import "SJSelectLabelRow.h"
#import "UIScrollView+SJFooter.h"
#import <WXApi.h>

@interface SJHomeController ()<UITableViewDataSource,UITableViewDelegate, SJSelectLabelRowDelegate, SJHomeHotUserRowDelegate, SJHomeFinancialRowDelegate>
@property (weak, nonatomic) IBOutlet UITableView *listView;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconTopCons;

@property (nonatomic, copy) void (^refreshBlock)(BOOL isRequestResult);

//轮播
@property (nonatomic, strong) JABannerData *bannerModel;
//副轮播
@property (nonatomic, strong) JABannerData *subBannerModel;
//推荐模型数组
@property (nonatomic, strong) NSArray <JARecommendDetailSpolistModel *>*recommendDetailsPOList;
//热门用户模型
@property (nonatomic, strong) JAUserListModel *hotUserList;
@property (nonatomic, strong) SJBannerView *bannerView;

@property (nonatomic, strong) SJNoDataFootView *noNetView;

@end

@implementation SJHomeController

#pragma mark - lazy loading
- (SJNoDataFootView *)noNetView
{
    if (_noNetView == nil)
    {
        _noNetView = [SJNoDataFootView createCellWithXib];
        _noNetView.exceptionStyle = SJExceptionStyleNoNet;
        _noNetView.backgroundColor = [UIColor whiteColor];
        __weak SJNoDataFootView *weakNoNetView = _noNetView;
        _noNetView.buttonView.customButtonClickBlock = ^(UIButton *button) {
            
            __block NSInteger index = 0;
            __block NSInteger isAllSuccess = YES;
            [SVProgressHUD show];
            self.refreshBlock = ^(BOOL isRequestResult){
                index++;
                if (!isRequestResult && isAllSuccess) {
                    isAllSuccess = NO;
                }
                if (index == 4) {
                    
                    //确保所有接口都调用成功，再移除异常页面
                    if (isAllSuccess) {
                        if (weakNoNetView.superview.superview) {
                            [weakNoNetView removeFromSuperview];
                        }
                    }
                    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                }
            };
            [self getBannerList];
            [self getSubBannerList];
            [self getHomeRecActivityData];
            [self getHotUserList:1];
        };
    }
    return _noNetView;
}

- (SJBannerView *)bannerView {
    if (_bannerView == nil) {
        _bannerView = [[SJBannerView alloc] init];
        _bannerView.size = CGSizeMake(kScreenWidth, 140.0);
    }
    return _bannerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.iconTopCons.constant = iPhoneX?40:20;
    self.view.backgroundColor = SP_WHITE_COLOR;
    [self.messageBtn addTarget:self action:@selector(openMessageVC) forControlEvents:UIControlEventTouchUpInside];
    self.listView.backgroundColor = SP_CLEAR_COLOR;
//    self.listView.bounces = NO;
    self.listView.showsVerticalScrollIndicator = NO;
    self.listView.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        self.listView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.listView.estimatedSectionHeaderHeight = 0;
    self.listView.estimatedSectionFooterHeight = 0;
    self.listView.estimatedRowHeight = 0;
//    self.listView.contentInset = UIEdgeInsetsMake(0, 0, -20, 0);
    [self addRefreshView];
    //获取轮播数据
    [self getBannerList];
    //获取副轮播数据
    [self getSubBannerList];
    //查询首页的标签+对应的话题
    [self getHomeRecActivityData];
    //获取热门用户
    [self getHotUserList:1];
}

- (void)addRefreshView
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        __block NSInteger index = 0;
        __weak typeof(self)weakSelf = self;
        [SVProgressHUD show];
        self.refreshBlock = ^(BOOL isRequestSuccess){
            index++;
            if (index == 4) {
                [weakSelf.listView.mj_header endRefreshing];
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            }
        };
        [self getBannerList];
        [self getSubBannerList];
        [self getHomeRecActivityData];
        [self getHotUserList:1];
    }];
    self.listView.mj_header = header;
    
    __weak typeof(self)weakSelf = self;
    [self.listView addCustomeFooterViewWithCallback:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [weakSelf.tabBarController setSelectedIndex:1];
            [self.listView footerEndRefreshing];
        });
    }];
}

- (void)getSubBannerList
{
    [JABannerPresenter postQueryBanner:JABannerPlatformSub
                                Result:^(JABannerListModel * _Nullable model) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            if (model.success) {
                self.subBannerModel = model.data;
                [self.listView reloadData];
            } else {
                if (!self.noNetView.superview) {
                    [self.view insertSubview:self.noNetView aboveSubview:self.listView];
                }
            }
            if (self.refreshBlock) {
                self.refreshBlock(model.success);
            }
        });
    }];
}

- (void)getMessageNotReadCount{
    [JAMessagePresenter postNotReadMessageCount:MessageTypeAll
                                         Result:^(JAResponseModel * _Nullable model) {
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 if (model.success && model.notReadMsgCount > 0) {
                                                     [self.messageBtn setImage:[UIImage imageNamed:@"nav_message_icon_has"] forState:UIControlStateNormal];
                                                 } else {
                                                     [self.messageBtn setImage:[UIImage imageNamed:@"nav_message_icon_new"] forState:UIControlStateNormal];
                                                 }
                                             });
    }];
}

- (void)getHotUserList:(NSInteger)page {
    [JAUserPresenter postQueryHotUserList:1
                                 IsPaging:YES
                          WithCurrentPage:page
                                WithLimit:3
                                   Result:^(JAUserListModel * _Nullable model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (model.success) {
                self.hotUserList = model;
                [self.listView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationFade];
//                [self.listView reloadData];
            } else {
                if (!self.noNetView.superview) {
                    [self.view insertSubview:self.noNetView aboveSubview:self.listView];
                }
            }
            if (self.refreshBlock) {
                self.refreshBlock(model.success);
            }
        });
    }];
}

- (void)getHomeRecActivityData {
    [JABbsPresenter postQueryHomeRecActivity:5
                          withLabelActsCount:5
                                      Result:^(JAHomeRecGroupModel * _Nullable model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (model.success){
                self.recommendDetailsPOList = model.recommendDetailsPOList;
                [self.listView reloadData];
            } else {
                if (!self.noNetView.superview) {
                    [self.view insertSubview:self.noNetView aboveSubview:self.listView];
                }
            }
            if (self.refreshBlock) {
                self.refreshBlock(model.success);
            }
        });
    }];
}

- (void)getBannerList {
    [JABannerPresenter postQueryBanner:JABannerPlatformAPP Result:^(JABannerListModel * _Nullable model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (model.success){
                self.bannerModel = model.data;
                [self.listView reloadData];
            } else {
                if (!self.noNetView.superview) {
                    [self.view insertSubview:self.noNetView aboveSubview:self.listView];
                }
            }
            if (self.refreshBlock) {
                self.refreshBlock(model.success);
            }
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES
                                             animated:NO];
    [self.listView setScrollsToTop:YES];
    [self getMessageNotReadCount];
}


#pragma mark - TableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            SJHomeSectionHeader *header = [[SJHomeSectionHeader alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
            header.backgroundColor = [UIColor redColor];
            [header factorySetViewWithTitle:@"鸟叔推荐"
                               WithBtnTitle:nil
                               WithTapBlock:nil];
            return header;
            break;
        }
        case 1:{
            SJHomeSectionHeader *header = [[SJHomeSectionHeader alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
            [header factorySetViewWithTitle:@"旅游财经"
                               WithBtnTitle:nil
                               WithTapBlock:nil];
            return header;
            break;
        }
        case 2:{
            SJHomeSectionHeader *header = [[SJHomeSectionHeader alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
            [header factorySetViewWithTitle:@"精选标签"
                               WithBtnTitle:nil
                               WithTapBlock:nil];
            return header;
            break;
        }
        case 3:{
            __weak SJHomeController *weakSelf = self;
            SJHomeSectionHeader *header = [[SJHomeSectionHeader alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
            [header factorySetViewWithTitle:@"热门用户"
                               WithBtnTitle:@"换一换"
                               WithTapBlock:nil];
            header.block = ^{
                //获取热门用户
                if (!weakSelf.hotUserList.data.hasNextPage) {
                    [weakSelf getHotUserList:1];
                } else {
                    [weakSelf getHotUserList:weakSelf.hotUserList.data.nextPage];
                }
                
                //埋点热门用户
                NSString *nsjId = @"30010500";
                NSString *nsjDes = @"点击首页热门用户换一换";
                [SJStatisticEventTool umengEvent:Nsj_Event_Home
                                           NsjId:nsjId
                                         NsjName:nsjDes];
            };
            return header;
            break;
        }
        default:
            break;
    }
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   //鸟叔推荐
    if (indexPath.section == 0) {
        SJHomeRecViewRow *recCell = [SJHomeRecViewRow xibCell:tableView];
        recCell.detailBlock = ^(JABannerModel *bannerModel) {
            SJDetailController *detailVC = [[SJDetailController alloc] init];
            if ([[bannerModel.jumpUrl substringToIndex:4].uppercaseString isEqualToString:@"HTTP"]) {
                detailVC.detailStr = bannerModel.jumpUrl;
            } else {
                detailVC.detailStr = [NSString stringWithFormat:@"%@%@?timestrump=%@", JA_SERVER_WEB, bannerModel.jumpUrl, @([[NSDate date] timeIntervalSinceReferenceDate])];
            }
            detailVC.canClose = (bannerModel.jumpPage == 1);
            dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController showViewController:detailVC
                                               sender:nil];
                
                //埋点主Banner
                NSString *nsjId = [NSString stringWithFormat:@"300101%02d",(int)indexPath.row+1];
                NSString *nsjDes = [NSString stringWithFormat:@"点击主Banner%@",bannerModel.bannerName];
                [SJStatisticEventTool umengEvent:Nsj_Event_Home
                                           NsjId:nsjId
                                         NsjName:nsjDes];
                
    });
        };
        recCell.bannerList = self.bannerModel.list;
        return recCell;
    }
    //旅行财经
    if (indexPath.section == 1) {
        SJHomeFinancialRow *finanCell = [SJHomeFinancialRow xibCell:tableView];
        finanCell.delegate = self;
        finanCell.subBannerModel = self.subBannerModel;
            
        return finanCell;
    }
    //精选标签
    if (indexPath.section == 2) {
        SJSelectLabelRow *finanCell = [SJSelectLabelRow xibCell:tableView];
        finanCell.delegate = self;
        finanCell.recommendDetailsPOList = self.recommendDetailsPOList;
        finanCell.backgroundColor = SP_CLEAR_COLOR;
        return finanCell;
    }
    //热门用户
    if (indexPath.section == 3) {
        SJHomeHotUserRow *userCell = [SJHomeHotUserRow xibCell:tableView];
        userCell.delegate = self;
        userCell.hotUserList = self.hotUserList.data.list;
        userCell.backgroundColor = SP_CLEAR_COLOR;
        return userCell;
    }
    
    NSString *cellReuseIdentifier = NSStringFromClass([self class]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellReuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        CGFloat width = kScreenWidth *260.0f/375;
        return width*0.5+16+15; //185.f
    }else if (indexPath.section ==1){
        return 70.0f; //60.f
    }else if (indexPath.section ==2){
        return 225.0f; //235.0f
    }else if (indexPath.section ==3){
        return 130.0f ;
    }
    return 44.0f;
}

#pragma mark - SJHomeFinancialRowDelegate
- (void)didSelectedWithBannerModel:(JABannerModel *)bannerModel
{
    SJDetailController *detailVC = [[SJDetailController alloc] init];
    detailVC.titleName = @"详情";
//    NSString *detailStr = [NSString stringWithFormat:@"%@/tourism", JA_SERVER_WEB];
    if ([[bannerModel.jumpUrl substringToIndex:4].uppercaseString isEqualToString:@"HTTP"]) {
        detailVC.detailStr = bannerModel.jumpUrl;
    } else {
        detailVC.detailStr = [NSString stringWithFormat:@"%@%@", JA_SERVER_WEB, bannerModel.jumpUrl];
    }
    detailVC.canClose = (bannerModel.jumpPage == 1);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController showViewController:detailVC
                                               sender:nil];
    });
}

#pragma mark - SJSelectLabelRowDelegate
// 通过首页精选标签进入帖子详情
- (void)didSelectedRowWithActivityModel:(JAActivityModel *)activityModel {
    
    SJNoteDetailController *detailVC = [[SJNoteDetailController alloc] init];
    detailVC.noteId = activityModel.ID;
    [self.navigationController pushViewController:detailVC animated:YES];
//    SJFootprintDetailsController *detailVC = [[SJFootprintDetailsController alloc] init];
//    detailVC.titleName = activityModel.detailsName;
//    detailVC.activityId = activityModel.ID;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationController showViewController:detailVC
//                                               sender:nil];
//    });
}

#pragma mark - SJHomeHotUserRowDelegate
- (void)didSelectedAccountModel:(id)userModel
{
    JAUserAccount *userAccount = (JAUserAccount *)userModel;
    SJOtherInfoPageController *anotherVC = [[SJOtherInfoPageController alloc] init];
    anotherVC.userId = userAccount.Id;
    anotherVC.titleName = [NSString stringWithFormat:@"%@的个人主页", [userAccount getShowNickName]];
    [self.navigationController pushViewController:anotherVC animated:YES];
}

#pragma mark - TableView Delegate

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - 消息中心
-(void)openMessageVC{
    
    if (!SPLocalInfo.hasBeenLogin) {
        SJAlertModel *alertModel = [[SJAlertModel alloc] initWithTitle:@"确认" handler:^(id content) {
            [self loginAction];
        }];
        SJAlertModel *cancelModel = [[SJAlertModel alloc] initWithTitle:@"取消" handler:^(id content) {
        }];
        SJAlertView *alertView = [SJAlertView alertWithTitle:@"是否登录" message:@"" type:SJAlertShowTypeNormal alertModels:@[alertModel,cancelModel]];
        [alertView showAlertView];
        return;
    }
    SJMessageListViewController *messageVC = [[SJMessageListViewController alloc] init];
    messageVC.hidesBottomBarWhenPushed = YES;
    messageVC.titleName = @"消息";
    [self.navigationController pushViewController:messageVC animated:YES];
}

#pragma mark - 登录
- (void)loginAction{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_Login_Request
                                                        object:nil];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.noNetView.frame = CGRectMake(0, kNavBarHeight, self.view.width, self.view.height-kNavBarHeight);
}

@end
