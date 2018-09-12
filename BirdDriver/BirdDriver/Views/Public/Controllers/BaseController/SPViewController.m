//
//  SPViewController.m
//  BirdDriver
//
//  Created by Soul.Geng on 17/3/25.
//  Copyright © 2017年 com.hexianghang. All rights reserved.
//

#import "SPViewController.h"
#import "SJBackButton.h"
#import <UMMobClick/MobClick.h>

@interface SPViewController ()

@end

@implementation SPViewController

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = JMY_BG_COLOR;
    self.edgesForExtendedLayout = UIRectEdgeNone;

    // Do any additional setup after loading the view.
//    self.navigationController.navigationBar.tintColor = JMY_MAIN_COLOR;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Set_back"] style:UIBarButtonItemStylePlain target:self action:@selector(popToBack)];
    
    /**
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:18.0f];
    CGSize size = [self.titleName boundingRectWithSize:CGSizeMake(kScreenWidth/2, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    UIImage *backImage = [UIImage imageNamed:@"Set_back"];
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat titleImageMargin = 10;
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.size = CGSizeMake(size.width + backImage.size.width * scale + titleImageMargin * 2, MIN(backImage.size.height * scale + titleImageMargin*2, 45));
    [backBtn setTitle:self.titleName  forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font = font;
    
    backBtn.backgroundColor = [UIColor redColor];
    backBtn.imageView.backgroundColor = [UIColor blueColor];
    backBtn.titleLabel.backgroundColor = [UIColor yellowColor];
    //-5微调
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, backBtn.width - backImage.size.width * scale);
    backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -titleImageMargin*0.5, 0, -titleImageMargin*4);
    backBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [backBtn setImage:backImage forState:UIControlStateNormal];
     */
    SJBackButton *backBtn = [SJBackButton buttonWithType:UIButtonTypeCustom];
    backBtn.titleStr = self.titleName;
    backBtn.imageStr = @"Set_back";
    [backBtn addTarget:self action:@selector(popToBack)forControlEvents:UIControlEventTouchDown];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)setTitleName:(NSString *)titleName
{
    _titleName = [titleName copy];
    SJBackButton *backBtn = self.navigationItem.leftBarButtonItem.customView;
    [backBtn setTitleStr:titleName];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.titleName];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //  防止IQKeyBoard异常
    [self.view endEditing:YES];
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.titleName];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
    }
}


- (void)popToBack{
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.navigationController.viewControllers.count>1){
            [self.navigationController popViewControllerAnimated:YES];
        }
    });
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

@end
