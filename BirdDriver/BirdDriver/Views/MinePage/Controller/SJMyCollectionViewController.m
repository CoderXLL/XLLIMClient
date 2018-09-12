//
//  SJMyCollectionViewController.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/19.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//
// 我的收藏

#import "SJMyCollectionViewController.h"
#import "SJCollectionActivityController.h"
#import "SJCollectionNoteController.h"
#import "SJMyCollectionNavView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SJMyCollectionViewController ()

@property (nonatomic, weak) UIScrollView *scrollView;
@property(strong, nonnull)SJMyCollectionNavView *rightView;

@end

@implementation SJMyCollectionViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.rightView = [[SJMyCollectionNavView alloc] init];
    CGRect navFrame = self.rightView.frame;
    navFrame.size = CGSizeMake(120, 35);
    self.rightView.frame = navFrame;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightView];
    
    [self.rightView.activityBtn addTarget:self action:@selector(selectActivityAction) forControlEvents:UIControlEventTouchUpInside];
    [self.rightView.noteBtn addTarget:self action:@selector(selectNoteAction) forControlEvents:UIControlEventTouchUpInside];
    [self selectNoteAction];
    
    [self setupSubViews];
    [self setupSubControllers];
}

- (void)setupSubViews
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(2*kScreenWidth, kScreenHeight);
    scrollView.scrollEnabled = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

- (void)setupSubControllers
{
    SJCollectionNoteController *noteVC = [[SJCollectionNoteController alloc] init];
    [self.scrollView addSubview:noteVC.view];
    [self addChildViewController:noteVC];
    
    SJCollectionActivityController *activityVC = [[SJCollectionActivityController alloc] init];
    [self.scrollView addSubview:activityVC.view];
    [self addChildViewController:activityVC];
}

#pragma mark - 活动
-(void)selectActivityAction{
    if (self.rightView.activityBtn.isSelected) {
        return;
    } else {
        self.rightView.activityBtn.selected = YES;
        self.rightView.noteBtn.selected = NO;
        [self.scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:NO];
    }
}

#pragma mark - 帖子
-(void)selectNoteAction{
    if (self.rightView.noteBtn.isSelected) {
        return;
    } else {
        self.rightView.activityBtn.selected = NO;
        self.rightView.noteBtn.selected = YES;
        [self.scrollView setContentOffset:CGPointZero animated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.scrollView.frame = self.view.bounds;
    for (NSInteger i = 0; i < self.childViewControllers.count; i++)
    {
        UIViewController *childVC = self.childViewControllers[i];
       childVC.view.frame = CGRectMake(i*kScreenWidth, 0, kScreenWidth, kScreenHeight);
    }
}

@end
