//
//  SJLoadingController.m
//  BirdDriver
//
//  Created by liuzhangyong on 2018/7/12.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJLoadingController.h"

@interface SJLoadingController ()

@property (nonatomic, weak) UIImageView *loadingView;
@property (nonatomic, weak) UILabel *tipsLabel;

@end

@implementation SJLoadingController
static SJLoadingController *instance_ = nil;

+ (instancetype)shareLoadingController
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance_ = [[[self class] alloc] init];
    });
    return instance_;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableArray* iconArrM = [NSMutableArray array];
    for (NSInteger i=0; i<6; i++) {
        NSString* icon = [NSString stringWithFormat:@"sj_load_%02zd", i];
        UIImage* iconImage = [UIImage imageNamed:icon];
        [iconArrM addObject:iconImage];
    }
    
    UIImage* iconImage = iconArrM.firstObject;
    
    UIImageView* loadingView = [[UIImageView alloc] init];
    loadingView.size = iconImage.size;
    loadingView.animationImages = iconArrM;
    loadingView.animationDuration = 0.75;//设置动画时间
    loadingView.animationRepeatCount = 0;//设置动画次数 0 表示无限
    loadingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:loadingView];
    self.loadingView = loadingView;
    
    UILabel* tipsLabel = [[UILabel alloc] init];
    tipsLabel.font = SPFont(14.0);
    tipsLabel.textColor = [UIColor grayColor];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipsLabel];
    self.tipsLabel = tipsLabel;
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - setter
- (void)setShowing:(BOOL)showing
{
    _showing = showing;
    if (showing) {
        [self.loadingView startAnimating];
    } else {
        [self.loadingView stopAnimating];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.loadingView.center = CGPointMake(self.view.center.x, self.view.center.y - 15.0);
    self.tipsLabel.frame = CGRectMake(0, CGRectGetMaxY(self.loadingView.frame), self.view.width, 50.0);
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
