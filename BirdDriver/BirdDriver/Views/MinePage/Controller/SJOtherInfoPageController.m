//
//  SJOtherInfoPageController.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/24.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//
// 他人信息页面

#import "SJOtherInfoPageController.h"
#import "SJNoteDetailController.h"
#import "SJFootprintDetailsController.h"
#import "SJMineTableViewCell.h"
#import "SJOtherHeaderView.h"
#import "SJOtherNavView.h"
#import "SJUserTagsView.h"
#import "SJCreateGroupViewController.h"
#import "SJFansViewController.h"
#import "SJConcernViewController.h"
#import "JAUserPresenter.h"
#import "JABbsPresenter.h"
#import <WXApi.h>
#import "UIImage+ColorsImage.h"
#import "SJDetailController.h"
#import "SJBrowserController.h"
#import "SJLoginController.h"
#import "SJShareView.h"
#import "SJSheetView.h"
#import "SJLineView.h"
 
#import "SJNoteController.h"

@interface SJOtherInfoPageController ()<UITableViewDelegate, UITableViewDataSource, SJOtherNavViewDelegate>
{
    //是否拉黑
    BOOL _isBlocked;
}

@property (nonatomic, strong) SJOtherNavView *userNavView;
@property(strong, nonatomic) SJOtherHeaderView *headerView;
@property(strong, nonatomic) SJNoDataFootView *footView;
@property (nonatomic, strong) UIButton *attentionBtn;

@property(strong, nonatomic) JATimeLineListModel *timeLineListModel;
@property(strong, nonatomic) JAUserAccount *otherInfo;

@property(nonatomic, assign) NSInteger page;

@end

@implementation SJOtherInfoPageController

#pragma mark - lazy loading
- (SJOtherNavView *)userNavView
{
    if (_userNavView == nil)
    {
        _userNavView = [[SJOtherNavView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavBarHeight)];
        _userNavView.delegate = self;
        _userNavView.titleName = @"TA的主页";
    }
    return _userNavView;
}

- (UIButton *)attentionBtn
{
    if (_attentionBtn == nil)
    {
        _attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _attentionBtn.frame = CGRectMake(0, kScreenHeight-44, kScreenWidth, 44);
        [_attentionBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"2B3248" alpha:1]] forState:UIControlStateNormal];
        [_attentionBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"CCCCCC" alpha:1]] forState:UIControlStateSelected];
        [_attentionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_attentionBtn setTitle:@"已关注" forState:UIControlStateSelected];
        _attentionBtn.titleLabel.font = SPFont(15.0);
        [_attentionBtn addTarget:self action:@selector(attentionAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _attentionBtn;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableViewStyle = UITableViewStylePlain;
    self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listView.tableHeaderView = self.headerView;
    self.listView.backgroundColor = [UIColor whiteColor];
    [self.listView registerNib:[UINib nibWithNibName:@"SJMineTableViewCell" bundle:nil]
        forCellReuseIdentifier:@"SJMineTableViewCell"];
    
    self.listView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self beginRefreshing];
    }];
    
    self.listView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self lodingMore];
    }];
    [self.view addSubview:self.userNavView];
    
    [self.view addSubview:self.attentionBtn];
    self.attentionBtn.hidden = (self.userId == SPLocalInfo.userModel.Id);
    self.userNavView.navType = (self.userId == SPLocalInfo.userModel.Id)?SJUserNavViewMine:SJUserNavViewOther;
    
    self.listView.contentInset = UIEdgeInsetsMake(0, 0, self.attentionBtn.height, 0);
    
    //判断是否已拉黑
    [self judgeIsBlocked];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess)
                                                 name:kNotify_loginSuccess
                                               object:nil];
    
    UIBarButtonItem *moreBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"detail_more"]
                                                                style:UIBarButtonItemStyleDone
                                                               target:self
                                                               action:@selector(moreBtnClick)];
    self.navigationItem.rightBarButtonItem = moreBtn;
    self.page = 1;
    [self beginRefreshing];
}


- (void)loginSuccess
{
    [self judgeIsBlocked];
}

