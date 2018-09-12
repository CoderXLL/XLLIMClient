//
//  SJMineController.m
//  BirdDriver
//
//  Created by Soul on 2018/5/16.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//
// 个人用户信息

#import "SJMineController.h"
#import "SJLoginController.h"
#import "SJDetailController.h"
#import "SJOtherInfoPageController.h"
#import "SJMineTableViewCell.h"
#import "SJMineCell.h"
#import "SJMineHeaderView.h"
#import "SJMineNavView.h"
#import "SJSettingViewController.h"
#import "SJConcernViewController.h"
#import "SJFansViewController.h"
#import "SJMyCollectionViewController.h"
#import "SJNoteController.h"
#import "SJNoteDetailController.h"
#import "SJFootprintDetailsController.h"
#import "SJAccountSettingsViewController.h"
#import "SJMyPictureController.h"
#import "SJCreateGroupViewController.h"
#import "SJMessageListViewController.h"
#import "SJNoviceGuideStep3Controller.h"
 
#import "JAUserPresenter.h"
#import "JABbsPresenter.h"
#import <WXApi.h>
#import <JPUSHService.h>
#import "UIImage+ColorsImage.h"
#import "SJBrowserController.h"
#import "SJShareView.h"
#import "JAMessagePresenter.h"

@interface SJMineController ()<UITableViewDelegate, UITableViewDataSource, SJMineHeaderViewDelegate, SJMineNavViewDelegate>

@property(nonatomic, strong)UITableView *mainTableView;
@property(nonatomic, strong)SJMineHeaderView *headerView;
@property(nonatomic, strong)SJMineNavView *userNavView;
@property(nonatomic, strong)SJNoDataFootView *footView;
@property(nonatomic, strong)UIButton *taskBtn;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, strong)NSMutableArray *listModelArray;

@end

@implementation SJMineController

#pragma mark - lazy loading
- (NSMutableArray *)listModelArray
{
    if (_listModelArray == nil)
    {
        _listModelArray = [NSMutableArray array];
        SJCellModel *noteModel = [[SJCellModel alloc] init];
        noteModel.title = @"帖子";
        noteModel.iconName = @"mine_icon_note";
        SJCellModel *pictureModel = [[SJCellModel alloc] init];
        pictureModel.title = @"图册";
        pictureModel.iconName = @"mine_icon_picture";
        SJCellModel *collectionModel = [[SJCellModel alloc] init];
        collectionModel.title = @"收藏";
        collectionModel.iconName = @"mine_icon_collection";
        SJCellModel *taskModel = [[SJCellModel alloc] init];
        taskModel.title = @"任务";
        taskModel.iconName = @"mine_icon_task";
        SJCellModel *timeLineModel = [[SJCellModel alloc] init];
        timeLineModel.title = @"时光轴";
        timeLineModel.iconName = @"mine_icon_timeLine";
        SJCellModel *setModel = [[SJCellModel alloc] init];
        setModel.title = @"设置";
        setModel.iconName = @"mine_icon_set";
        [_listModelArray addObjectsFromArray:@[noteModel, pictureModel, collectionModel, taskModel, timeLineModel, setModel]];
    }
    return _listModelArray;
}

- (SJMineNavView *)userNavView
{
    if (_userNavView == nil)
    {
        _userNavView = [[SJMineNavView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavBarHeight)];
        _userNavView.delegate = self;
    }
    return _userNavView;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self beginRefreshing];
}

- (instancetype)init {
    if (self = [super init]) {
        [self addNotifications];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSubViews];
    self.mainTableView.separatorColor = [UIColor colorWithHexString:@"EEEEEE" alpha:1];
    self.page = 1;
}

