//
//  SJSettingViewController.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/18.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//
// 个人信息设置

#import "SJSettingViewController.h"
#import "SJLoginController.h"
#import "SJSettingTableViewCell.h"
#import "SJSetHeaderView.h"
#import "SJAccountSettingsViewController.h"
#import "SJRealNameViewController.h"
#import "SJFeedbackViewController.h"
#import "SJPersonInfoViewController.h"
#import "JAUserPresenter.h"
 
#import <AFNetworking/AFNetworking.h>
#import "SJDetailController.h"
#import "SJPhotoComponents.h"
#import "SJPhotosController.h"
#import "JAFileUploadPresenter.h"
#import "SJPhotoModel.h"

@interface SJSettingViewController ()<UITableViewDelegate, UITableViewDataSource,SJPhotoProtocol>

@property(nonatomic,retain)UITableView *mainTableView;
@property(strong, nonnull)SJSetHeaderView *headerView;
@property(strong, nonnull)UIView *footerView;

@property(nonatomic,strong)NSArray *nameArray;
@property(nonatomic,strong)NSArray *imageArray;


@end

@implementation SJSettingViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    //更新用户信息
    [self updateUserInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nameArray = @[@"账号信息",@"实名认证", @"清除缓存", @"客服反馈 ",@"关于鸟斯基"];
    self.imageArray = @[@"Set_account",@"Set_person",@"Set_cache",@"Set_service ",@"Set_update",@"Set_about"];
    self.mainTableView.separatorColor = [UIColor colorWithHexString:@"EEEEEE" alpha:1];
    [self.view addSubview:self.mainTableView];
}

-(void)updateUserInfo {
    [self.headerView.porImageView sd_setImageWithURL:[NSURL URLWithString:SPLocalInfo.userModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    //昵称
    self.headerView.nameLabel.text = [SPLocalInfo.userModel getShowNickName];
    
//    //地址
//    if (SPLocalInfo.userModel.address.length > 0) {
//        [self.headerView.genderAddressBtn setTitle:[NSString stringWithFormat:@"  %@", SPLocalInfo.userModel.address ]forState:UIControlStateNormal];
//    } else {
//        [self.headerView.genderAddressBtn setTitle:@"  未知" forState:UIControlStateNormal];
//    }
    //性别0是女，1是男
    if ([SPLocalInfo.userModel.sex isEqualToString:@"1"]) {//男
        [self.headerView.genderAddressBtn setImage:[UIImage imageNamed:@"mine_man"] forState:UIControlStateNormal];
    } else{//女
        [self.headerView.genderAddressBtn setImage:[UIImage imageNamed:@"mine_woman"] forState:UIControlStateNormal];
    }
}

#pragma mark - mainTableView
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavBarHeight) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _mainTableView.backgroundColor = HEXCOLOR(@"F4F4F4");
        [_mainTableView registerNib:[UINib nibWithNibName:@"SJSettingTableViewCell" bundle:nil] forCellReuseIdentifier:@"SJSettingTableViewCell"];
//        _mainTableView.tableHeaderView = self.headerView;
        _mainTableView.tableFooterView = self.footerView;
    }
    return _mainTableView;
}

#pragma mark - headerView
-(SJSetHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [SJSetHeaderView createCellWithXib];
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, 100);
        _headerView.porImageView.layer.masksToBounds = YES;
        [_headerView.setBtn addTarget:self action:@selector(setInfoAction) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.porImageView setUserInteractionEnabled:YES];
        [_headerView.porImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePorAction)]];
    }
    return _headerView;
}

-(void)changePorAction{
    [SJPhotoComponents requestPhotoAuthorizationWithCompletionHandler:^(BOOL isAllowed) {
        if (isAllowed) {
            SJPhotosController *photoVC = [[SJPhotosController alloc] init];
            photoVC.titleName = @"全部";
            photoVC.maximumLimit = 1;
            photoVC.isHead = YES;
            photoVC.delegate = self;
            [self.navigationController pushViewController:photoVC animated:YES];
        }
    }];
}

