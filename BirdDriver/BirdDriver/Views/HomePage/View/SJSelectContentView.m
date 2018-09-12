//
//  SJSelectContentView.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/6/7.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJSelectContentView.h"
#import "SJSelectLabelCell.h"
#import "JAActivityListModel.h"
#import "SJNoDataFootView.h"
#import "UIScrollView+SJLeftRefresh.h"

 

@interface SJSelectContentView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) SJNoDataFootView *noDataView;

@end

@implementation SJSelectContentView
static NSString *const ID = @"SJSelectLabelCell";

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.leftRefreshView = [SJLeftRefreshView controlWithPullHandler:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (self.leftPullCallBack)
                    {
                        self.leftPullCallBack(self.listModel);
                    }
                    [collectionView.leftRefreshView endRefreshing];
                });
        }];
        [collectionView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
        [self addSubview:collectionView];
        self.collectionView = collectionView;
//        self.collectionView.backgroundColor = [UIColor blueColor];
        
        SJNoDataFootView *noDataView = [SJNoDataFootView createCellWithXib];
        noDataView.backgroundColor = [UIColor whiteColor];
        noDataView.exceptionStyle = SJExceptionStyleNoData;
        [self addSubview:noDataView];
        self.noDataView = noDataView;
    }
    return self;
}

- (void)setListModel:(JAActivityListModel *)listModel
{
    _listModel = listModel;
    if (kArrayIsEmpty(listModel.activitysList)) {
        if (!self.noDataView.superview) {
            [self insertSubview:self.noDataView aboveSubview:self.collectionView];
        }
    } else {
        if (self.noDataView.superview) {
            [self.noDataView removeFromSuperview];
        }
    }
    self.collectionView.leftRefreshView.hidden = (listModel.activitysList.count < 3);
    [self.collectionView setContentOffset:CGPointZero];
    [self.collectionView reloadData];
}

#pragma mark - delegate, dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listModel.activitysList.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //top原本为15，因为有精选标签
    return UIEdgeInsetsMake(10, 13, 5, 13);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = kScreenWidth *155.0f/375;
    CGSize size = CGSizeMake(width, 180.0f);
    return size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SJSelectLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.activityModel = self.listModel.activitysList[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JAActivityModel *activityModel = self.listModel.activitysList[indexPath.item];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_homeNoteDetail
                                                        object:activityModel];
    
    //埋点 - 首页精选标签->帖子详情
    NSString *nsjId = [NSString stringWithFormat:@"300104%02d",(int)indexPath.row+1];
    NSString *nsjDes = [NSString stringWithFormat:@"点击首页推荐帖子%@",activityModel.detailsName];
    [SJStatisticEventTool umengEvent:Nsj_Event_Home
                               NsjId:nsjId
                             NsjName:nsjDes];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
    self.noDataView.frame = self.bounds;
}



@end