-(void)setUserInfo{
    if (SPLocalInfo.userModel && SPLocalInfo.hasBeenLogin) {//更新用户信息
        self.headerView.fansLabel.text = [NSString stringWithFormat:@"%ld", SPLocalInfo.userModel.fansNumber];
        self.headerView.concernLabel.text = [NSString stringWithFormat:@"%ld", SPLocalInfo.userModel.attentionNumber];
        self.headerView.groupLabel.text = [NSString stringWithFormat:@"%ld", SPLocalInfo.userModel.activityNum];
        self.headerView.tagListView.tagList = [SPLocalInfo.userModel.hobbies componentsSeparatedByString:@","];
        [self.headerView.portraitImageView sd_setImageWithURL:[NSURL URLWithString:SPLocalInfo.userModel.avatarUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_portrait"]];
        //昵称
        self.headerView.nameLabel.text = [SPLocalInfo.userModel getShowNickName];
        //个人签名
        if (SPLocalInfo.userModel.personalSign.length > 0) {
            self.headerView.describeLabel.text = SPLocalInfo.userModel.personalSign;
        } else {
            self.headerView.describeLabel.text = @"太懒了，未添加个人签名";
        }
//        //地址
//        if (SPLocalInfo.userModel.address.length > 0) {
//            [self.headerView.genderAddressBtn setTitle:SPLocalInfo.userModel.address forState:UIControlStateNormal];
//        } else {
//            [self.headerView.genderAddressBtn setTitle:@"未知" forState:UIControlStateNormal];
//        }
        //性别0是女，1是男
        if ([SPLocalInfo.userModel.sex isEqualToString:@"1"]) {//男
            self.headerView.portraitImageView.layer.borderColor = [UIColor colorWithHexString:@"6EEBEE" alpha:1].CGColor;
            self.headerView.portraitImageView.layer.borderWidth = 2.0;
//            [self.headerView.genderAddressBtn setImage:[UIImage imageNamed:@"mine_man"] forState:UIControlStateNormal];
        } else {//女
            self.headerView.portraitImageView.layer.borderColor = [UIColor colorWithHexString:@"F9739B" alpha:1].CGColor;
            self.headerView.portraitImageView.layer.borderWidth = 2.0;
//            [self.headerView.genderAddressBtn setImage:[UIImage imageNamed:@"mine_woman"] forState:UIControlStateNormal];
        }
    } else {
        self.headerView.fansLabel.text = @"0";
        self.headerView.concernLabel.text = @"0";
        self.headerView.groupLabel.text = @"0";
        self.headerView.tagListView.tagList = @[@"个人标签"];
        [self.headerView.portraitImageView setImage:[UIImage imageNamed:@"default_portrait"] forState:UIControlStateNormal];
        self.headerView.nameLabel.text = @"鸟斯基";
        self.headerView.describeLabel.text = @"玩到青春浪漫时";
        [self.headerView.genderAddressBtn setTitle:@"" forState:UIControlStateNormal];
        [self.headerView.genderAddressBtn setImage:[UIImage new] forState:UIControlStateNormal];
    }
}

- (void)beginRefreshing {
    self.page = 1;
    
    if (SPLocalInfo.hasBeenLogin) {
        self.mainTableView.tableFooterView = nil;
    }
    [self.mainTableView reloadData];
    dispatch_group_t group = dispatch_group_create();
    [self getUserInfoWithGroup:group];
    [self.headerView getMessageNotReadCountWithGroup:group];
    [self getTaskCountWithGroup:group];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.mainTableView.mj_header endRefreshing];
    });
}

#pragma mark - 获取任务数
-(void)getTaskCountWithGroup:(dispatch_group_t)group{
    
    dispatch_group_enter(group);
    [JAMessagePresenter postHasRewardingResult:^(JATaskModel * _Nullable model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            dispatch_group_leave(group);
            if (model.success && model.data > 0) {
                [self.taskBtn setImage:[UIImage imageNamed:@"mine_task_has"] forState:UIControlStateNormal];
            } else {
                [self.taskBtn setImage:[UIImage imageNamed:@"mine_task"] forState:UIControlStateNormal];
            }
        });
    }];
}

-(void)getUserInfoWithGroup:(dispatch_group_t)group{
    
    dispatch_group_enter(group);
    [JAUserPresenter postQueryUserInfo:^(JAUserModel * _Nullable model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_group_leave(group);
            [self setUserInfo];
        });
    }];
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:kNotify_loginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccess) name:kNotify_logoutSuccess object:nil];
}

- (void)setupSubViews {
    
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.userNavView];
    if (!SPLocalInfo.hasBeenLogin) {
        self.mainTableView.tableFooterView = self.footView;
    }
}