#pragma mark - SJPhotoProtocol
- (void)photoController:(SJPhotosController *)photoVC didSelectedPhotos:(NSArray<SJPhotoModel *> *)photos
{
    void(^uploadSuccessBlock)(NSString *) = ^(NSString *newUrl) {
        [JAUserPresenter postUpdateUserHeadImg:newUrl Result:^(JAResponseModel * _Nullable model) {
            [self.headerView.porImageView sd_setImageWithURL:[NSURL URLWithString:newUrl] placeholderImage:[UIImage imageNamed:@"default_portrait"]];
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (model.success) {
                    SPLocalInfo.userModel.avatarUrl = newUrl;
                    [self updateUserInfo];
                } else {
                    [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                }
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            });
        }];
    };
    SJPhotoModel *photoModel = photos.firstObject;
    NSData *imageData = UIImageJPEGRepresentation(photoModel.resultImage, 0.8);
    [SVProgressHUD show];
    [JAFileUploadPresenter uploadFile:nil fileData:imageData fileDataKey:@"file" progress:nil success:^(id dataObject) {

        uploadSuccessBlock(dataObject[@"url"]);
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
    }];
}

#pragma mark - footerView
-(UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc] init];
        CGFloat height = 100;
        if ((523 + kNavBarHeight + 100) > kScreenHeight) {
            height = 100;
        } else {
            height = kScreenHeight - kNavBarHeight - 523;
        }
        _footerView.frame = CGRectMake(0, 0, kScreenWidth, height);
        UIButton *logOutBtn = [[UIButton alloc] init];
        [logOutBtn setTitle:@"退出账号" forState:UIControlStateNormal];
        [logOutBtn setTitleColor:SJ_TITLE_COLOR forState:UIControlStateNormal];
        logOutBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [logOutBtn addTarget:self action:@selector(logoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
        logOutBtn.backgroundColor = [UIColor whiteColor];
        [_footerView addSubview:logOutBtn];
        [logOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_footerView);
            make.right.equalTo(self->_footerView);
            make.bottom.equalTo(self->_footerView).with.offset(-20);
            make.height.equalTo(@50);
        }];
    }
    return _footerView;
}

#pragma mark - EVENT
- (void)logoutBtnClick {
    
    [JAUserPresenter postLogOut:SPLocalInfo.userModel.mobilePhone Result:^(JAResponseModel * _Nullable model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (model.success) {
                [SPLocalInfoModel shareInstance].hasBeenLogin = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_logoutSuccess object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                if ([model.responseStatus.code isEqualToString:@"9995"]) {
                    //用户未登录
                    [SPLocalInfoModel shareInstance].hasBeenLogin = NO;
                     [self.navigationController popViewControllerAnimated:YES];
                    return ;
                }
                [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            }
        });
    }];
}