- (void)judgeIsBlocked
{
    if ([SPLocalInfo hasBeenLogin]) {
        [SVProgressHUD show];
        [JAUserPresenter postIsBlackList:self.userId Result:^(JAIsBlockModel * _Nullable model) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (model.success) {
                    self->_isBlocked = model.blacked;
                } else {
                    [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                }
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            });
        }];
    }
}

- (void)beginRefreshing {
    self.page = 1;
    [self getUserInfo];
    [self getTimeList];
}

- (void)lodingMore {
    self.page ++;
    [self getTimeList];
}

- (void)getTimeList {
    [JABbsPresenter postQueryTimeAxis:self.userId
                             IsPaging:YES
                      WithCurrentPage:self.page
                            WithLimit:20
                               Result:^(JATimeLineListModel * _Nullable model) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [self.listView.mj_header endRefreshing];
                                       [self.listView.mj_footer endRefreshing];
                                       if (self.page == 1) {
                                           self.timeLineListModel = model;
                                       } else {
                                           NSMutableArray *array = [self.timeLineListModel.timeAxisPOList mutableCopy];
                                           self.timeLineListModel = model;
                                           [array addObjectsFromArray:self.timeLineListModel.timeAxisPOList];
                                           self.timeLineListModel.timeAxisPOList = array;
                                       }
                                       self.listView.tableFooterView = nil;
                                       if ([self.timeLineListModel.timeAxisPOList count] == 0) {
                                           self.listView.tableFooterView = self.footView;
                                       }
                                       if (self.timeLineListModel.timeAxisPOList.count < (20 * self.page)) {
                                           [self.listView.mj_footer endRefreshingWithNoMoreData];
                                       }
                                       [self.listView reloadData];
                                   });
                               }];
}

- (void)getUserInfo {
    [JAUserPresenter postQueryOtherUserInfo:self.userId
                                     Result:^(JAUserAccount * _Nullable model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.otherInfo = model;
            if (model.success) {
                [self updateUserInfo];
            } else {
                [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            }
        });
    }];
}

