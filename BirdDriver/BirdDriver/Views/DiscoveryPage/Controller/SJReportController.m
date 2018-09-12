//
//  SJReportController.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/18.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJReportController.h"
#import "SJComplaintsSuccessfullyViewController.h"
#import "SJReportTitleCell.h"
#import "SJReportChooseCell.h"
#import "SJGradientButton.h"
#import "SJBuildNoteFooterView.h"
#import "JABBSModel.h"
#import "JABbsPresenter.h"
#import "JAForumPresenter.h"
#import "SJAlertView.h"

@interface SJReportController () <SJBuildNoteFooterViewDelegate>

@property (nonatomic, strong) NSArray *reportReason;

@end

@implementation SJReportCommentModel

@end

@implementation SJReportController
static NSString *const footerID = @"SJBuildNoteFooterView";

#pragma mark - lazy loading
- (NSArray *)reportReason
{
    if (_reportReason == nil)
    {
        /**
        评论：垃圾营销、色情低谷、反动言论、恶意谣言、谩骂、欺诈信息、违法信息
        帖子：垃圾营销、不实信息、有害信息、违法信息、淫秽色情、人身攻击我、抄袭我的内容
         */
        SJReportChooseModel *firstModel = [[SJReportChooseModel alloc] init];
        firstModel.reason = @"垃圾营销";
        
        SJReportChooseModel *secondModel = [[SJReportChooseModel alloc] init];
        secondModel.reason = self.reportStyle == SJReportStyleReply?@"色情低俗":@"不实信息";
        SJReportChooseModel *thirdModel = [[SJReportChooseModel alloc] init];
        thirdModel.reason = self.reportStyle == SJReportStyleReply?@"反动言论":@"有害信息";
        SJReportChooseModel *forthModel = [[SJReportChooseModel alloc] init];
        forthModel.reason = self.reportStyle == SJReportStyleReply?@"恶意谣言":@"违法信息";
        SJReportChooseModel *fifthModel = [[SJReportChooseModel alloc] init];
        fifthModel.reason = self.reportStyle == SJReportStyleReply?@"谩骂":@"淫秽色情";
        SJReportChooseModel *sixModel = [[SJReportChooseModel alloc] init];
        sixModel.reason = self.reportStyle == SJReportStyleReply?@"欺诈信息":@"人身攻击我";
        SJReportChooseModel *sevenModel = [[SJReportChooseModel alloc] init];
        sevenModel.reason = self.reportStyle == SJReportStyleReply?@"违法信息":@"抄袭我的内容";
        _reportReason = @[
                          firstModel,
                          secondModel,
                          thirdModel,
                          forthModel,
                          fifthModel,
                          sixModel,
                          sevenModel
                          ];
    }
    return _reportReason;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listView.backgroundColor = [UIColor whiteColor];
    self.titleName = @"投诉";
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        NSString *contentText = @"";
        if (self.reportStyle == SJReportStyleNote) {
            contentText = self.detailModel.detail.detailsName;
        } else {
            contentText = [NSString stringWithFormat:@"%@：%@", self.commentModel.replyUserName, self.commentModel.replyContent];
        }
        CGFloat contentHeight = [contentText boundingRectWithSize:CGSizeMake(tableView.width-2*kSJMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SPFont(16.0)} context:nil].size.height;
        contentHeight = MAX(contentHeight+30, 54);
        return contentHeight+58;
    }
    return 200.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    SJBuildNoteFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerID];
    if (footerView == nil)
    {
        [tableView registerClass:NSClassFromString(footerID) forHeaderFooterViewReuseIdentifier:footerID];
        footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerID];
    }
    footerView.delegate = self;
    footerView.titleStr = @"举报TA";
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        SJReportTitleCell *cell = [SJReportTitleCell xibCell:tableView];
        if (self.reportStyle == SJReportStyleNote) {
            cell.model = self.detailModel;
        } else {
            cell.model = self.commentModel;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    SJReportChooseCell *cell = [SJReportChooseCell cell:tableView];
    cell.reportReason = self.reportReason;
    return cell;
}

#pragma mark - SJBuildNoteFooterViewDelegate
- (void)didClickFooterBtn
{
    NSMutableArray *selectedModel = [NSMutableArray array];
    for (SJReportChooseModel *chooseModel in self.reportReason) {
        if (chooseModel.isSelected) {
            [selectedModel addObject:chooseModel];
            break;
        }
    }
    if (kArrayIsEmpty(selectedModel)) {
        //弹窗
        SJAlertModel *alertModel = [[SJAlertModel alloc] initWithTitle:@"知道啦" handler:^(id content) {
            
        }];
        SJAlertView *alertView = [SJAlertView alertWithTitle:@"请至少选择一个投诉原因" message:@"" type:SJAlertShowTypeNormal alertModels:@[alertModel]];
        [alertView showAlertView];
        return;
    }
    
    SJReportChooseModel *chooseModel = selectedModel.firstObject;
    if (self.reportStyle == SJReportStyleReply)
    {
        [SVProgressHUD show];
        NSInteger reportType = [self.reportReason indexOfObject:chooseModel]+1;
        [JAForumPresenter postComplainComment:self.commentModel.replyId blackTypes:[NSString stringWithFormat:@"%zd", reportType] blackReason:nil Result:^(JAResponseModel * _Nullable model) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (model.success) {
                    if (self.reportSuccess) {
                        self.reportSuccess();
                    }
                    SJComplaintsSuccessfullyViewController *successVC = [[SJComplaintsSuccessfullyViewController alloc] init];
                    [self.navigationController pushViewController:successVC animated:YES];
                    [SVProgressHUD dismiss];
                } else {
                    [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                }
            });
        }];
    } else {
        NSInteger reportType = [self.reportReason indexOfObject:chooseModel]+1;
        //帖子
        [SVProgressHUD show];
        [JABbsPresenter postReport:self.detailModel.detail.Id reason:chooseModel.reason reportType:@[@(reportType)] Result:^(JAResponseModel * _Nullable model) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if (model.success) {
                    if (self.reportSuccess) {
                        self.reportSuccess();
                    }
                    SJComplaintsSuccessfullyViewController *successVC = [[SJComplaintsSuccessfullyViewController alloc] init];
                    [self.navigationController  pushViewController:successVC animated:YES];
                    [SVProgressHUD dismiss];
                } else {
                    [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                }
            });
        }];
    }
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

@end
