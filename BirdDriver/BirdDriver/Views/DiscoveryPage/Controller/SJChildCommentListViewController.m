//
//  SJChildCommentListViewController.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/8/10.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJChildCommentListViewController.h"
#import "SJFootprintDetialsCommentCell.h"
#import "JABbsPresenter.h"
#import "SJActivityReviewViewController.h"
#import "SJOtherInfoPageController.h"
#import "SJLoginController.h"
#import "SJReportController.h"
#import "NSString+XHLStringSize.h"
#import "SJBrowserController.h"


@interface SJChildCommentListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) SJNoDataFootView *footView;
@property(strong, nonatomic) JAChildCommentListModel *listModel;

@property(nonatomic, assign) NSInteger page;
@property (strong, nonatomic) UIButton *btn_comment;


@end

@implementation SJChildCommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.listView registerNib:[UINib nibWithNibName:@"SJFootprintDetialsCommentCell" bundle:nil]
        forCellReuseIdentifier:@"SJFootprintDetialsCommentCell"];
    self.listView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self beginRefreshing];
    }];
    
    self.listView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self lodingMore];
    }];
    
    
    [self.view addSubview:self.btn_comment];
    [self.btn_comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottomMargin);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(kScreenWidth - 30));
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.page = 1;
    [self beginRefreshing];
}

- (void)beginRefreshing {
    self.page = 1;
    [self getCommentList];
}

- (void)lodingMore {
    self.page ++;
    [self getCommentList];
}

- (void)getCommentList {
    //请求相关评论集合，并刷新UI
    [JABbsPresenter postQueryChildCommentsList:self.activityId Id:self.commentId commentUserId:self.commentUserId IsPaging:YES WithCurrentPage:self.page WithLimit:20 WithSort:@"desc" Result:^(JAChildCommentListModel * _Nullable model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listView.mj_header endRefreshing];
            [self.listView.mj_footer endRefreshing];
            if(model.success){
                if (self.page == 1) {
                    self.listModel = model;
                } else {
                    NSMutableArray *array = [self.listModel.childList mutableCopy];
                    self.listModel = model;
                    [array addObjectsFromArray:self.listModel.childList];
                    self.listModel.childList = array;
                }
                UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 128)];
                if (iPhoneX) {
                    [footer setFrame:CGRectMake(0, 0, kScreenWidth, 128)];
                }else{
                    [footer setFrame:CGRectMake(0, 0, kScreenWidth, 68)];
                }
                self.listView.tableFooterView = footer;
                if ([self.listModel.childList count] == 0) {
                    self.listView.tableFooterView = self.footView;
                }
                if (self.listModel.childList.count < (20 * self.page)) {
                    [self.listView.mj_footer endRefreshingWithNoMoreData];
                }
            }else{
                NSString *msg = [NSString stringWithFormat:@"获取评论列表失败\n%@ ",model.responseStatus.message];
                [self footViewRefresh:msg];
            }
            [self.listView reloadData];
        });
    }];
}

#pragma mark - 写点评
- (UIButton *)btn_comment{
    if (!_btn_comment) {
        _btn_comment = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_comment setBackgroundImage:[UIImage imageNamed:@"default_btn_bg"]
                                forState:UIControlStateNormal];
        [_btn_comment setTitleColor:[UIColor colorWithRed:255/255.0 green:187.002/255.0 blue:4.00095/255.0 alpha:1]
                           forState:UIControlStateNormal];
        [_btn_comment setTitle:@"回复楼主" forState:UIControlStateNormal];
        [_btn_comment.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:15]];
        [_btn_comment setTitleEdgeInsets:UIEdgeInsetsMake(-8, 0, 8, 0)];
        [_btn_comment addTarget:self
                         action:@selector(actionComment)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_comment;
}

- (void)actionComment{
    if (![self alertAction]) return;
    
    SJActivityReviewViewController *activityReviewVC = [[SJActivityReviewViewController alloc] init];
    activityReviewVC.titleName = @"回复";
    activityReviewVC.activityId = self.activityId;
    activityReviewVC.authorId = self.authorId;
    activityReviewVC.returnCommentModel = self.listModel.entity;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController showViewController:activityReviewVC
                                               sender:nil];
    });
}