-(void)updateUserInfo{
    
    self.userNavView.titleName = (SPLocalInfo.userModel.Id == self.otherInfo.Id)?@"我的":@"TA的主页";
    if (self.otherInfo) {//更新用户信息
        
        _headerView.attentionBtn.hidden = NO;
        _headerView.genderAddressBtn.hidden = NO;
        self.headerView.fansLabel.text = [NSString stringWithFormat:@"%ld", self.otherInfo.fansNum];
        self.headerView.concernLabel.text = [NSString stringWithFormat:@"%ld", self.otherInfo.attentionNum];
        self.headerView.groupLabel.text = [NSString stringWithFormat:@"%ld", self.otherInfo.activityNum];
        self.headerView.postLabel.text = [NSString stringWithFormat:@"%ld", self.otherInfo.postsNum];

        [self.headerView.portraitImageView sd_setImageWithURL:self.otherInfo.avatarUrl.mj_url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_portrait"]];
        //昵称
        self.headerView.nameLabel.text = [self.otherInfo getShowNickName];
        //标签
        self.headerView.tagListView.tagList = [self.otherInfo.hobbies componentsSeparatedByString:@","];
        //个人签名
        if (self.otherInfo.personalSign.length > 0) {
            self.headerView.describeLabel.text = self.otherInfo.personalSign;
        } else {
            self.headerView.describeLabel.text = @"太懒了，未添加个人签名";
        }
//        //地址
//        if (self.otherInfo.address.length > 0) {
//            [self.headerView.genderAddressBtn setTitle:self.otherInfo.address forState:UIControlStateNormal];
//        } else {
//            [self.headerView.genderAddressBtn setTitle:@"未知" forState:UIControlStateNormal];
//        }
        //性别0是女，1是男
        if ([self.otherInfo.sex isEqualToString:@"1"]) {//男
            self.headerView.portraitImageView.layer.borderColor = [UIColor colorWithHexString:@"6EEBEE" alpha:1].CGColor;
            self.headerView.portraitImageView.layer.borderWidth = 2.0;
//            [self.headerView.genderAddressBtn setImage:[UIImage imageNamed:@"mine_man"] forState:UIControlStateNormal];
        } else {//女
            self.headerView.portraitImageView.layer.borderColor = [UIColor colorWithHexString:@"F9739B" alpha:1].CGColor;
            self.headerView.portraitImageView.layer.borderWidth = 2.0;
//            [self.headerView.genderAddressBtn setImage:[UIImage imageNamed:@"mine_woman"] forState:UIControlStateNormal];
        }
        //是否关注
        if (self.otherInfo.attentioned) {
            self.attentionBtn.selected = YES;
//            [self.headerView.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
        } else {
//            [self.headerView.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
            self.attentionBtn.selected = NO;
        }
        self.titleName = kStringIsEmpty(self.titleName)?@"他人主页":self.titleName;
    } else {
        self.titleName = @"他人主页";
        self.headerView.fansLabel.text = @"0";
        self.headerView.concernLabel.text = @"0";
        self.headerView.groupLabel.text = @"0";
        self.headerView.postLabel.text = @"0";
        [self.headerView.portraitImageView setImage:[UIImage imageNamed:@"default_portrait"] forState:UIControlStateNormal];
        self.headerView.nameLabel.text = @"鸟斯基";
        self.headerView.tagListView.tagList = @[@"个人标签"];
        self.headerView.describeLabel.text = @"玩到青春浪漫时";
        [self.headerView.genderAddressBtn setTitle:@"" forState:UIControlStateNormal];
        [self.headerView.genderAddressBtn setImage:[UIImage new] forState:UIControlStateNormal];
    }
}


#pragma mark - 分享
-(void)moreBtnClick{
    
    SJSheetModel *circleModel = [[SJSheetModel alloc] init];
    circleModel.name = @"朋友圈";
    circleModel.actionType = SJSheetViewActionTypeCircle;
    circleModel.imageStr = @"more_circle";
    
    SJSheetModel *friendModel = [[SJSheetModel alloc] init];
    friendModel.name = @"微信好友";
    friendModel.actionType = SJSheetViewActionTypeFriend;
    friendModel.imageStr = @"more_friend";
    
    SJSheetModel *unBlockModel = [[SJSheetModel alloc] init];
    unBlockModel.name = @"拉黑";
    unBlockModel.actionType = SJSheetViewActionTypeUnBlock;
    unBlockModel.imageStr = @"more_block";
    
    SJSheetModel *blockedModel = [[SJSheetModel alloc] init];
    blockedModel.name = @"已拉黑";
    blockedModel.actionType = SJSheetViewActionTypeBlocked;
    blockedModel.imageStr = @"more_hasBlock";
    
    NSMutableArray *sheetModels = [NSMutableArray arrayWithArray:@[circleModel, friendModel]];
    if (![WXApi isWXAppInstalled]) {
        [sheetModels removeAllObjects];
    }
    if (self.userId != SPLocalInfo.userModel.Id) {
        [sheetModels addObject:_isBlocked?blockedModel:unBlockModel];
    }
    
    SJSheetView *sheetView = [SJSheetView sheetViewWithSheetModels:sheetModels ClickBlock:^(SJSheetViewActionType actionType) {
        
        switch (actionType) {
            case SJSheetViewActionTypeCircle:
            case SJSheetViewActionTypeFriend:
            {
                [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:kSJSharePageKey];
                WXMediaMessage *message = [WXMediaMessage message];
                message.title = [NSString stringWithFormat:@"%@的鸟斯基个人主页", [self.otherInfo getShowNickName]];
                message.description = kStringIsEmpty(self.otherInfo.personalSign)?@"傲娇的我，等你来撩~":self.otherInfo.personalSign;
                
                UIImage *iconImage = [UIImage dealImage:[UIImage imageNamed:@"default_portrait"] scaleToSize:CGSizeMake(80, 80)];
                NSData *iconData = UIImagePNGRepresentation(iconImage);
                [message setThumbData:iconData];
                if (!kStringIsEmpty(self.otherInfo.avatarUrl)) {
                    
                    UIImage *realImage = [UIImage dealImage:self.headerView.portraitImageView.imageView.image scaleToSize:CGSizeMake(80, 80)];
                    [message setThumbData:UIImagePNGRepresentation(realImage)];
                }
                WXWebpageObject *ext = [WXWebpageObject object];
                ext.webpageUrl = [NSString stringWithFormat:@"%@/othersHome/%zd", JA_SERVER_WEB, self.userId];
                message.mediaObject = ext;
                SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
                req.bText = NO;
                req.message = message;
                req.scene = actionType==SJSheetViewActionTypeCircle?WXSceneTimeline:WXSceneSession;
                [WXApi sendReq:req];
            }
                break;
            case SJSheetViewActionTypeUnBlock:
            {
                if (![self alertAction]) return ;
                if (self.userId == SPLocalInfo.userModel.Id) {
                    
                    [SVProgressHUD showInfoWithStatus:@"您不可以拉黑自己"];
                    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                    return;
                }
                
                SJAlertModel *alertModel = [[SJAlertModel alloc] initWithTitle:@"残忍拉黑" handler:^(id content) {
                    
                    //拉黑
                    [JAUserPresenter postUserInteraction:self.userId Result:^(JAResponseModel * _Nullable model) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if (model.success) {
                                
                                self->_isBlocked = YES;
                                [SVProgressHUD showSuccessWithStatus:@"拉黑成功"];
                                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                            }
                        });
                    }];
                }];
                SJAlertModel *cancelModel = [[SJAlertModel alloc] initWithTitle:@"我再想想" handler:^(id content) {
                }];
                SJAlertView *alertView = [SJAlertView alertWithTitle:@"真的要拉黑TA吗？拉黑了就看不见他Ta的评论了哦！" message:@"" type:SJAlertShowTypeNormal alertModels:@[alertModel,cancelModel]];
                [alertView showAlertView];
            }
                break;
            case SJSheetViewActionTypeBlocked:
            {
                SJAlertModel *alertModel = [[SJAlertModel alloc] initWithTitle:@"确定" handler:^(id content) {
                    
                    //取消拉黑
                    [JAUserPresenter postCancelDefriend:self.userId Result:^(JAResponseModel * _Nullable model) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if (model.success) {
                                
                                self->_isBlocked = NO;
                                [SVProgressHUD showSuccessWithStatus:@"取消拉黑成功"];
                                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                            }
                        });
                    }];
                }];
                SJAlertModel *cancelModel = [[SJAlertModel alloc] initWithTitle:@"取消" handler:^(id content) {
                }];
                SJAlertView *alertView = [SJAlertView alertWithTitle:@"温馨提示\n\n确定要把Ta从小黑屋放出来吗？" message:@"" type:SJAlertShowTypeSubTitle alertModels:@[alertModel,cancelModel]];
                [alertView showAlertView];
            }
                break;
                
            default:
                break;
        }
    }];
    [sheetView show];
}

