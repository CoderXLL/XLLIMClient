//
//  SJReportIllegalController.m
//  BirdDriver
//
//  Created by Soul on 2018/7/17.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJReportIllegalController.h"
#import "SJComplaintsSuccessfullyViewController.h"

#import "SJGradientButton.h"

#import "JABbsPresenter.h"

@interface SJReportIllegalController ()

@property (weak, nonatomic) IBOutlet UILabel *lbl_reportUser;
@property (weak, nonatomic) IBOutlet UILabel *lbl_reportTitle;
@property (weak, nonatomic) IBOutlet SJGradientButton *btn_report;

@property (weak, nonatomic) IBOutlet UIButton *btn_1;
@property (weak, nonatomic) IBOutlet UIButton *btn_2;
@property (weak, nonatomic) IBOutlet UIButton *btn_3;
@property (weak, nonatomic) IBOutlet UIButton *btn_4;
@property (weak, nonatomic) IBOutlet UIButton *btn_5;
@property (weak, nonatomic) IBOutlet UIButton *btn_6;
@property (weak, nonatomic) IBOutlet UIButton *btn_7;

@end

@implementation SJReportIllegalController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.titleName= @"举报";
    self.view.backgroundColor = SP_WHITE_COLOR;
    [self.btn_report setEnabled:YES];
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

- (IBAction)chooseReportType:(UIButton *)sender {
    LogD(@"点击%ld Tag",sender.tag);
    if (sender.selected) {
        [sender setSelected:NO];
    }else{
        [sender setSelected:YES];
    }
    
    [sender setImage:[UIImage imageNamed:@"report_clicked_icon"] forState:UIControlStateSelected];
    [sender setImage:[UIImage imageNamed:@"report_toclick_icon"] forState:UIControlStateNormal];
}

- (IBAction)commitReport:(id)sender {
    LogD(@"提交举报...%ld...id活动",self.activityModel.detail.Id);
    
    NSArray *btnArr = @[
                        self.btn_1,
                        self.btn_2,
                        self.btn_3,
                        self.btn_4,
                        self.btn_5,
                        self.btn_6,
                        self.btn_7,
                        ];
    NSMutableArray *tagArr = [[NSMutableArray alloc] init];
    NSMutableString *resonStr = [[NSMutableString alloc] init];
    for (UIButton *btn in btnArr) {
        if ([btn isSelected]) {
            [tagArr addObject:[NSNumber numberWithInteger:btn.tag]];
            [resonStr appendString:[btn titleForState:UIControlStateNormal]];
        }
    }
    
    //帖子
    [SVProgressHUD show];
    [JABbsPresenter postReport:self.activityModel.detail.Id
                        reason:resonStr
                    reportType:tagArr
                        Result:^(JAResponseModel * _Nullable model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (model.success) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(didReportSuccessful)]) {
                    [self.delegate didReportSuccessful];
                }
                
                [self.btn_report setTitle:@"已举报，审核中" forState:UIControlStateDisabled];
                [self.btn_report setTitleColor:SP_WHITE_COLOR forState:UIControlStateDisabled];
                [self.btn_report setBackgroundColor:HEXCOLOR(@"CCCCCC")];
                [self.btn_report setEnabled:NO];
                
                SJComplaintsSuccessfullyViewController *successVC = [[SJComplaintsSuccessfullyViewController alloc] init];
                dispatch_async(dispatch_get_main_queue(), ^{
                     [self.navigationController pushViewController:successVC animated:YES];
                    [SVProgressHUD dismiss];
                });
            } else {
                [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            }
        });
    }];
}

- (void)setActivityModel:(JABBSModel *)activityModel{
    _activityModel = activityModel;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(activityModel.nickName){
            self.lbl_reportUser.text = [NSString stringWithFormat:@"@%@",activityModel.nickName];
        }
        
        if (activityModel.detail.detailsName) {
            self.lbl_reportTitle.text = activityModel.detail.detailsName;
        }
    });
}



@end