- (BOOL)testBtnClick
{
    if ([self alertAction]) {
        
        if (![WXApi isWXAppInstalled]) return NO;
        WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
        launchMiniProgramReq.userName = @"gh_1a23073bf4ae";
        /**
         NSDictionary *dict = @{
         @"commodityCount":@(1),
         @"commodityId":@(100004),
         @"commodityName":@"鲜花",
         @"commodityImage":@"https://m.niaosiji.com/x/commodity/gif8.png",
         @"nsjUserId":@(10000035),
         @"price":@(41800),
         @"vote":@(5200),
         @"authkey":SPUserDefault.kLastLoginAuthKey
         };
         NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
         NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
         NSString *path = [NSString stringWithFormat:@"pages/pay/index?params=%@", json];
         */
        NSString *newImageUrl = [@"https://m.niaosiji.com/x/commodity/gif8.png" stringByReplacingOccurrencesOfString:@"/" withString:@"\\/"];
        NSString *path = [NSString stringWithFormat:@"pages/pay/index?commodityCount=1&commodityId=100004&commodityName=鲜花&commodityImage=%@&nsjUserId=10000035&price=41800&vote=5200&authkey=%@", newImageUrl, SPUserDefault.kLastLoginAuthKey];
        launchMiniProgramReq.path = path;
        launchMiniProgramReq.miniProgramType = WXMiniProgramTypeTest;
        return  [WXApi sendReq:launchMiniProgramReq];
    }
    return NO;
}

#pragma mark - notification
- (void)loginSuccess {
    if ([self isViewLoaded]) {
        [self beginRefreshing];
    }
    LogD(@"%ld", (long)SPLocalInfo.userModel.Id)
    //设置别名
    [JPUSHService setAlias:[NSString stringWithFormat:@"%ld", (long)SPLocalInfo.userModel.Id] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
        if (iResCode == 0) {
            LogD(@"添加别名成功")
        }
    } seq:1];
}

- (void)logoutSuccess {
    
    //重新赋值
    SPLocalInfo.userModel = [JAUserAccount model];
    if ([self isViewLoaded]) {
        
        self.mainTableView.tableFooterView = self.footView;
        self.page = 1;
        [self.mainTableView reloadData];
    }
    //删除别名
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        if (iResCode == 0) {
            LogD(@"删除别名成功")
        }
    } seq:1];
}

#pragma mark - 设置
- (void)setAction{
    [SJStatisticEventTool umengEvent:Nsj_Event_Mine
                               NsjId:@"20010300"
                             NsjName:@"点击我的设置"];
    
    if ([self alertAction]) {
        SJSettingViewController *settingVC = [[SJSettingViewController alloc] init];
        settingVC.hidesBottomBarWhenPushed = YES;
        settingVC.titleName = @"设置";
        [self.navigationController pushViewController:settingVC animated:YES];
    }
}


#pragma mark - 任务
- (void)taskAction{
    LogD(@"点击了任务...");
    [SJStatisticEventTool umengEvent:Nsj_Event_Mine
                               NsjId:@"20010100"
                             NsjName:@"点击我的任务"];
    
    if ([self alertAction]) {
        SJDetailController *detailVC = [[SJDetailController alloc] init];
        detailVC.titleName = @"任务";
        NSString *postDetail = [NSString stringWithFormat:@"%@/task", JA_SERVER_WEB];
        detailVC.detailStr = postDetail;
        dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController showViewController:detailVC
                                               sender:nil];
    });
    }
}