#pragma mark - 关注
-(void)concernAction{
    if ([self alertAction]) {
        SJConcernViewController *concernVC = [[SJConcernViewController alloc] init];
        concernVC.titleName = @"他关注的人";
        concernVC.userId = self.otherInfo.uid;
        [self.navigationController pushViewController:concernVC animated:YES];
    }
    
}
#pragma mark - 粉丝
-(void)fansAction{
    if ([self alertAction]) {
        SJFansViewController *fansVC = [[SJFansViewController alloc] init];
        fansVC.titleName = @"他的粉丝";
        fansVC.userId = self.otherInfo.uid;
        [self.navigationController pushViewController:fansVC animated:YES];
    }
    
}
#pragma mark - 创建组
-(void)groupAction{
    if ([self alertAction]) {
        SJCreateGroupViewController *createGroupVC = [[SJCreateGroupViewController alloc] init];
        createGroupVC.titleName = @"TA创建的足迹";
        createGroupVC.userId = self.otherInfo.uid;
        [self.navigationController pushViewController:createGroupVC animated:YES];
    }
}
#pragma mark - 帖子
- (void)postAction{
    if ([self alertAction]) {
        SJNoteController *noteVC = [[SJNoteController alloc] init];
        noteVC.hidesBottomBarWhenPushed = YES;
        noteVC.userId = self.otherInfo.uid;
        noteVC.titleName = @"TA的帖子";
        [self.navigationController pushViewController:noteVC animated:YES];
    }
}

