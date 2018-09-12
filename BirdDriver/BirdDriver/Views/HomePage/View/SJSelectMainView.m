//
//  SJSelectMainView.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/6/7.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJSelectMainView.h"
#import "SJSelectTabView.h"
#import "SJSelectContentView.h"
#import "JAHomeRecGroupModel.h"
#import "SJDiscoveryController.h"
#import "SJTabBarController.h"
#import "SJNavController.h"
#import "AppDelegate.h"
 

@interface SJSelectMainView ()

@property (nonatomic, strong) NSMutableDictionary *contentDict;
@property (nonatomic, weak) SJSelectTabView *tabView;
@property (nonatomic, weak) SJSelectContentView *contentView;

@end

@implementation SJSelectMainView

#pragma mark - lazy loading
- (NSMutableDictionary *)contentDict
{
    if (_contentDict == nil)
    {
        _contentDict = [NSMutableDictionary dictionary];
    }
    return _contentDict;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupBase];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setupBase];
    }
    return self;
}

- (void)setupBase
{
    SJSelectTabView *tabView = [[SJSelectTabView alloc] init];
    [self addSubview:tabView];
    self.tabView = tabView;
    
    SJSelectContentView *contentView = [[SJSelectContentView alloc] init];
    contentView.leftPullCallBack = ^(JAActivityListModel *listModel) {
        
        for (NSString *key in self.contentDict) {
            
            JAActivityListModel *model = self.contentDict[key];
            if ([model isEqual:listModel])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_homeJump object:key];
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                SJTabBarController *tabVC  = (SJTabBarController *)app.window.rootViewController;
                tabVC.selectedIndex = 1;
                break;
            }
        }
    };
    [self addSubview:contentView];
    self.contentView = contentView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clickIndex:)
                                                 name:@"lalala"
                                               object:nil];
}

#pragma mark - notification
// 点击首页“精选标签”的标签
- (void)clickIndex:(NSNotification *)notification
{
    NSInteger index = [notification.object integerValue];
    JAActivityListModel *listModel = [self.contentDict valueForKey:[NSString stringWithFormat:@"%zd", index]];
    self.contentView.listModel = listModel;
    
    JARecommendDetailSpolistModel *model = self.recommendDetailsPOList[index];
    NSString *nsjId = [NSString stringWithFormat:@"300103%02d",(int)index+1];
    NSString *nsjDes = [NSString stringWithFormat:@"点击首页精选标签%@",model.labelPO.labelName];
    [SJStatisticEventTool umengEvent:Nsj_Event_Home
                               NsjId:nsjId
                             NsjName:nsjDes];
}

#pragma mark - setter
- (void)setRecommendDetailsPOList:(NSArray *)recommendDetailsPOList
{
    _recommendDetailsPOList = recommendDetailsPOList;
    NSMutableArray *labels = [NSMutableArray arrayWithCapacity:recommendDetailsPOList.count];
    for (JARecommendDetailSpolistModel *spolistModel in recommendDetailsPOList) {
        NSInteger index = [recommendDetailsPOList indexOfObject:spolistModel];
        [self.contentDict setValue:spolistModel.detailsPO
                            forKey:[NSString stringWithFormat:@"%zd", index]];
        if (index == 0) {
            spolistModel.labelPO.isSelected = YES;
        }
        [labels addObject:spolistModel.labelPO];
    }
    self.tabView.labels = labels;
    JARecommendDetailSpolistModel *spolistModel = recommendDetailsPOList.firstObject;
    self.contentView.listModel = spolistModel.detailsPO;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tabView.frame = CGRectMake(0, 0, self.width, 30);
    self.contentView.frame = CGRectMake(0, CGRectGetMaxY(self.tabView.frame), self.width, self.height - self.tabView.height);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