#pragma mark - 分享
- (void)shareAction{
    LogD(@"点击了我的分享...");
    [SJStatisticEventTool umengEvent:Nsj_Event_Mine
                               NsjId:@"20010200"
                             NsjName:@"点击我的分享"];
    
    if ([self alertAction]) {
        
        SJShareView *shareView = [SJShareView createCellWithXib];
        shareView.clickBlock = ^(SJShareViewActionType actionType) {
           
            if ([WXApi isWXAppInstalled]) {
                
                [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:kSJSharePageKey];
                WXMediaMessage *message = [WXMediaMessage message];
                message.title = [NSString stringWithFormat:@"%@的鸟斯基个人主页", [SPLocalInfo.userModel getShowNickName]];
                message.description = kStringIsEmpty(SPLocalInfo.userModel.personalSign)?@"傲娇的我，等你来撩~":SPLocalInfo.userModel.personalSign;
                
                UIImage *iconImage = [UIImage dealImage:[UIImage imageNamed:@"default_portrait"] scaleToSize:CGSizeMake(80, 80)];
                NSData *iconData = UIImagePNGRepresentation(iconImage);
                [message setThumbData:iconData];
                if (!kStringIsEmpty(SPLocalInfo.userModel.avatarUrl)) {
                    
                    //                NSData *imageData = [NSData dataWithContentsOfURL:SPLocalInfo.userModel.avatarUrl.mj_url];
                    UIImage *realImage = [UIImage dealImage:self.headerView.portraitImageView.imageView.image scaleToSize:CGSizeMake(80, 80)];
                    [message setThumbData:UIImagePNGRepresentation(realImage)];
                }
                WXWebpageObject *ext = [WXWebpageObject object];
                ext.webpageUrl = [NSString stringWithFormat:@"%@/othersHome/%zd", JA_SERVER_WEB, SPLocalInfo.userModel.Id];
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
}

#pragma mark - SJMineHeaderViewDelegate
- (void)didClickPortraitImageView
{
    //点击头像
    if (!SPLocalInfo.hasBeenLogin) {
        [self loginAction];
    } else {
        
        //查看大图
        if (kStringIsEmpty(SPLocalInfo.userModel.avatarUrl)) {
        
        SJAccountSettingsViewController *extractedExpr = [SJAccountSettingsViewController alloc];
        SJAccountSettingsViewController *accountSettingsVC = [extractedExpr init];
            accountSettingsVC.titleName = @"    ";
            [self.navigationController pushViewController:accountSettingsVC animated:YES];
        } else {
            SJBrowserController *browserVC = [[SJBrowserController alloc] init];
            browserVC.fetchPhotoResults = [@[SPLocalInfo.userModel.avatarUrl] mutableCopy];
            browserVC.noEdit = YES;
            [self.navigationController pushViewController:browserVC animated:YES];
        }
    }
}

- (void)didClickBgView:(SJMineHeaderView *)headerView
{
    //进入设置页面
    [self setAction];
}

- (void)didSelectedItemModel:(SJHeaderItemModel *)itemModel
{
    if ([self alertAction]) {
        if ([itemModel.titleStr isEqualToString:@"帖子"]) {
            
            SJNoteController *noteVC = [[SJNoteController alloc] init];
            noteVC.hidesBottomBarWhenPushed = YES;
            noteVC.userId = SPLocalInfo.userModel.Id;
            noteVC.isMyPost = YES;
            noteVC.titleName = @"我的帖子";
            [self.navigationController pushViewController:noteVC animated:YES];
            
            [SJStatisticEventTool umengEvent:Nsj_Event_Mine
                                       NsjId:@"20010700"
                                     NsjName:@"点击我的帖子"];
            
        } else if ([itemModel.titleStr isEqualToString:@"图册"]) {
            
            SJMyPictureController *pictVC = [[SJMyPictureController alloc] init];
            pictVC.userId = SPLocalInfo.userModel.Id;
            pictVC.titleName = @"我的图册";
            [self.navigationController pushViewController:pictVC animated:YES];
            
            [SJStatisticEventTool umengEvent:Nsj_Event_Mine
                                       NsjId:@"20010800"
                                     NsjName:@"点击我的图册"];
            
        } else if ([itemModel.titleStr isEqualToString:@"收藏"]) {
            
            SJMyCollectionViewController *myCollectionVC = [[SJMyCollectionViewController alloc] init];
            myCollectionVC.hidesBottomBarWhenPushed = YES;
            myCollectionVC.titleName = @"我的收藏";
            [self.navigationController pushViewController:myCollectionVC animated:YES];
            
            [SJStatisticEventTool umengEvent:Nsj_Event_Mine
                                       NsjId:@"20010900"
                                     NsjName:@"点击我的收藏"];
            
        } else if ([itemModel.titleStr isEqualToString:@"消息"]) {
            
            SJMessageListViewController *messageVC = [[SJMessageListViewController alloc] init];
            messageVC.hidesBottomBarWhenPushed = YES;
            messageVC.titleName = @"消息";
            [self.navigationController pushViewController:messageVC animated:YES];
            
            [SJStatisticEventTool umengEvent:Nsj_Event_Mine
                                       NsjId:@"20011000"
                                     NsjName:@"点击我的消息"];
        }
    }
}

#pragma mark - 消息
- (void)messageAction {
    
    if ([self alertAction]) {
        SJMessageListViewController *messageVC = [[SJMessageListViewController alloc] init];
        messageVC.hidesBottomBarWhenPushed = YES;
        messageVC.titleName = @"消息";
        [self.navigationController pushViewController:messageVC animated:YES];
    }
    
    [SJStatisticEventTool umengEvent:Nsj_Event_Mine
                               NsjId:@"20011000"
                             NsjName:@"点击我的消息"];
}

#pragma mark - 关注
- (void)concernAction{
    [SJStatisticEventTool umengEvent:Nsj_Event_Mine
                               NsjId:@"20010400"
                             NsjName:@"点击我的关注"];
    
    if ([self alertAction]) {
        SJConcernViewController *concernVC = [[SJConcernViewController alloc] init];
        concernVC.hidesBottomBarWhenPushed = YES;
        concernVC.userId = SPLocalInfo.userModel.Id;
        concernVC.titleName = @"我关注的人";
        [self.navigationController pushViewController:concernVC animated:YES];
    }
}
#pragma mark - 粉丝
- (void)fansAction{
    [SJStatisticEventTool umengEvent:Nsj_Event_Mine
                               NsjId:@"20010500"
                             NsjName:@"点击我的粉丝"];
    
    if ([self alertAction]) {
        SJFansViewController *fansVC = [[SJFansViewController alloc] init];
        fansVC.hidesBottomBarWhenPushed = YES;
        fansVC.titleName = @"我的粉丝";
        fansVC.userId = SPLocalInfo.userModel.Id;
        [self.navigationController pushViewController:fansVC animated:YES];
    }
}
#pragma mark - 创建组
- (void)groupAction{
    [SJStatisticEventTool umengEvent:Nsj_Event_Mine
                               NsjId:@"20010600"
                             NsjName:@"点击我的足迹"];
    
    if ([self alertAction]) {
        SJCreateGroupViewController *createGroupVC = [[SJCreateGroupViewController alloc] init];
        createGroupVC.hidesBottomBarWhenPushed = YES;
        createGroupVC.titleName = @"我创建的足迹";
        createGroupVC.userId = SPLocalInfo.userModel.Id;
        [self.navigationController pushViewController:createGroupVC animated:YES];
    }
}

#pragma mark - 判断登录弹窗
- (BOOL)alertAction{
    if (!SPLocalInfo.hasBeenLogin) {
        SJAlertModel *alertModel = [[SJAlertModel alloc] initWithTitle:@"确认"
                                                               handler:^(id content) {
            [self loginAction];
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

#pragma mark - 登录
- (void)loginAction{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_Login_Request
                                                        object:nil];
//    [self pushToNoviceGuidance];
}

- (void)pushToNoviceGuidance{
    SJNoviceGuideStep3Controller *vc = [[SJNoviceGuideStep3Controller alloc] initWithNibName:@"SJNoviceGuideStep3Controller" bundle:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController showViewController:vc
                                               sender:nil];
    });
    
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
#pragma mark - headerView
- (SJMineHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [SJMineHeaderView createCellWithXib];
        _headerView.backgroundColor = [UIColor whiteColor];
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, iPhoneX?332:308);
        _headerView.delegate = self;
        _headerView.portraitImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headerView.portraitImageView.layer.masksToBounds = YES;
        [_headerView.concernBtn addTarget:self action:@selector(concernAction) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.fansBtn addTarget:self action:@selector(fansAction) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.messageBtn addTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.groupBtn addTarget:self action:@selector(groupAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

#pragma mark - footView
- (SJNoDataFootView *)footView {
    if (!_footView) {
        _footView = [SJNoDataFootView createCellWithXib];
        CGFloat height =  kScreenHeight - self.headerView.height - kNavBarHeight - kTabBarHeight;
        _footView.frame = CGRectMake(0, 0, kScreenWidth, height);
        [_footView.buttonView customButtonClick:^(UIButton *button) {
            [self loginAction];
        }];
        _footView.imageTopHeight.constant = (SPLocalInfo.hasBeenLogin)?40:_footView.height*0.5-110;
    }
    _footView.exceptionStyle = (SPLocalInfo.hasBeenLogin)?SJExceptionStyleNoData:SJExceptionStyleUnLogin;
    return _footView;
}

#pragma mark - TableView
- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarHeight) style:UITableViewStylePlain];
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [_mainTableView registerNib:[UINib nibWithNibName:@"SJMineTableViewCell" bundle:nil] forCellReuseIdentifier:@"SJMineTableViewCell"];
        _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, iPhoneX?34:0, 0);
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _mainTableView.tableHeaderView = self.headerView;
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self beginRefreshing];
        }];
    }
    return _mainTableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SJMineCell *cell = [SJMineCell xibCell:tableView];
    SJCellModel *cellModel = [self.listModelArray objectAtIndex:indexPath.row];
    cell.cellModel = cellModel;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SJCellModel *cellModel = [self.listModelArray objectAtIndex:indexPath.row];
    if ([cellModel.title isEqualToString:@"帖子"]) {
        
        //进入帖子列表
        SJNoteController *noteVC = [[SJNoteController alloc] init];
        noteVC.hidesBottomBarWhenPushed = YES;
        noteVC.userId = SPLocalInfo.userModel.Id;
        noteVC.isMyPost = YES;
        noteVC.titleName = @"我的帖子";
        [self.navigationController pushViewController:noteVC animated:YES];
        
        [SJStatisticEventTool umengEvent:Nsj_Event_Mine
                                   NsjId:@"20010700"
                                 NsjName:@"点击我的帖子"];
        
    } else if ([cellModel.title isEqualToString:@"图册"]) {
        
        //进入我的图册
        SJMyPictureController *pictVC = [[SJMyPictureController alloc] init];
        pictVC.userId = SPLocalInfo.userModel.Id;
        pictVC.titleName = @"我的图册";
        [self.navigationController pushViewController:pictVC animated:YES];
        
        [SJStatisticEventTool umengEvent:Nsj_Event_Mine
                                   NsjId:@"20010800"
                                 NsjName:@"点击我的图册"];
        
    } else if ([cellModel.title isEqualToString:@"收藏"]) {
        
        //收藏
        SJMyCollectionViewController *myCollectionVC = [[SJMyCollectionViewController alloc] init];
        myCollectionVC.hidesBottomBarWhenPushed = YES;
        myCollectionVC.titleName = @"我的收藏";
        [self.navigationController pushViewController:myCollectionVC animated:YES];
        
        [SJStatisticEventTool umengEvent:Nsj_Event_Mine
                                   NsjId:@"20010900"
                                 NsjName:@"点击我的收藏"];
        
    } else if ([cellModel.title isEqualToString:@"任务"]) {
        
        //任务
        [self taskAction];
    } else if ([cellModel.title isEqualToString:@"时光轴"]) {
        
        //时光轴
        SJOtherInfoPageController *otherInfoVC = [[SJOtherInfoPageController alloc] init];
        otherInfoVC.userId = SPLocalInfo.userModel.Id;
        otherInfoVC.titleName = [SPLocalInfo.userModel getShowNickName];
        [self.navigationController pushViewController:otherInfoVC animated:YES];
    } else if ([cellModel.title isEqualToString:@"设置"]) {
        
        //设置
        [self setAction];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return SPLocalInfo.hasBeenLogin?self.listModelArray.count:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 130;
    return 55.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headerView.backgroundColor = JMY_BG_COLOR;
    return headerView;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    LogD(@"~~~%lf---", scrollView.contentOffset.y)
    CGFloat bgAlpha = (scrollView.contentOffset.y) / kNavBarHeight;
    self.userNavView.bgAlpha = bgAlpha;
}

#pragma mark - SJMineNavViewDelegate
- (void)didClickSetBtn:(SJMineNavView *)navView
{
    if ([self alertAction])
    {
        SJAccountSettingsViewController *extractedExpr = [SJAccountSettingsViewController alloc];
        SJAccountSettingsViewController *accountSettingsVC = [extractedExpr init];
        accountSettingsVC.titleName = @"    ";
        [self.navigationController pushViewController:accountSettingsVC animated:YES];
    }
}

- (void)didClickPostBtn:(SJMineNavView *)navView
{
    [self shareAction];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
