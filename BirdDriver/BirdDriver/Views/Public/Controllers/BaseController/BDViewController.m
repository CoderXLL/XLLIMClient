//
//  BDViewController.m
//  BirdDriver
//
//  Created by Soul on 2017/9/18.
//  Copyright © 2017年 Soul&Polo. All rights reserved.
//

#import "BDViewController.h"
#import "UIImage+ColorsImage.h"

@interface BDViewController ()

@property (strong ,nonatomic) UILabel *navLabel;

@end

@implementation BDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = JMY_BG_COLOR;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.titleView = self.navLabel;
    
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"web_fh"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(popToBack)];
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    //禁止左滑手势
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UILabel *)navLabel{
    if (!_navLabel) {
        _navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth-120, 44)];
        _navLabel.textAlignment = NSTextAlignmentLeft;
        _navLabel.text = @"iPhone X";
        _navLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:18];
        _navLabel.textColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1];
        //        _navLabel.backgroundColor = [UIColor redColor];
    }
    return _navLabel;
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    self.navigationItem.title = title;
    self.navLabel.text = title;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