#pragma mark - 关注他
- (void)attentionAction{
    if ([self alertAction]) {
        //是否关注
        if (self.otherInfo.attentioned) {
            
            [SVProgressHUD show];
            [JAUserPresenter postCancelAttentionUser:self.otherInfo.uid
                                              Result:^(JAResponseModel * _Nullable model) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (model.success) {
                        self.otherInfo.attentioned = NO;
                        self.otherInfo.fansNum -= 1;
                        
                        [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
                    } else {
                        [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                    }
                    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                    [self updateUserInfo];
                });
            }];
        } else {
            [SVProgressHUD show];
            [JAUserPresenter postAttentionUser:self.otherInfo.uid
                                        Result:^(JAAttentionUserModel * _Nullable model) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (model.success) {
                        self.otherInfo.attentioned = YES;
                        self.otherInfo.fansNum += 1;
                        [SVProgressHUD showSuccessWithStatus:@"关注成功"];
                    } else {
                        [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                    }
                    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                    [self updateUserInfo];
                });
            }];
        }
    }
}

#pragma mark - headerView
- (SJOtherHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [SJOtherHeaderView createCellWithXib];
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, iPhoneX?332:308);
         _headerView.portraitImageView.imageView.layer.masksToBounds = YES;
        [_headerView.portraitImageView addTarget:self action:@selector(bigHeaderView) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.concernBtn addTarget:self
                                   action:@selector(concernAction)
                         forControlEvents:UIControlEventTouchUpInside];
        [_headerView.fansBtn addTarget:self
                                action:@selector(fansAction)
                      forControlEvents:UIControlEventTouchUpInside];
        [_headerView.groupBtn addTarget:self
                                 action:@selector(groupAction)
                       forControlEvents:UIControlEventTouchUpInside];
        [_headerView.postBtn addTarget:self
                                action:@selector(postAction)
                      forControlEvents:UIControlEventTouchUpInside];
        [_headerView.attentionBtn addTarget:self
                                     action:@selector(attentionAction)
                           forControlEvents:UIControlEventTouchUpInside];
        _headerView.attentionBtn.hidden = YES;
        _headerView.genderAddressBtn.hidden = YES;
//        [_headerView layoutIfNeeded];
    }
    return _headerView;
}

-(void)viewDidLayoutSubviews{
    self.listView.frame = self.view.bounds;
    self.headerView.frame = CGRectMake(0, 0, kScreenWidth, iPhoneX?332:308);
    self.attentionBtn.frame = CGRectMake(0, kScreenHeight-44, kScreenWidth, 44);
}

#pragma mark - footView
-(SJNoDataFootView *)footView{
    if (!_footView) {
        _footView = [SJNoDataFootView createCellWithXib];
        _footView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 305 - kNavBarHeight);
        _footView.exceptionStyle = SJExceptionStyleNoData;
        _footView.isShow = NO;
        [_footView reloadView];
    }
    return _footView;
}

#pragma mark - TableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"SJMineTableViewCell";
    SJMineTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:Identifier];
    cell.deleteBtn.hidden = (SPLocalInfo.userModel.Id != self.userId);
    cell.isTopLineHiden = (indexPath.row == 0);
    JATimeLineModel *model = [self.timeLineListModel.timeAxisPOList objectAtIndex:indexPath.row];
    [cell setTimeModel:model];
    cell.deleteModelBlock = ^(JATimeLineModel *deleteModel) {
        [self deleteAction:deleteModel];
    };
    return cell;
}

