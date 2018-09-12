//
//  SJBannerView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/6/5.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJBannerView.h"
#import "SJHomeRecViewCell.h"

#define MAXBannerCount 1000 * self.dataSource.count
#define DefaultBannerCount MAXBannerCount * 0.5

@interface SJBannerView () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSInteger _currentIndex;
    BOOL _isNotFirstLayout;
}

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UIPageControl *pageControl;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SJBannerView
static NSString *const ID = @"SJHomeRecViewCell";

#pragma mark - lazy loading
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil)
    {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 0; i < 3; i++)
        {
            NSString *imageName = [NSString stringWithFormat:@"1.jpg"];
            UIImage *image = [UIImage imageNamed:imageName];
            [arr addObject:image];
            [self addTimer];
        }
        _dataSource = arr; 
    }
    return _dataSource;
}


- (UICollectionViewFlowLayout *)flowLayout
{
    if (_flowLayout == nil)
    {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.sectionInset = UIEdgeInsetsZero;
    }
    return _flowLayout;
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
     UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
     layout.itemSize = CGSizeMake(kScreenWidth, 170);
     layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
     layout.minimumLineSpacing = 6;
     layout.minimumInteritemSpacing = 15;
     layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    [collectionView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = self.dataSource.count;
    pageControl.currentPage = 0;
    pageControl.hidesForSinglePage = YES;
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self addSubview:pageControl];
    self.pageControl = pageControl;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return MAXBannerCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SJHomeRecViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SJHomeRecViewCell class]) forIndexPath:indexPath];
    if (!cell) {
        cell = [SJHomeRecViewCell new];
    }
//    cell.bannerModel = self.bannerList[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![scrollView isEqual:self.collectionView]) return;
    _currentIndex = roundf(scrollView.contentOffset.x / self.flowLayout.itemSize.width);
    self.pageControl.currentPage = _currentIndex % self.dataSource.count;
}

// 添加定时器
- (void)addTimer
{
    [self removeTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(nextImage:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

// 移除定时器
- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)nextImage:(NSTimer *)timer
{
    if (_currentIndex % self.dataSource.count == 0) {
        
        [self scrollToItemAtIndex:DefaultBannerCount animated:NO];
        _currentIndex = DefaultBannerCount;
    }
    _currentIndex ++;
    [self scrollToItemAtIndex:_currentIndex animated:YES];
}

- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated
{
    CGFloat contentOffsetX = index * self.flowLayout.itemSize.width;
    [self.collectionView setContentOffset:CGPointMake(contentOffsetX, 0) animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
    self.pageControl.frame = CGRectMake(15, self.height - 20, self.width - 30, 20);
    self.flowLayout.itemSize = CGSizeMake(self.collectionView.width, self.collectionView.height);
    if (!_isNotFirstLayout)
    {
        _isNotFirstLayout = YES;
        _currentIndex = DefaultBannerCount;
        [self scrollToItemAtIndex:_currentIndex animated:NO];
    }
}

- (void)dealloc
{
    [self removeTimer];
}

@end

