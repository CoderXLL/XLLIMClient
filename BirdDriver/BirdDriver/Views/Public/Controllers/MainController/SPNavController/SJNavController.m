//
//  SJNavController.m
//  BirdDriver
//
//  Created by Soul on 2018/5/16.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "SJNavController.h"

@interface SJNavController ()

@end

@implementation SJNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /**
    // 获取系统手势的target对象
    id tagart = self.interactivePopGestureRecognizer.delegate;
    // 创建手势调用系统的方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:tagart action:@selector(handleNavigationTransition:)];
    // 添加手势
    [self.view addGestureRecognizer:pan];
    // 设置手势的代理
    pan.delegate = self;
    // 禁能系统的手势
    self.interactivePopGestureRecognizer.enabled = NO;
     */
    
    UINavigationBar *navigationBar = self.navigationBar;
    navigationBar.layer.shadowColor = [UIColor colorWithHexString:@"2B3248" alpha:1.0].CGColor;
    navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
    navigationBar.layer.shadowOpacity = 0.1;
    navigationBar.layer.shadowRadius = 8;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, navigationBar.bounds);
    navigationBar.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
}

- (void)handleNavigationTransition:(UIPanGestureRecognizer*)ges
{
    LogD(@"handleNavigationTransition = %@", ges)
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
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
