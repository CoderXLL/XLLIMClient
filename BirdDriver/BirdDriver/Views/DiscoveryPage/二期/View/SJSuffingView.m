//
//  SJSuffingView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/20.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.

#import "SJSuffingView.h"
#import "SJSuffingCell.h"
#import "JANotificationConstant.h"

static NSString *const ID = @"SJSuffingCell";

// 每一组最大的行数
#define SJTotalRowsInSection (5000 * self.bannerList.count)
#define SJDefaultRow (NSUInteger)(SJTotalRowsInSection * 0.5)

@interface SJSuffingView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) UICollectionView* collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout* layout;
/** 当没有轮播图的时候,让其显示默认图 */
@property (nonatomic, weak) UIImageView* placeholderView;

@end

@implementation SJSuffingView

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startScrollTab:) name:kNotify_routeScrollUnEnable object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endScrollTab:) name:kNotify_routeScrollEnable object:nil];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.layout = layout;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.pagingEnabled = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    // addView
    UIImageView* placeholderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_bannner"]];
    placeholderView.contentMode = UIViewContentModeScaleAspectFill;
    placeholderView.clipsToBounds = YES;
    placeholderView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [placeholderView addGestureRecognizer:tapGesture];
    [self addSubview:placeholderView];
    self.placeholderView = placeholderView;
}

- (void)setBannerList:(NSArray *)bannerList
{
    _bannerList = bannerList;
    self.collectionView.scrollEnabled = NO;
    NSInteger count = bannerList.count;
    if (count == 0)
    {
        self.collectionView.delegate = nil;
        self.collectionView.dataSource = nil;
        self.placeholderView.hidden = NO;
    } else if (count == 1) {
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.placeholderView.hidden = YES;
        // 刷新数据
        [self.collectionView reloadData];
    } else {
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        // 刷新数据
        [self.collectionView reloadData];
        self.placeholderView.hidden = YES;
        self.collectionView.scrollEnabled = YES;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!kArrayIsEmpty(self.bannerList)) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:SJDefaultRow inSection:0];
                [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            }
        });
    }
    [self setNeedsLayout];
}

#pragma mark - notification
- (void)startScrollTab:(NSNotification *)notification
{
    self.collectionView.scrollEnabled = NO;
}

- (void)endScrollTab:(NSNotification *)notification
{
    //这里不延迟0.1秒，在iphoneX上会出现莫名layout布局错误
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.collectionView.scrollEnabled = (self.bannerList.count>1);
    });
}

#pragma mark - 数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return SJTotalRowsInSection;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SJSuffingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.isRadius = self.isRadius;
    cell.imageUrl = self.bannerList[indexPath.item % self.bannerList.count];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(suffingView:didSelectedIndex:)])
    {
        [self.delegate suffingView:self didSelectedIndex:indexPath.item];
    }
}

- (void)tapClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(suffingView:didSelectedIndex:)])
    {
        [self.delegate suffingView:self didSelectedIndex:0];
    }
}

/**
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *visiablePath = [[collectionView indexPathsForVisibleItems] firstObject];
    NSInteger index = visiablePath.item % self.bannerList.count + 1;
    if (self.delegate && [self.delegate respondsToSelector:@selector(suffingView:scrollToIndex:)])
    {
        [self.delegate suffingView:self scrollToIndex:index];
    }
}
*/

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![scrollView isEqual:self.collectionView]) return;
    NSInteger currentIndex = roundf(scrollView.contentOffset.x / self.layout.itemSize.width);
    NSInteger index = currentIndex % self.bannerList.count+1;
    if (self.delegate && [self.delegate respondsToSelector:@selector(suffingView:scrollToIndex:)])
    {
        [self.delegate suffingView:self scrollToIndex:index];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
    self.layout.itemSize = CGSizeMake(kScreenWidth, self.collectionView.height);
    if (self.isRadius) {
        self.placeholderView.frame = CGRectMake(kSJMargin, 0, self.collectionView.width-2*kSJMargin, self.collectionView.height);
    } else {
        self.placeholderView.frame = self.collectionView.bounds;
    }
}

@end