#pragma mark - footView
-(SJNoDataFootView *)footView{
    if (!_footView) {
        _footView = [SJNoDataFootView createCellWithXib];
        _footView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavBarHeight);
        _footView.imageTopHeight.constant = (kScreenHeight - kNavBarHeight)/3;
    }
    [self footViewRefresh:nil];
    return _footView;
}

-(void)footViewRefresh:(NSString *)message{
    if (message.length == 0) {
        message = @"获取中";
    }
    _footView.isShow = NO;
    _footView.imageView.image = [UIImage imageNamed:@"search_noData"];
    if ([self.listModel.childList count] > 0) {
        self.listView.tableFooterView = nil;
        if (!self.listModel.success) {
            [SVProgressHUD showInfoWithStatus:message];
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        }
    } else {
        if (self.listModel.success) {
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


- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SJFootprintDetialsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SJFootprintDetialsCommentCell class])];
    if (!cell) {
        cell = [SJFootprintDetialsCommentCell xibCell:tableView];
    }
    cell.lbl_score.hidden = YES;
    cell.img_star_1.hidden = YES;
    cell.img_star_2.hidden = YES;
    cell.img_star_3.hidden = YES;
    cell.img_star_4.hidden = YES;
    cell.img_star_5.hidden = YES;
    
    JACommentModel *currentComment;
    if (indexPath.row == 0) {
        currentComment = self.listModel.entity;
        cell.backgroundColor = [UIColor whiteColor];
    } else {
        currentComment = self.listModel.childList[indexPath.row - 1];
        cell.backgroundColor = JMY_BG_COLOR;
    }
    currentComment.sonComments = 0;
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
        activityReviewVC.authorId = self.authorId;
        activityReviewVC.returnCommentModel = commentModel;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController showViewController:activityReviewVC
                                                   sender:nil];
        });
    };
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.listModel.success) {
       return [self.listModel.childList count] + 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.listModel&&self.listModel.childList.count) {
        //动态Cell高度
        JACommentModel *currentComment;
        if (indexPath.row == 0) {
            currentComment = self.listModel.entity;
        } else {
            currentComment = self.listModel.childList[indexPath.row - 1];
        }
        
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
        return (150 + concentSize.height + imgBoxHeight + returnHeight);
    }
    return 214.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JACommentModel *currentComment;
    if (indexPath.row == 0) {
        currentComment = self.listModel.entity;
    } else {
        currentComment = self.listModel.childList[indexPath.row - 1];
    }
    [self showAlertSelect:currentComment];
    
    
    
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

- (BOOL)alertAction
{
    if (!SPLocalInfo.hasBeenLogin) {
        SJAlertModel *alertModel = [[SJAlertModel alloc] initWithTitle:@"确认" handler:^(id content) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_Login_Request
                                                                    object:nil];
        }];
        SJAlertModel *cancelModel = [[SJAlertModel alloc] initWithTitle:@"取消" handler:^(id content) {
        }];
        SJAlertView *alertView = [SJAlertView alertWithTitle:@"是否登录" message:@"" type:SJAlertShowTypeNormal alertModels:@[alertModel,cancelModel]];
        [alertView showAlertView];
        return NO;
    }
    return YES;
}

-(void)showAlertSelect:(JACommentModel *)commentModel{
    if (![self alertAction]) return ;
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *replyAction = [UIAlertAction actionWithTitle:@"回复" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SJActivityReviewViewController *activityReviewVC = [[SJActivityReviewViewController alloc] init];
        activityReviewVC.titleName = [NSString stringWithFormat:@"回复@%@ ",commentModel.nickName];
        activityReviewVC.activityId = self.activityId;
        activityReviewVC.authorId = self.authorId;
        if (![commentModel isEqual:self.listModel.entity]) {
            activityReviewVC.parentCommentId = self.listModel.entity.ID;
        }
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
                        if ([commentModel isEqual:self.listModel.entity]) {
                            [self.navigationController popViewControllerAnimated:YES];
                        } else {
                            NSMutableArray *array = [self.listModel.childList mutableCopy];
                            [array removeObject:commentModel];
                            self.listModel.childList = array;
                            [self.listView reloadData];
                        }
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
                NSMutableArray *array = [self.listModel.childList mutableCopy];
                [array removeObject:commentModel];
                self.listModel.childList = array;
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