#pragma mark - 个人信息设置
-(void)setInfoAction{
    SJAccountSettingsViewController *accountSettingsVC = [[SJAccountSettingsViewController alloc] init];
    accountSettingsVC.titleName = @"    ";
    [self.navigationController pushViewController:accountSettingsVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SJSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SJSettingTableViewCell" forIndexPath:indexPath];
    NSString *imageStr = [self.imageArray objectAtIndex:indexPath.row];
//    [cell.imageView setImage:[UIImage imageNamed:imageStr]];
    cell.nameLabel.text = [self.nameArray objectAtIndex:indexPath.row];
    cell.describeLabel.hidden = YES;
    if (indexPath.row == 1) {
        cell.describeLabel.hidden = NO;
        if (SPLocalInfo.userModel.isIdentityVerified) {
            cell.describeLabel.text = @"已认证";
            cell.describeLabel.textColor = SJ_TITLE_COLOR;
        } else {
            cell.describeLabel.text = @"未认证";
            cell.describeLabel.textColor = HEXCOLOR(@"FFBB04");
        }
    }
    if (indexPath.row == 2) {
        cell.describeLabel.hidden = NO;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSUInteger size = [[SDImageCache sharedImageCache] getSize];
            NSString *content = [NSString stringWithFormat:@"%.2fM", size/1024/1024.00];
            if ([content isEqualToString:@"0.00M"]) {
                content = @"暂无缓存";
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.describeLabel.text = content;
            });
        });
    }
    if (indexPath.row == 4) {
        cell.describeLabel.hidden = NO;
        NSString *versionStr =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        cell.describeLabel.text = [NSString stringWithFormat:@"当前版本: V %@", versionStr];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
            SJPersonInfoViewController *personInfoVC = [[SJPersonInfoViewController alloc] init];
            personInfoVC.titleName = @"账号设置";
            [self.navigationController pushViewController:personInfoVC animated:YES];
    } else if (indexPath.row == 1 && !SPLocalInfo.userModel.isIdentityVerified) {
        SJRealNameViewController *realNameVC = [[SJRealNameViewController alloc] init];
        realNameVC.titleName = @"实名认证";
        [self.navigationController pushViewController:realNameVC animated:YES];
    } else if (indexPath.row == 2) {
        
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            
            [self.mainTableView reloadData];
            [SVProgressHUD  showSuccessWithStatus:@"清理成功"];
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        }];
    } else if (indexPath.row == 3) {
        SJFeedbackViewController *feedbackVC = [[SJFeedbackViewController alloc] init];
        feedbackVC.titleName = @"搜索反馈";
        [self.navigationController pushViewController:feedbackVC animated:YES];
//        } else if (indexPath.row == 1) {
//             LogD(@"检查更新");
//            [self updateVersion];
        } else if (indexPath.row == 4) {
             LogD(@"关于鸟斯基");
            SJDetailController *detailVC = [[SJDetailController alloc] init];
            detailVC.titleName = @"关于鸟斯基";
            detailVC.detailStr = [NSString stringWithFormat:@"%@/aboutNsj", JA_SERVER_WEB];
            dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController showViewController:detailVC
                                               sender:nil];
    });
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.nameArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 70;
    }
    return 57;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 10;
}

- (void)updateVersion {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"https://itunes.apple.com/lookup?id=1403770105" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *array = responseObject[@"results"];
            NSDictionary *dict = [array lastObject];
             LogD(@"当前版本为：%@", dict[@"version"]);
            //获取AppStore的版本号
            NSString * versionStr = dict[@"version"];
            NSString *versionStr_int=[versionStr stringByReplacingOccurrencesOfString:@"."withString:@""];
            int version=[versionStr_int intValue];
            //获取本地的版本号
            NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]; // 就是在info.plist里面的 version
            NSString *currentVersion_int=[currentVersion stringByReplacingOccurrencesOfString:@"."withString:@""];
            int current=[currentVersion_int intValue];
            if(version>current){
                SJAlertModel *alertModel = [[SJAlertModel alloc] initWithTitle:@"确认" handler:^(id content) {
                    
                    NSString *appstoreUrlString = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1403770105";
                    NSString *appstoreUrlString1 = @"itms-apps://itunes.apple.com/app/id1403770105";
                    NSURL * url = [NSURL URLWithString:appstoreUrlString];
                    if (@available(iOS 11.0, *)) {
                        
                        url = [NSURL URLWithString:appstoreUrlString1];
                    }
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication]openURL:url];
                    } else {
                        LogD(@"can not open");
                    }
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1403770105?mt=8"]];
                }];
                SJAlertModel *cancelModel = [[SJAlertModel alloc] initWithTitle:@"取消" handler:^(id content) {
                }];
                SJAlertView *alertView = [SJAlertView alertWithTitle:@"去app store 更新最新版" message:@"" type:SJAlertShowTypeNormal alertModels:@[alertModel,cancelModel]];
                [alertView showAlertView];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"当前版本已是最新"];
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败！" ];
        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
    }];
}


@end
