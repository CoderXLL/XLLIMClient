//
//  SJFeedbackViewController.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//
// 反馈

#import "SJFeedbackViewController.h"
#import "SJFeedbackFootView.h"
#import "JAUserPresenter.h"

@interface SJFeedbackViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,retain)UITableView *mainTableView;
@property(strong, nonnull)SJFeedbackFootView *footView;


@property(nonatomic,strong)NSArray *nameArray;


@end

@implementation SJFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.nameArray = @[@"如何修改绑定的手机号？",
                       @"如何解绑手机？",
                       @"如何更改绑定的邮箱？",
                       @"游记发布后多久会通过审核？",
                       @"酒店、机票、自由行产品预定成功后，如何查询订单？"];

    [self.view addSubview:self.mainTableView];
    
    [self.footView.submitBtn customButtonClick:^(UIButton *button) {
        [JAUserPresenter postAddFeedBack:self.footView.contentTextView.text Result:^(JAResponseModel * _Nullable model) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(model.success){
                    [SVProgressHUD showSuccessWithStatus:@"反馈成功"];
                    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                }
            });
        }];
    }];
    
}
#pragma mark - mainTableView
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavBarHeight) style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = HEXCOLOR(@"FFFFFF");
        [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        _mainTableView.tableFooterView = self.footView;
        [_mainTableView setSeparatorInset:UIEdgeInsetsMake(0,15,0,15)];
        
    }
    return _mainTableView;
}

#pragma mark - footView
-(SJFeedbackFootView *)footView{
    if (!_footView) {
        _footView = [SJFeedbackFootView createCellWithXib];
        _footView.frame = CGRectMake(0, 0, kScreenWidth, 380);
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:@"*未能解决，反馈问题"];
        NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:@"*"].location, [[noteStr string] rangeOfString:@"*"].length);
        //需要设置的位置
        [noteStr addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(@"FF0000") range:redRange];
        //设置颜色
        [_footView.titleLabel setAttributedText:noteStr];
        _footView.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15.0f];
        _footView.contentTextView.layer.masksToBounds = YES;
        _footView.contentTextView.zw_placeHolder = @"请输入您的反馈结果，我们会在第一时间处理， 谢谢您！";
        _footView.submitBtn.customBtnTitle = @"提交";
        _footView.submitBtn.customBtnEnable = YES;
        _footView.submitBtn.customBtnGradientColors = @[HEXCOLOR(@"303850"),HEXCOLOR(@"6E7EAF")];
        _footView.submitBtn.customBtnTitleColor = HEXCOLOR(@"FFBB04");
        _footView.submitBtn.cornerRadius = 22.0f;
        [_footView.serviceBtn addTarget:self action:@selector(serviceAlertAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footView;
}

#pragma mark - 提交
-(void)submitAction{
     LogD(@"提交");
}

#pragma mark - 客服弹窗
-(void)serviceAlertAction{
    SJAlertModel *alertModel = [[SJAlertModel alloc] initWithTitle:@"确认" handler:^(id content) {
        LogD(@"拨打客服电话")
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://4008234778"]];
    }];
    SJAlertModel *cancelModel = [[SJAlertModel alloc] initWithTitle:@"取消" handler:^(id content) {
    }];
    //kService_Tel
    SJAlertView *alertView = [SJAlertView alertWithTitle:[NSString stringWithFormat:@"客服电话：%@\n是否立即拨打？", kService_Tel] message:@"" type:SJAlertShowTypeNormal alertModels:@[alertModel,cancelModel]];
    [alertView showAlertView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.nameArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.textColor = SJ_TITLE_COLOR;
    cell.textLabel.numberOfLines = 0;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.footView.contentTextView.text = [self.nameArray objectAtIndex:indexPath.row];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.nameArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 43;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 47;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 47)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth, 47)];
    [headerView addSubview:label];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:@"*常见问题"];
    NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:@"*"].location, [[noteStr string] rangeOfString:@"*"].length);
    //需要设置的位置
    [noteStr addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(@"FF0000") range:redRange];
    //设置颜色
    [label setAttributedText:noteStr];
    return headerView;
}





@end