#pragma mark - 删除动态
- (void)deleteAction:(JATimeLineModel *)deleteModel{
    SJAlertModel *alertModel = [[SJAlertModel alloc] initWithTitle:@"确认" handler:^(id content) {
        [JABbsPresenter postUpdateTimeAxis:deleteModel.ID Result:^(JAResponseModel * _Nullable model) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (model.success) {
                    NSInteger index = [self.timeLineListModel.timeAxisPOList indexOfObject:deleteModel];
                    [self.timeLineListModel.timeAxisPOList removeObject:deleteModel];
                    if (kArrayIsEmpty(self.timeLineListModel.timeAxisPOList)) {
                        self.listView.tableFooterView = self.footView;
                        [self.listView reloadData];
                    } else {
                        [self.listView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    }
                } else {
                    [SVProgressHUD showInfoWithStatus:@"删除失败"];
                    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                }
            });
        }];
    }];
    SJAlertModel *cancelModel = [[SJAlertModel alloc] initWithTitle:@"取消" handler:^(id content) {
    }];
    SJAlertView *alertView = [SJAlertView alertWithTitle:@"是否确认删除该动态？" message:@"仅删除动态在个人主页的显示\n不对其他操作产生影响." type:SJAlertShowTypeSubTitle alertModels:@[alertModel,cancelModel]];
    [alertView showAlertView];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JATimeLineModel *model = [self.timeLineListModel.timeAxisPOList objectAtIndex:indexPath.row];
    if (model.axisType == JAAxisTypePost) {
        
        SJNoteDetailController *detailVC = [[SJNoteDetailController alloc] init];
        detailVC.noteId = model.detailsId;
        dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController showViewController:detailVC
                                               sender:nil];
        });
    } else if (model.axisType == JAAxisTypeActive){
        SJFootprintDetailsController *detailVC = [[SJFootprintDetailsController alloc] init];
        detailVC.titleName = model.describtion;
        detailVC.activityId = model.detailsId;
        dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController showViewController:detailVC
                                               sender:nil];
        });
    } else if (model.axisType == JAAxisTypePhoto){
        //进入详情
        NSMutableArray *pictureArray = [NSMutableArray array];
        for (NSString *address in model.picturesList) {
            JAPhotoModel *photoModel = [[JAPhotoModel alloc] init];
            photoModel.address = address;
            [pictureArray addObject:photoModel];
        }
        SJBrowserController *browserVC = [[SJBrowserController alloc] init];
        browserVC.fetchPhotoResults = [pictureArray mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController showViewController:browserVC
                                                   sender:nil];
        });
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.timeLineListModel.timeAxisPOList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 164;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 68.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 68)];
    headView.backgroundColor = [UIColor colorWithHexString:@"F6F7F8" alpha:1];
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 58)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:whiteView];
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 58)];
    descLabel.text = @"动态";
    descLabel.font = [UIFont boldSystemFontOfSize:15.0];
    descLabel.textAlignment = NSTextAlignmentLeft;
    [whiteView addSubview:descLabel];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 53-4, 9, 4)];
    imageView.image = [UIImage imageNamed:@"half_circle"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [whiteView addSubview:imageView];
    SJLineView *sepLine = [[SJLineView alloc] initWithFrame:CGRectMake(24, CGRectGetMaxY(imageView.frame), kScreenWidth-24, 1)];
    sepLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE" alpha:1];
    [whiteView addSubview:sepLine];
    
    return headView;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    LogD(@"~~~%lf---", scrollView.contentOffset.y)
    CGFloat bgAlpha = (scrollView.contentOffset.y) / kNavBarHeight;
    self.userNavView.bgAlpha = bgAlpha;
}

#pragma mark - SJOtherNavViewDelegate
- (void)navView:(SJOtherNavView *)navView didClick:(BOOL)isBack
{
    if (isBack)
    {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self moreBtnClick];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 判断登录弹窗
-(BOOL)alertAction {
    if (![SPLocalInfoModel shareInstance].hasBeenLogin)
    {
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
}

-(void)bigHeaderView{
    
    if (!kStringIsEmpty(self.otherInfo.avatarUrl)) {
        
        SJBrowserController *browserVC = [[SJBrowserController alloc] init];
        browserVC.fetchPhotoResults = [@[self.otherInfo.avatarUrl] mutableCopy];
        browserVC.noEdit = YES;
        [self.navigationController pushViewController:browserVC animated:YES];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
