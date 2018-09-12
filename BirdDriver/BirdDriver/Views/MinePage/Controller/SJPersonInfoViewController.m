//
//  SJPersonInfoViewController.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//
// 账号设置

#import "SJPersonInfoViewController.h"
#import "SJPersonInfoTableViewCell.h"
#import "SJBindingPhoneController.h"
#import "SJAuthenticateViewController.h"
#import "SJBindingWeChatViewController.h"
#import "JAUserPresenter.h"

@interface SJPersonInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,retain)UITableView *mainTableView;
@property(nonatomic,strong)NSArray *nameArray;
@end

@implementation SJPersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nameArray = @[@"手机号", @"微信账号"];
    [self.view addSubview:self.mainTableView];
    
    
}
#pragma mark - mainTableView
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavBarHeight) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = HEXCOLOR(@"FFFFFF");
        [_mainTableView registerNib:[UINib nibWithNibName:@"SJPersonInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"SJPersonInfoTableViewCell"];
        _mainTableView.tableFooterView = [[UIView alloc] init];
        _mainTableView.separatorStyle = UITableViewCellEditingStyleNone;

    }
    return _mainTableView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SJPersonInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SJPersonInfoTableViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = [self.nameArray objectAtIndex:indexPath.row];
    cell.contentLabel.hidden = YES;
    if (indexPath.row == 0) {
        if(SPLocalInfo.userModel.isPhoneVerified){
            cell.contentLabel.hidden = NO;
            cell.contentLabel.text = [SPStringHandler replacingPhoneNumCharacters:SPLocalInfo.userModel.mobilePhone];
            cell.describeLabel.text = @"修改";
        } else {
            cell.contentLabel.hidden = YES;
            cell.describeLabel.text = @"未绑定";
        }
        cell.describeLabel.textColor = HEXCOLOR(@"FFBB04");
    } else {
        
        if (SPLocalInfo.userModel.whetherToBindWeiXin) {
            cell.describeLabel.text = @"已绑定";
            cell.describeLabel.textColor = SJ_TITLE_COLOR;
        } else {
            cell.describeLabel.text = @"未绑定";
            cell.describeLabel.textColor = HEXCOLOR(@"FFBB04");
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        if(SPLocalInfo.userModel.isPhoneVerified){
            SJAuthenticateViewController *authenticateVC = [[SJAuthenticateViewController alloc] init];
            authenticateVC.titleName = @"修改手机号";
            [self.navigationController pushViewController:authenticateVC animated:YES];
        } else {
            SJBindingPhoneController *bindingMobilePhoneVC = [[SJBindingPhoneController alloc] init];
            bindingMobilePhoneVC.titleName = @"绑定手机";
            [self.navigationController pushViewController:bindingMobilePhoneVC animated:YES];
        }
    } else if (indexPath.row == 1){
        if (SPLocalInfo.userModel.whetherToBindWeiXin) {
            SJAlertModel *alertModel = [[SJAlertModel alloc] initWithTitle:@"确认" handler:^(id content) {
                
                [JAUserPresenter postunBindWeChatResult:^(JAResponseModel * _Nullable model) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (model.success) {
                            
                            SPLocalInfo.userModel.whetherToBindWeiXin = NO;
                            [tableView reloadData];
                            [SVProgressHUD showSuccessWithStatus:@"解除微信绑定成功"];
                        } else {
                            [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                        }
                        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                    });
                }];
            }];
            SJAlertModel *cancelModel = [[SJAlertModel alloc] initWithTitle:@"取消" handler:^(id content) {
            }];
            SJAlertView *alertView = [SJAlertView alertWithTitle:@"是否确认解除绑定微信？" message:@"" type:SJAlertShowTypeNormal alertModels:@[alertModel,cancelModel]];
            [alertView showAlertView];
        } else {
            SJBindingWeChatViewController *bindingWeChatVC = [[SJBindingWeChatViewController alloc] init];
            bindingWeChatVC.titleName = @"绑定微信";
            [self.navigationController pushViewController:bindingWeChatVC animated:YES];
        }
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.nameArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


@end
