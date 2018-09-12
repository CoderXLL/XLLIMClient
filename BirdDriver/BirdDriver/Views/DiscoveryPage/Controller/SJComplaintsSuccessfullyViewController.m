//
//  SJComplaintsSuccessfullyViewController.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/7/18.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJComplaintsSuccessfullyViewController.h"

#import "SJNoteDetailController.h"
#import "SJFootprintDetailsController.h"
#import "SJNoteCommentController.h"
#import "SJNoteSubReplyController.h"

@interface SJComplaintsSuccessfullyViewController ()

@end

@implementation SJComplaintsSuccessfullyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.confirmBtn.customBtnTitle = @"确认";
    self.confirmBtn.customBtnEnable = YES;
    self.confirmBtn.customBtnGradientColors = @[HEXCOLOR(@"303850"),HEXCOLOR(@"6E7EAF")];
    self.confirmBtn.customBtnTitleColor = HEXCOLOR(@"FFBB04");
    self.confirmBtn.cornerRadius = 22.0f;
    [self.confirmBtn customButtonClick:^(UIButton *button) {
        //确认
        for (NSInteger i = self.navigationController.childViewControllers.count-1; i>=0; i--)
        {
            UIViewController *childVC = self.navigationController.childViewControllers[i];
            if ([childVC isKindOfClass:[SJNoteDetailController class]]
                ||[childVC isKindOfClass:[SJFootprintDetailsController class]] || [childVC isKindOfClass:[SJNoteCommentController class]] || [childVC isKindOfClass:[SJNoteSubReplyController class]])
            {
                [self.navigationController popToViewController:childVC animated:YES];
                break;
                return ;
            }
        }
        
    }];
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
